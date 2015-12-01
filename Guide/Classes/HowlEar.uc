class HowlEar extends UTPawn
placeable;
var() array<PathNode> PatrolRoute;
var() Howl HO;
var float PauseBetweenPoints;
var Controller HEC;
var() AlertRing ALR;
var name AlertSocket;
var Vector AlertLocation;

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
	HEC = self.Controller;
	Mesh.GetSocketWorldLocationAndRotation(AlertSocket,AlertLocation);
	if(ALR!= none)
	{
		ALR.SetLocation(AlertLocation);
		ALR.SetBase(self);
	}

}
//override to do nothing
simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info);


DefaultProperties
{
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
        SkeletalMesh=SkeletalMesh'GuidePackageforJafar.Howl_Eye'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        LightEnvironment = MLightEnvironment 
		HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
	GroundSpeed = 400
	HearingThreshold = 512
	bLOSHearing = false
    Mesh=SandboxPawnSkeletalMesh
    Components.Add(SandboxPawnSkeletalMesh)
	ControllerClass=class'Guide.HowlEarController'
    bJumpCapable=false
    bCanJump=false
	AlertSocket = Alert
}
