class ActivateTrigger extends Trigger;
var() StaticMeshActor Prop;
var() Material Swap,ReSwap;
var() float MyRadius;
var bool FacingActivateTrigger,bVisible,Seen;
var() string ActivateText;
var SoundCue Bing;
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
function SwapPropMaterial()
{

	if(Prop != none && Swap != none)
	{
  	Prop.StaticMeshComponent.SetMaterial(0,Swap);
	}
 	SetTimer(1.0,false,'ReSwapPropMaterial');
}
function ReSwapPropMaterial()
{

	if(Prop != none && ReSwap != none)
	{  
	Prop.StaticMeshComponent.SetMaterial(0,ReSwap);
	}
}

DefaultProperties
{
	bStatic = false
	bVisible = true
	Bing = SoundCue'GuideSounds.DiscoveryCue'
	Seen = false
	
}
