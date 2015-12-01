class AlertRing extends InterpActor;
var bool InRing;
function YellowRing()
{
	if(InRing)
	{
	StaticMeshComponent.SetMaterial(0,Material'GuideMuseum.Fire_Mat');
	}
}
function RedRing()
{
	if(InRing)
	{
	 StaticMeshComponent.SetMaterial(0,Material'MyPackage.Laser_Mat');
	}
}
event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	if(Other.IsA('BakanPawn'))
	{		
		InRing = true;
		YellowRing();
	}

}
event UnTouch(Actor Other)
{
		
	if(Other.IsA('BakanPawn'))
	{
		InRing = false;
		StaticMeshComponent.SetMaterial(0,Material'GuideMuseum.GreenGlow');
		
	}

}
DefaultProperties
{

		Begin Object Name=StaticMeshComponent0
  	StaticMesh=StaticMesh'GuidePackageForJafar.WarningRing'

  End Object
	bHidden = true
	Components.Add(StaticMeshComponent0)

}
