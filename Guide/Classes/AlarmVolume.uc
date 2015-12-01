class AlarmVolume extends TriggerVolume
	placeable;

var() array<DetectorTrigger> Detectors;
var() array<StealableItem> StealItem;
var() bool AlarmOn;
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local int i,j;
	if(Other.IsA('BakanPawn') && AlarmOn)
	{
		`log(AlarmOn);
		i = 0;
		
		while( i < Detectors.Length)
		{
			Detectors[i].AlarmTripped = true;
			i++;
		}
	}
	else if(Other.IsA('BakanPawn') && !AlarmOn )
	{
		
		j = 0;
		while (j < StealItem.Length)
		{
			StealItem[j].Stealable = 1;
			j++;
		}



	}


}
function AlarmOff()
{
	local int i,j;
	if(!AlarmOn)
	{
		i = 0;
		j = 0;
		while( i < Detectors.Length)
		{
			Detectors[i].AlarmTripped = false;
			i++;
		}
		while (j < StealItem.Length)
		{
			StealItem[j].Stealable = 0;
			j++;
		}
	}

}
function Alarm()
{
	local int i,j;
	if(AlarmOn)
	{
		i = 0;
		j = 0;
		while( i < Detectors.Length)
		{
			Detectors[i].AlarmTripped = true;
			i++;
		}
		while (j < StealItem.Length)
		{
			StealItem[j].Stealable = 1;
			j++;
		}
	}

}
DefaultProperties
{
	bStatic = false
	AlarmOn = false
}
