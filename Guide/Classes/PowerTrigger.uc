class PowerTrigger extends ActivateTrigger;
var() TemperatureVolume TV;
function bool UsedBy(Pawn User)
{
	local bool used;
	local StealableItem SI;
	used = super.UsedBy(User);
	if(TV != none)
	{
		TV.NoCoolant = true;
		TV.CheckThermometer();

	 foreach WorldInfo.Game.AllActors(class'StealableItem',SI)
					 {
						SI.Stealable = 1;
					 }
	}
	return used;
}
DefaultProperties
{
}
