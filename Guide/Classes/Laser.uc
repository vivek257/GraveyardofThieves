class Laser extends InterpActor;
var() Name Event;
var() bool LaserOn;
var() array<Laser> Lasers;

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
	if(Other.IsA('BakanPawn') && !BakanPawn(Other).bIsInvisible && LaserOn)
	{
		TriggerRemoteKismetEvent(Event);
				while (i < Lasers.Length)
				{
					Lasers[i].LaserOn = false;
					i++;
					
				}

	}

}
function ResetLasers()
	{
			local int i;
			i=0;
				while (i < Lasers.Length)
				{
					Lasers[i].LaserOn = true;
					i++;
					
				}		
	}
DefaultProperties
{
	Begin Object Name=StaticMeshComponent0
  	StaticMesh=StaticMesh'MyPackage.LaserTrip_Wire'
	Scale3D=(X=0.25,Y=0.25,Z=0.25)
	
  End Object
  Components.Add(StaticMeshComponent0)
}
