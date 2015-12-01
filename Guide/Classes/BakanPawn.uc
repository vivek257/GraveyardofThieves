class BakanPawn extends UTPawn
	config(Game);
var PickMeUp PM,MP,Thrown;
var bool bFacingPickMeUp;
var bool flashOn;
var bool Teleported,MovingVoluntarily,FlashLightOn,Slowed,Stopped,Deaf;
var bool SlowMo,cycleScreen,Invisible;
var Vector hitlocation;
var Rotator hitrotator;
var float throwforce,exposure,Loudness;
var float seerad;
var PostProcessSettings blurSettings;
var MaterialEffect ppe;
var class<GuideSoundGroup> SoundGroupClass;
var name EyeSocket;
var int PlayTime;
//testing only


var PostProcessChain PPC;  
var int curMaterialEffectIndex;
var Actor     HitActor;
var vector    HitNormal;
var vector    HitLoc;
var vector   CamRotTMP;
var PlayerFlashlight Flashlight;
;
var LightCheckVolume LightCheck;
//global temp data
//for speed efficiency
var array<PostProcessEffect> curEffects;

function loadCurEffects(Name effectName, 
optional class<PostProcessEffect> MatchingPostProcessEffectClass = class'PostProcessEffect') 
{
  local PostProcessEffect PostProcessEffect;
  local PlayerController PlayerController;
  local LocalPlayer LocalPlayer;

	//----- clear the old global array data -----
	curEffects.length = 0;
	//-----------------------------------------------
	
  // Affect the world post process chain
  if (WorldInfo != None)
  {
    ForEach WorldInfo.AllControllers(class'PlayerController', PlayerController)
    {
      LocalPlayer = LocalPlayer(PlayerController.Player);

      if (LocalPlayer != None && LocalPlayer.PlayerPostProcess != None)
      {
        PostProcessEffect = LocalPlayer.PlayerPostProcess.FindPostProcessEffect(effectName);

        if (PostProcessEffect != None && 
      (PostProcessEffect.Class == MatchingPostProcessEffectClass ||    
      ClassIsChildOf(PostProcessEffect.Class, MatchingPostProcessEffectClass))
    ) {
          curEffects.AddItem(PostProcessEffect);
        }
      }
    }
  }
}


//display the material effect
function cycleScreenEffects() {

	
	local int v;  

	//get all nodes from the current PPC
	//that are named 'VictoryScreenEffects'
	
	//you must name your PPC nodes
	//via UDK editor

	//you can create new PPC
	//and add a uberpostprocess node
	//and a materialeffect node
	//and name both to have most
	//PostProcess effects available to you
	//via code (the other big one is a Blur node)

	//load the material effect node by name
	loadCurEffects('FlashbangEffect');
	
	if (curEffects.Length <= 0) return;
	for (v = 0; v < curEffects.length; v++) {
		
	  //get the next node that is named 
	  //'VictoryScreenEffects'
	  ppe = MaterialEffect(curEffects[v]);
			
	  if (ppe != None) { 
		if (cycleScreen)
		{
			ppe.Material = Material'MyPackage.GuideFlashBang';
			SetTimer(4.0,false,'EndEffect');
		}
		else if (Invisible)
		{
		 ppe.Material = Material'MyPackage.MotionBlutMat';
		 SetTimer(10.0,false,'EndEffect');
		}
		else if (SlowMo)
		{
	     ppe.Material = Material'MyPackage.SlowMotionMat';
		 SetTimer(10.0,false,'EndEffect');
		}
	  }
		
	  } // end ppe != none
 //for loop 
}

function EndEffect()
{
	ppe.Material = none;
	cycleScreen = false;
	Invisible = false;
	SlowMo = false;
}





function float Hidden()
{
	local PointLight P;

	Local Vector TraceStart,TraceEnd;
	local float radius,Distance,falloff,brightness;
	local PointLightComponent PLC;
	if(LightCheck!= none && LightCheck.PL.LightComponent.bEnabled)	
{
	  P = LightCheck.PL;
		if (P == none)
		{
			P = PointLightToggleable(LightCheck.PL);
		}
	  PLC = PointLightComponent(P.LightComponent);
	  radius = PLC.Radius;
	  falloff = PLC.FalloffExponent;
	  brightness = PLC.Brightness;
	  Distance = VSize(Location - P.Location);
	  TraceStart = P.Location;
	  TraceEnd = Location;
	  
			if (Distance <= radius && FastTrace(TraceStart,TraceEnd))
			{
				exposure = (brightness* (1-Distance/radius) * falloff * 100 ) + GetMovementPenalty();
				exposure = FClamp(exposure,0.0,100.0);

				if(FlashLightOn)
				{
					exposure+=10.0;
					exposure = FClamp(exposure,0.0,100.0);
				}


			}
			
		
	
}
        else 
        {
			exposure = 0;
			//bIsInvisible = true;
        }
 return exposure; 
}
simulated function float GetMovementPenalty()
{
	local float Result;

	Result = VSize(Velocity)/GroundSpeed;
	Return Result + 10.0;
}

simulated function PostBeginPlay()
{
	Flashlight = Spawn(class'PlayerFlashlight', self);
	Flashlight.SetBase(self);
	Flashlight.LightComponent.SetEnabled(false);
	Flashlight.LightComponent.SetLightProperties(0.75);

super.PostBeginPlay();

}
simulated event PlayFootStepSound(int FootDown)
{
	
	`log('Playing FootStep sounds'); 
	SoundGroupClass.static.PlayFootStepSounds(self, GetMaterialBelowFeet());

}
simulated function bool DoJump(bool bUpdating) 
{
	local bool success;
	`log('Playing Jump sounds');
	success = super.DoJump(bUpdating);

	if (success)
	{
		SoundGroupClass.static.PlayJumpingSound(self, GetMaterialBelowFeet());
	}

	return success;
}
simulated function PlayLanded(float impactVel)
{
	`log('Playing Landing sounds');
	SoundGroupClass.static.PlayLandingSound(self, GetMaterialBelowFeet());
	super.PlayLanded(impactVel);
}
simulated function name GetMaterialBelowFeet()
{
	local vector HitLo, HitNorm;
	local TraceHitInfo HitInfo;
	local actor HitAct;
	local float TraceDist;

	TraceDist = 1.5 * GetCollisionHeight();

	HitAct = Trace(HitLo, HitNorm, Location - TraceDist*vect(0,0,1), Location, false,, HitInfo, TRACEFLAG_PhysicsVolumes);

	if ( WaterVolume(HitAct) != None )
	{
		return (Location.Z - HitLo.Z < 0.33*TraceDist) ? 'Water' : 'ShallowWater';
	}

	if (HitInfo.PhysMaterial != None)
	{
		`log(HitInfo.PhysMaterial.Name);
		return HitInfo.PhysMaterial.Name;
	}

	return '';

}

event UpdateEyeHeight(float DeltaTime)
{
    Flashlight.SetRotation(Controller.Rotation);
    Flashlight.SetRelativeLocation(Controller.RelativeLocation + vect(10, 20, -2));
}
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
    local bool bCameraCalc;
    //Flashlight.SetRotation(Controller.Rotation);
	
    // if we are the local player, make sure our head is normal size.
    // This will make it visible again in third person views and give us the correct bone positions later.
    // NOTE: A better way to do this is to make sure the head is a separate mesh/component and stop it being rendered to the owner.
    if (WorldInfo.NetMode != NM_DedicatedServer && IsHumanControlled() && IsLocallyControlled() && (HeadScale != 1.0f))
    {
        SetHeadScale(1.0f);

        // since we've just un-shrunk the head, force the skeleton to update, just in case
        Mesh.ForceSkelUpdate();
    }
    
    // Call the proper CalcCamera function and remember the result
    bCameraCalc = Super.CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);

    // now that we've run the proper calcs, shrink the head again,
    // but only if we're the local player and in a first person view
    if (WorldInfo.NetMode != NM_DedicatedServer && IsHumanControlled() && IsLocallyControlled() && IsFirstPerson() && !bFixedView)
    {
        SetHeadScale(0.0f);

        // force the skeleton to update, just in case
        Mesh.ForceSkelUpdate();
    }

    // send the result back to UTPlayerController::GetPlayerViewPoint()...
    return bCameraCalc;
}

/*
GetPawnViewLocation

Someone wants the position of our eyes - lets give it to them.
Its probably CalcCamera() anyway (see above).
*/
simulated event Vector GetPawnViewLocation()
{
    local vector viewLoc;

    // no eye socket? No way I can tell you a location based on this socket then...
    if (EyeSocket == '')
        return Location + BaseEyeHeight * vect(0,0,1);

    // HACK - force the first person weapon and arm models to hide
    // NOTE: You should remove all first person only weapon/arm meshes instead.
    SetWeaponVisibility(false);
    
    // HACK - force the world model and attachments to be visible
    // NOTE: You should make sure the mesh/attachments are always rendered.
    SetMeshVisibility(true);

    Mesh.GetSocketWorldLocationAndRotation(EyeSocket, viewLoc);

    return viewLoc;
}

/*
Dying

Instead of switching to a third person view, 
match the camera to the location and rotation of the eye socket.
*/
simulated State Dying
{
    // skip UTPawn's fancy damage/third person views
    simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
    {
        return Global.CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
    }

    simulated event rotator GetViewRotation()
    {
        local vector out_Loc;
        local rotator out_Rot;

        // no eye socket? No way I can tell you a rotation based on this socket then...
        if (EyeSocket == '')
            return Global.GetViewRotation(); // non-state version please
        
        Mesh.GetSocketWorldLocationAndRotation(EyeSocket, out_Loc, out_Rot);

        return out_Rot;
    }
}
simulated event Tick(float DeltaTime)
{
	
	local int rad;
    blurSettings.Scene_Desaturation = 0.9;
	rad = 25;
	self.Controller.GetPlayerViewPoint(hitlocation,hitrotator);
	CamRotTMP = vector(hitrotator);
	flashOn = Flashlight.LightComponent.bEnabled;
	//`log(LightCheck);
	PlayTime = WorldInfo.GRI.ElapsedTime;

	//`log(PlayTime);
	//`log(Hidden());	
	foreach VisibleCollidingActors(class'PickMeUp',PM,rad)
	{
      
	  if (bFacingPickMeUp)
	  {
		MP = PM;
	  }
	  
	}
}


//------------------------------------------------------------------------------
// ToggleFlashlight()
//------------------------------------------------------------------------------
exec function ToggleFlashlight()
{
	if(!Flashlight.LightComponent.bEnabled)
	{
		Flashlight.LightComponent.SetEnabled(true);
		FlashLightOn = true;
		
	}
	else
	{
		Flashlight.LightComponent.SetEnabled(false);
		FlashLightOn = false;
		
	}
}
   

function PlayThrowGrenadeAnim()
{

		FullBodyAnimSlot.PlayCustomAnim('Robin_ThrowGrenade', 1.0, 0.2, 0.2, false, true); 
}

state CarryingObject
{ 

	simulated function StartFire(byte FireModeNum) // This basically overwrites the shoot mechanism while in this state
	{
		local PickMeUp ThrownObject; // This is a temporary way of remembering which object we're throwing

		ThrownObject = Thrown;
		Thrown.ToggleGrab(); // This sets CarriedObject to be none, hence why we need ThrownObject
		ThrownObject.ApplyImpulse(Vector(Controller.Rotation), ThrowForce, ThrownObject.Location); // Launches the object in the direction the player is facing
	}

	event BeginState(name PreviousStateName) // This is called when a player first enters the state
	{
		if (Weapon != none && Weapon.Mesh != none) // If the player has a weapon equipped and it has a model
		{
			Weapon.Mesh.SetHidden(true); // Make it invisible
		}
	}

	event EndState(name NextStateName)
	{
		if(Weapon != none && Weapon.Mesh != none)
		{
			Weapon.Mesh.SetHidden(false);
		}
	}
}
simulated function TakeFallingDamage();
function SetSpeed()
{
   GroundSpeed = 50;
   SetTimer(2.0,false,'TriggerSlowDownEnd');
}
function TriggerSlowDownEnd()
{
   GroundSpeed = 200;
}
Simulated Function SetCharacterClassFromInfo(Class<UTFamilyInfo> Info)
{
SoundGroupClass = class'GuideSoundGroup';
return;

}
exec function StopSprinting()
{
if(!Slowed && !SlowMo)
{
GroundSpeed = 200;
}
}
 exec function Run()
{
if(!Slowed && !SlowMo) 
{
GroundSpeed = GroundSpeed * 2.5;
}
  
}
DefaultProperties
{

 seerad = 400
 bPushedByEncroachers=false
	cycleScreen = false
	Invisible = false
	SlowMo = false
 GroundSpeed = 200
 bIsInvisible = false
 throwforce = 400
 PPC = PostProcessChain'MyPackage.FlashbangChain'  
 CrouchedPct=+0.4
 CrouchHeight=19.0
 CrouchRadius=21.0
 bCanCrouch = true;
 BaseTranslationOffset=5.0
 LeftFootControlName=LeftFootControl
 RightFootControlName=RightFootControl 
 bEnableFootPlacement=true
	SpawnSound = none 
 Teleported = false
MovingVoluntarily = true

FlashLightOn = false
	Slowed = false
	Stopped = false 
	Deaf = false
SoundGroupClass = class 'GuideSoundGroup' 
 MaxFootPlacementDistSquared=56250000.0 // 7500 squared



 	 Begin Object Class=DynamicLightEnvironmentComponent Name=MLightEnvironment
        bEnabled=TRUE
		bSynthesizeSHLight=TRUE
		bIsCharacterLightEnvironment=TRUE
		bUseBooleanEnvironmentShadowing=FALSE
		InvisibleUpdateTime=1
		MinTimeBetweenFullUpdates=.2
    End Object
    LightEnvironment=MLightEnvironment
    Components.Add(MLightEnvironment)
EyeSocket = Eyes
Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
		HiddenGame=FALSE
        HiddenEditor=FALSE
		bOwnerNoSee = false
	Scale = 0.7
	LightEnvironment = MLightEnvironment
    AnimTreeTemplate=AnimTree'GuidePackageforJafar.Robin_Tree'
    SkeletalMesh=SkeletalMesh'GuidePackageforJafar.Robin_Walk'
    AnimSets(0)=AnimSet'GuidePackageforJafar.Bip01'
  End Object
  Mesh=SandboxPawnSkeletalMesh
  Components.Add(SandboxPawnSkeletalMesh)

} 