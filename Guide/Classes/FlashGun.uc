class FlashGun extends UTWeapon;
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
				GGH.ActivateTriggerVisible = false;
			 }
		}
      }
	else if(HitActor.IsA('TrapTrigger'))
	{
		TrapTrigger(HitActor).FacingTrapTrigger = true;
		TrapTrigger(HitActor).TriggerRemoteKismetEvent(TrapTrigger(HitActor).SetName);
		

	}
	else if(HitActor.IsA('PickMeUp'))
	{
		
		BakanPawn(Owner).bFacingPickMeUp = true;

	}
	else if(HitActor.IsA('StealableItem'))
	{
		StealableItem(HitActor).FacingStealableItem = true;
		GGH.StealableItemVisible = true;
		GGH.DisplayString = StealableItem(HitActor).ActivateText;

	}
	else if(HitActor.IsA('LoadingTrigger'))
	{
		GGH.LoadingTriggerVisible = true;
		GGH.DisplayString = LoadingTrigger(HitActor).ActivateText;
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
			AT.FacingActivateTrigger = false;
			AT.Seen = false;
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

DefaultProperties
{
		/**Variables for my mine weapon**/
	
	FireInterval(0)=+0.5 //Mine planting interval
	FireInterval(1)=+0.1 //Mine explosion interval
	
	WeaponFireTypes(0)=EWFT_Projectile  
	WeaponFireTypes(1)=EWFT_Custom
	
	WeaponProjectiles(0)=class'Guide.RCMineProjectile'
	
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
	

	
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate= none
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'UTGame.UTRocketMuzzleFlashLight'
	
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=50,RightAmplitude=60,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.120)
	End Object
}
