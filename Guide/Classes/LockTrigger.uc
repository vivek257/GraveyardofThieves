class LockTrigger extends Trigger;

var bool locked;

var BakanPawn B;
var() Name SetName;
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
function bool UsedBy(Pawn User)
{
	local bool used;
	used = super.UsedBy(User);
	if(locked == false )
	{
		TriggerRemoteKismetEvent(SetName);
	}
 return used;	
}
DefaultProperties
{
	locked = true
}
