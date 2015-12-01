class VisibilityDetectorVolume extends DetectorTrigger
	placeable;


event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if(Other.IsA('BakanPawn') )
	{
		AlarmTripped = true;
		CheckVisibility();
		
	}
}
event UnTouch(Actor Other)
{
	if(Other.IsA('BakanPawn'))
	{
		AlarmTripped = false;
	}
}
simulated function CheckVisibility()
{
	local BakanPawn B;
	if (AlarmTripped)
	{
		foreach WorldInfo.AllActors(class 'BakanPawn',B)
		{
		 if(B.Hidden() > 30 && !B.bIsInvisible)
		 {
			TriggerRemoteKismetEvent(SetName);
		 }
		}
	}
}
DefaultProperties
{
}
