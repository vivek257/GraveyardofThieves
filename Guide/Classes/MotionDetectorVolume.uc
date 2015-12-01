class MotionDetectorVolume extends DetectorTrigger
	placeable;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
  if(Other.IsA('BakanPawn'))
  {
	AlarmTripped = true;
	CheckLoudness();

  }
}
simulated function CheckLoudness()
{
	local BakanPawn B;
	if (AlarmTripped)
	{
		foreach WorldInfo.AllActors(class 'BakanPawn',B)
		{
			  	if( B.Loudness > 0.3)
			{

				if(!B.SlowMo)
				{
				 TriggerRemoteKismetEvent(SetName);
				}
			   else if (B.SlowMo)
				{
				 SetTimer(5.0,false,'DelayTrap');
				}
			}   
		}
	}
}
simulated function DelayTrap()
{
  TriggerRemoteKismetEvent(SetName);
}
event UnTouch(Actor Other)
{
	if(Other.IsA('BakanPawn'))
	{
		AlarmTripped = false;
	}
}
DefaultProperties
{
}
