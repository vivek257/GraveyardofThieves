class EyeClops extends UTPawn
	placeable;
var() array<PathNode> SearchRoute;
var() array<PathNode> PlayerDestination;
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
		SkeletalMesh=SkeletalMesh'GuidePackageforJafar.EyeClops'
		AnimSets(0)=AnimSet'GuidePackageforJafar.Eyeclops_01'
		AnimTreeTemplate=AnimTree'GuidePackageforJafar.Eyeclops_Tree'
		        LightEnvironment = MLightEnvironment 
         HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
     Mesh=SandboxPawnSkeletalMesh 
    Components.Add(SandboxPawnSkeletalMesh)

   Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
  	StaticMesh=	StaticMesh'MyPackage.Alert'

  End Object
  AlertComponent = StaticMeshComponent0
    ControllerClass=class'Guide.EyeClopsController'
    bJumpCapable=false
    bCanJump=false
	AlertSocket = Alert
    GroundSpeed=200.0 //Making the bot slower than the player
}
