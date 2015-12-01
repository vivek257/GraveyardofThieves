class Flashbang_Pickup extends UTAmmoPickupFactory;
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
		SetTimer(3.0,false,'DisplayPickupText');
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
        StaticMesh= StaticMesh'mypackage.Sticky2'
        Scale=10.0
        HiddenEditor=false
    End Object

    Begin Object Name=CollisionCylinder
        CollisionHeight=14.4
    End Object

	DisplayText = "Picked up Noise Grenade"
	AmmoAmount = 1
	//PickupSound = none
	TargetWeapon = Class'FlashGun'

}
