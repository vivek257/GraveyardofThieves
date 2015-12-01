class EventTrigger extends ActivateTrigger;

function bool UsedBy(Pawn User)
{
	local bool used;
	used = super.UsedBy(User);
	
	if(FacingActivateTrigger)
	{
	TriggerRemoteKismetEvent(SetName);
	}
	return used;
}
DefaultProperties
{
}
