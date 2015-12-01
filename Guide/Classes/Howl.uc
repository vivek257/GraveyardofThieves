class Howl extends UTPawn
placeable;
var bool bKnockedOut;
var() array<PathNode> PatrolRoute;
var Controller HEC;
var() PathNode PlayerDestination;
var name AlertSocket;
var StaticMeshComponent AlertComponent;
var Vector AlertLocation;
simulated event PostBeginPlay()
{
    super.PostBeginPlay();	
	AddDefaultInventory();
	Mesh.GetSocketWorldLocationAndRotation(AlertSocket,AlertLocation,);

}
function AddDefaultInventory()
{
local Weapon TeleportG;
TeleportG = Spawn(class'Guide.TeleportGun');
TeleportG.GiveTo(self);
}
simulated function StartFire(byte FireModeNum)
{
	if( bNoWeaponFIring )
	{
		return;
	}

	if( Weapon != None )
	{
		Weapon.StartFire(FireModeNum);
	}
	else
	{
		`log("NO WEAPON");
	}
}
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
		AnimTreeTemplate=AnimTree'GuidePackageforJafar.Howl_Tree'
        SkeletalMesh=SkeletalMesh'GuidePackageforJafar.Howl_Walk'
        AnimSets(0)=AnimSet'GuidePackageforJafar.Howl_01'
        LightEnvironment = MLightEnvironment
		HiddenGame=false
        HiddenEditor=FALSE
    End Object

    Mesh=SandboxPawnSkeletalMesh
    Components.Add(SandboxPawnSkeletalMesh)
   Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
  	StaticMesh=	StaticMesh'MyPackage.Alert'

  End Object
  AlertComponent = StaticMeshComponent0


	ControllerClass=class'Guide.HowlController'
	AlertSocket = Alert
    bJumpCapable=false
    bCanJump=false


}
