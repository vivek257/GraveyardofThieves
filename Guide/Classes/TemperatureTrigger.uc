class TemperatureTrigger extends Trigger;
var() TemperatureVolume TV;
var() StaticMeshActor Valve;
function bool UsedBy(Pawn User)
{
	local bool used;
	used = super.UsedBy(User);
	if(TV != none)
	{
		TV.ReleaseGas = false;
		TV.Temperature -= 15;
		TV.CheckThermometer();
	}
	return used;
}
DefaultProperties
{
}
