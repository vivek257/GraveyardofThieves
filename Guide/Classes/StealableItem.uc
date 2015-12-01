class StealableItem extends Trigger;
var() InterpActor Item;
var() Name SetName;
var SoundCue pulse;
var bool FacingStealableItem;
var() int Stealable;
var() string ActivateText;
function bool UsedBy(Pawn User)
{

	local bool used;

	used = super.UsedBy(User);

if (FacingStealableItem && Stealable == 1)
	{
		TriggerRemoteKismetEvent(SetName);
		PlaySound(pulse);
	}

	return used;
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
DefaultProperties
{
 Stealable = 0
	pulse = SoundCue'GuideSounds.MoneyCue'
	ActivateText = "E(Steal)"
}
