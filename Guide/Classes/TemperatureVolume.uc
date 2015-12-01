class TemperatureVolume extends TriggerVolume;
var() float Temperature,prev_Temperature;
var() StaticMeshActor displayboard;
var() PathNode PlayerDisplacement;
var bool Alarm;
var bool NoCoolant;
var bool ReleaseGas;
var() Name SetName_1;
var() Name SetName_2;
var() Name SetName_3;
var() Name SetName_4;
var() Name SetName_5;
var() Name SetName_6;
function TriggerRemoteKismetEvent( name EventName )
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int i;

	GameSeq = WorldInfo.GetGameSequence();
	if (GameSeq != None)
	{
		// reset the game sequence
		//GameSeq.Reset(); 

		// find any Level Reset events that exist
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_RemoteEvent', true, AllSeqEvents);

		// activate them
		for (i = 0; i < AllSeqEvents.Length; i++)
		{
			if(SeqEvent_RemoteEvent(AllSeqEvents[i]).EventName == EventName)
				SeqEvent_RemoteEvent(AllSeqEvents[i]).CheckActivate(WorldInfo, None);
		}
	}
}
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if (Other.IsA('BakanPawn'))
	{
		prev_Temperature = Temperature;
		Temperature += 10.0;
		Alarm = true;
		CheckThermometer();
	}

}

function CheckThermometer()
{
	if (prev_Temperature == Temperature) 
		return;
	if(NoCoolant && !Alarm)
	{
	    prev_Temperature = Temperature;
		Temperature += 10.0;
	}
	if(prev_Temperature==10 && Temperature == 20)
		{
			TriggerRemoteKismetEvent(SetName_1);
		} 
	if(prev_Temperature==15 && Temperature == 20)
		{
			TriggerRemoteKismetEvent(SetName_1);
		}
	 if(prev_Temperature==20 && Temperature == 15)
		{
			TriggerRemoteKismetEvent(SetName_2);
		}
	 if(prev_Temperature==15 && Temperature == 25)
		{
			TriggerRemoteKismetEvent(SetName_3);
		}

	 if(prev_Temperature==20 && Temperature == 30)
		{
			TriggerRemoteKismetEvent(SetName_4);
		}
	 if(prev_Temperature==25 && Temperature == 30)
		{
			TriggerRemoteKismetEvent(SetName_5);
		}
	 if(prev_Temperature==25 && Temperature == 10)
		{
			TriggerRemoteKismetEvent(SetName_6);
		}


	if (Temperature >= 25 && ReleaseGas)
	{
		`log("TELEPORTING Player NOW !!");
		SetTimer(45.0,false,'GasEffect');
		
	}
}
simulated function GasEffect()
{
	local BakanPawn BP;
	if(Alarm)
	{
		foreach WorldInfo.Game.AllActors(class'BakanPawn',BP)
		{
			WorldInfo.Game.Broadcast(BP, "Gas releasing",);
			BP.SetLocation(PlayerDisplacement.Location);
		}
	}
}
event UnTouch(Actor Other)
{
	if (Other.IsA('BakanPawn'))
	{
		Alarm = false;
	   	prev_Temperature = Temperature;
		Temperature -= 10.0;
		CheckThermometer();
	}
}
DefaultProperties
{
	Temperature = 15.0
	NoCoolant = false;
	Alarm = false
	ReleaseGas = true
	bStatic = false
}
