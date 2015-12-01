class LoadingTrigger extends Trigger;
var int LoadKismetEvent;
var() string ActivateText;

var() Name SetName1,SetName2,SetName3,SetName4,SetName5,SetName6,SetName7,SetName8,SetName9,SetName10;
function bool UsedBy(Pawn User)
{
	local bool used;
	used = super.UsedBy(User);
	if(User.IsA('BakanPawn'))
	{
		
		GetKismetEvent();

		switch (LoadKismetEvent) 
		{
		 
		case 1 :
				TriggerRemoteKismetEvent(SetName1);
				break;
		case 2 :
				TriggerRemoteKismetEvent(SetName2);
				break;
		case 3 :
				TriggerRemoteKismetEvent(SetName3);
				break;
		case 4 :
				TriggerRemoteKismetEvent(SetName4);
				break;
		case 5 :
				TriggerRemoteKismetEvent(SetName5);
				break;
		case 6 :
				TriggerRemoteKismetEvent(SetName6);
				break;
		case 7 :
				TriggerRemoteKismetEvent(SetName7);
				break;
		case 8 :
				TriggerRemoteKismetEvent(SetName8);
				break;
		case 9 :
				TriggerRemoteKismetEvent(SetName9);
				break;
		case 10 :
				TriggerRemoteKismetEvent(SetName10);
				break;
		}
	}

	return used;
}
 function int GetKismetEvent()
{
	local SaveObject SO;

	SO = new class'SaveObject';
	if(class'Engine'.static.BasicLoadObject(SO, "..\\Saves\\SaveGame.bin", true, 0))
	{
		LoadKismetEvent = SO.CheckPointNumber;
		`log('Checkpoint Number Is');
		`log(SO.CheckPointNumber);
		`log(LoadKismetEvent);
	}

	return LoadKismetEvent;
}
function TriggerRemoteKismetEvent( name EventName )
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int i;
	
	GameSeq = WorldInfo.GetGameSequence();
	if (GameSeq != None)
	{
		// reset the game sequence
		GameSeq.Reset();

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

DefaultProperties
{
	ActivateText = "E(Start Game)"
}
