class CereberusEye extends UTPawn
placeable;
var() array<PathNode> PatDestination;
var() array<CereberusEye> CerBros;
var Vector hitlocation,Lightlocation;
var Rotator hitrotator;
var() array<EyeClops> EC;
var Controller CC;
var bool bknockedout;
var name AlertSocket,RingSocket;
var Vector AlertLocation,RingLocation;
var StaticMeshComponent AlertComponent,QuestionComponent;
var() AlertRing ALR;

function UnhideAlertRing()
{
	ALR.SetHidden(false);
	SetTimer(5.0,false,'HideAlertRing');
}
function HideAlertRing() 
{
	ALR.SetHidden(true); 
}
simulated event PostBeginPlay()
{
    super.PostBeginPlay();	
	AddDefaultInventory();
	CC = self.Controller;
	Mesh.GetSocketWorldLocationAndRotation(AlertSocket,AlertLocation,);
	Mesh.GetSocketWorldLocationAndRotation(RingSocket,RingLocation,);
	if(ALR!= none)
	{
		ALR.SetLocation(RingLocation);
		ALR.SetBase(self);
	}
	
}



	

function Stunned()
{
	GroundSpeed = 0;
	SetTimer(3.0,false,'EndStunned');
}
function EndStunned()
{
	GroundSpeed = 100;
}
function bool FacingBakanPawn(BakanPawn C)
{

	local BakanPawn CT;
	local bool bFacingBakanPawn;

	CT = C;
	foreach WorldInfo.AllActors(class'BakanPawn',CT)
	{
      bFacingBakanPawn = InCylinder(hitlocation,hitrotator,CT.CylinderComponent.CollisionRadius,CT.Location,false);

	}
    return bFacingBakanPawn;

}



simulated event Tick(float DeltaTime)
{
	self.GetActorEyesViewPoint(hitlocation,hitrotator);
	
}

//override to do nothing
simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info);
DefaultProperties
{
    GroundSpeed = 75
	Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object
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
    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'MyPackage.Eyeclops_Eye'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        LightEnvironment = MLightEnvironment 
		HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object

    Mesh=SandboxPawnSkeletalMesh
    Components.Add(SandboxPawnSkeletalMesh)
  Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
  	StaticMesh=StaticMesh'MyPackage.alert'
	Scale3D=(X=0.5,Y=0.5,Z=0.5)
  End Object
  AlertComponent = StaticMeshComponent0
  Begin Object Class=StaticMeshComponent Name=StaticMeshComponent1
  	StaticMesh=StaticMesh'GuideBank.Question'
	Scale3D=(X=0.5,Y=0.5,Z=0.5)
  End Object
  QuestionComponent = StaticMeshComponent1
	SoundGroupClass = class 'CereberusEyeSoundGroup'

    ControllerClass=class'Guide.CerberusEyeController'
    bJumpCapable=false
    bCanJump=false
	AlertSocket = Alert
	RingSocket = Ring
	
}

