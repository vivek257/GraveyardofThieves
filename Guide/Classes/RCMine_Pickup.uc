class RCMine_Pickup extends UTAmmoPickupFactory;
var string DisplayText;
var GuideGameHUD GGH;
function SpawnCopyFor( Pawn Recipient )
{
	if ( UTInventoryManager(Recipient.InvManager) != none )
	{
		UTInventoryManager(Recipient.InvManager).AddAmmoToWeapon(AmmoAmount, TargetWeapon);
		GGH = GuideGameHUD(GetALocalPlayerController().myHUD);
		GGH.PickupText = true;
		GGH.DisplayString = DisplayText;
		SetTimer(1.0,false,'DisplayPickupText');
	}

	Recipient.PlaySound(PickupSound);
	Recipient.MakeNoise(0.2);

	if (PlayerController(Recipient.Controller) != None)
	{
		//PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass,,,,Class);
	}
}
simulated function DisplayPickupText()
{
	GGH.PickupText = false;
}
DefaultProperties
{
    Begin Object Name=AmmoMeshComp
        StaticMesh= StaticMesh'mypackage.stickybomb'
        Translation=(X=0.0,Y=0.0,Z=-16.0)
        Scale=10.0
        HiddenEditor=false
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=14.4
    End Object

	DisplayText = "Picked up Flashbang"
	AmmoAmount = 1
	//PickupSound = none
	TargetWeapon = Class'RCMineWeapon'

}
