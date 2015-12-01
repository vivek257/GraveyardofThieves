class PairTrigger extends Trigger;
var() PairTrigger MyPair;
var() Name SetName;
var bool checked;
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
	checked = true;	
	SetTimer(5);
	CheckPair();
	used = super.UsedBy(User);

return  used;
}

function CheckPair()
{


	  if (IsTimerActive())
	  {
		if (MyPair.checked == true)
		{
			TriggerRemoteKismetEvent(SetName);
		}
	  }


}

function Timer()
{
	checked = false;
}

DefaultProperties
{
	checked = false
}
