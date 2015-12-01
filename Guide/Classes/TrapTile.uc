class TrapTile extends InterpActor;

var() Name Event;
var() bool Activated;
var() array<TrapTile> Tiles;

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
event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local int i;
	i=0;
	if(Other.IsA('BakanPawn') && Activated )
	{
		TriggerRemoteKismetEvent(Event);
				while (i < Tiles.Length)
				{
					Tiles[i].Activated = false;
					i++;
					
				}

	}

}
function ResetLasers()
	{
			local int i;
			i=0;
				while (i < Tiles.Length)
				{
					Tiles[i].Activated = true;
					i++;
					
				}		
	}
DefaultProperties
{
	Begin Object Name=StaticMeshComponent0
  	StaticMesh=StaticMesh'MyPackage.TrapTile'
	
  End Object
  Components.Add(StaticMeshComponent0)
}
