class RCMineWeapon extends UTWeapon;

var array<Flashbang> MinesList; //array of mines
var int MinesAllowed; // number of mines allowed
var bool NoMinePlanted; //true when you exploded all the mines
var vector stTrace,EnTrace;

simulated function Tick(float DeltaTime)
{
   	stTrace = InstantFireStartTrace();
    EnTrace	= InstantFireEndTrace(stTrace);
    CalcWeaponFire(stTrace,EnTrace);

}
simulated function ImpactInfo CalcWeaponFire(vector StartTrace, vector EndTrace, optional out array<ImpactInfo> ImpactList, optional vector Extent)
{
	local vector			HitLocation, HitNormal;
	local Actor				HitActor;
	local TraceHitInfo		HitInfo;
	local ImpactInfo		CurrentImpact;
	local GuideGameHUD GGH;
	local float playerdistance;
	local ActivateTrigger AT;
	local TrapTrigger TT;
	local StealableItem ST;
	HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, StartTrace, TRUE, vect(0,0,0), HitInfo, TRACEFLAG_Bullet);
	playerDistance = VSize( HitActor.Location - self.location );
	GGH = GuideGameHUD(GetALocalPlayerController().myHUD);

   if(HitActor.IsA('ActivateTrigger'))
	  {
		
	  	//ActivateTrigger(HitActor).Seen = true;
	  	//GGH.CrosshairImage = Texture2D'GuideIcon.lightbulb';
		if(playerdistance < ActivateTrigger(HitActor).MyRadius && ActivateTrigger(HitActor).bVisible)
		{
	  		
			ActivateTrigger(HitActor).FacingActivateTrigger = true;
			ActivateTrigger(HitActor).SwapPropMaterial();
			if(!ActivateTrigger(HitActor).IsA('NoteTrigger'))
			{ActivateTrigger(HitActor).TriggerRemoteKismetEvent(ActivateTrigger(HitActor).SetName);}
			if(ActivateTrigger(HitActor).ActivateText != "" && !ActivateTrigger(HitActor).checked && !GGH.ExitGame)
			{
								
				GGH.ActivateTriggerVisible = true;
				GGH.DisplayString = ActivateTrigger(HitActor).ActivateText;
				
			}
			 if(ActivateTrigger(HitActor).checked)
			{
				`log("checked !!!!!");
				GGH.ActivateTriggerVisible = false;
			}


		}
      }
	else if(HitActor.IsA('TrapTrigger'))
	{
		TrapTrigger(HitActor).FacingTrapTrigger = true;
		TrapTrigger(HitActor).SwapPropMaterial();
		TrapTrigger(HitActor).TriggerRemoteKismetEvent(TrapTrigger(HitActor).SetName);
	}
	else if(HitActor.IsA('StealableItem') && !GGH.ExitGame)
	{
		StealableItem(HitActor).FacingStealableItem = true;
		GGH.StealableItemVisible = true;
		GGH.DisplayString = StealableItem(HitActor).ActivateText;

	}
	else if(HitActor.IsA('LoadingTrigger') && !GGH.ExitGame)
	{
		GGH.LoadingTriggerVisible = true;
		GGH.DisplayString = LoadingTrigger(HitActor).ActivateText;
	}
	else if(HitActor.IsA('PickMeUp'))
	{
		
		BakanPawn(Owner).bFacingPickMeUp = true;

	}

	else if (HitActor.IsA('HowlEar'))
	{
		HowlEar(HitActor).UnhideAlertRing();
	}

	else if( HitActor != None )
	{

		// CrosshairImage = Texture2D'UI_HUD.HUD.UTCrossHairs';
		GGH.DefaultCrossHairImage = true;
		GGH.ActivateTriggerVisible = false;
		GGH.StealableItemVisible = false;
		GGH.LoadingTriggerVisible = false;
		foreach WorldInfo.AllActors(class'ActivateTrigger',AT)
		{
			AT.Seen = false;
			AT.FacingActivateTrigger = false;
		}
		foreach WorldInfo.AllActors(class'TrapTrigger',TT)
		{
			TT.FacingTrapTrigger = false;
		}
		foreach WorldInfo.AllActors(class'StealableItem',ST)
		{
			ST.FacingStealableItem = false;
		}
		//hitloc	= EndTrace;
	}

	// Convert Trace Information to ImpactInfo type.
	CurrentImpact.HitActor		= HitActor;
	CurrentImpact.HitLocation	= HitLocation;
	CurrentImpact.HitNormal		= HitNormal;
	CurrentImpact.RayDir		= Normal(EndTrace-StartTrace);
	CurrentImpact.StartTrace	= StartTrace;
	CurrentImpact.HitInfo		= HitInfo;

	// Add this hit to the ImpactList
	ImpactList[ImpactList.Length] = CurrentImpact;

	// check to see if we've hit a trigger.
	// In this case, we want to add this actor to the list so we can give it damage, and then continue tracing through.

	return CurrentImpact;
}

simulated function Projectile ProjectileFire()
{
	local Projectile proj;
	
	//If amount of mines planted is less than MinesAllowed
	if (MinesList.Length < MinesAllowed)
	{
			proj = super.ProjectileFire();
			BakanPawn(Owner).PlayThrowGrenadeAnim();
			//Add projectile into list of mines
			MinesList.AddItem(Flashbang(proj));
			//Planted mine, so this is false
			NoMinePlanted = false;
			
			//Set shot cost to 0 if number of mines planted exceeded MinesAllowed, so that ammo won't deplete when you can't lay any mine
			if (MinesList.Length >= MinesAllowed)
			{
				ShotCost[0] = 0;
			}
	}
	
	return proj;
}

simulated function CustomFire()
{
	//Allow explosion if there is at least one mine (to prevent a bug where mine[0] is able to keep exploding)
	if (NoMinePlanted == false)
	{
		ExplodeAllMines();
	}
}

simulated function ExplodeAllMines()
{
	local Flashbang proj;
	
	//call every mines in the array to explode
	foreach MinesList(proj)
	{
		proj.CallToExplode();
	}
	
	//Clear all mines in the list
	MinesList.Length = 0;
	//Reset shot cost
	ShotCost[0] = 1;
	//Set NoMinePlanted back to true
	NoMinePlanted = true;
}

function HolderDied()
{
	//If weapon holder died, erase all his mines from the map
	super.HolderDied();
	EraseAllMines();
}

simulated function EraseAllMines()
{
	local Flashbang proj;
	
	foreach MinesList(proj)
	{
		//Destroy all mines
		proj.Destroy();
	}
	
	//Clear all mines in the list
	MinesList.Length = 0;
	//Reset shot cost
	ShotCost[0] = 1;
	//Set NoMinePlanted back to true
	NoMinePlanted = true;
}

defaultproperties
{
	/**Variables for my mine weapon**/
	MinesAllowed = 3;
	NoMinePlanted = true;
	
	FireInterval(0)=+0.5 //Mine planting interval
	FireInterval(1)=+0.1 //Mine explosion interval
	
	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Custom
	
	WeaponProjectiles(0)=class'Guide.Flashbang'
	
	ShotCost(0)=1
	ShotCost(1)=0 //well exploding shouldn't cost you any ammo

	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=0
	InventoryGroup=2
	GroupWeight=0.5
	AimError=600

	AmmoCount=0
	LockerAmmoCount=50
	MaxAmmoCount=10000

	IconX=335
	IconY=81
	IconWidth=43
	IconHeight=39
	
	WeaponColor=(R=255,G=255,B=255,A=255)
	
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_Linkgun_1P'
		PhysicsAsset=None
		FOV=70 
		AnimSets(0)=AnimSet'WP_LinkGun.Anims.K_WP_LinkGun_1P_Base'
	End Object 
	AttachmentClass=class'UTAttachment_Linkgun'

	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
	End Object
	
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate= none
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'UTGame.UTRocketMuzzleFlashLight'
	
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=50,RightAmplitude=60,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.120)
	End Object
}
