class Clock extends TriggerVolume;
var() array<AlarmVolume> Alarms;
var bool ClockOn;
var int ClockTime;
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if(Other.IsA('BakanPawn'))
	{
		
		WorldInfo.GRI.ElapsedTime = 0;
		ClockTime = WorldInfo.GRI.ElapsedTime;
		
		CheckClock();
	}
}
function CheckClock()
{
	ClockTime = WorldInfo.GRI.ElapsedTime;
	`log(ClockTime);
	if( ClockTime < 360)
	{
		StartMorningClock();
	}
	if (ClockTime > 360)
	{
		StartNightClock();
	}
	
	WorldInfo.Game.Broadcast(self, "Checking Clock",);
	SetTimer(60.0,true,'CheckClock');
}

function StartMorningClock()
{
 local int i;
 i = 0;
 
 while (i < Alarms.Length)
 {
	Alarms[i].AlarmOn = false;
	Alarms[i].AlarmOff();
	i++;
	
 }

WorldInfo.Game.Broadcast(self, "It's Morning !!",);


}
function StartNightClock()
{
 local int i;
 i = 0;

 //
 while (i < Alarms.Length)
 {
	Alarms[i].AlarmOn = true;
	Alarms[i].Alarm();
	i++;
 }
if(ClockTime > 600)
{
 WorldInfo.GRI.ElapsedTime = 0;
}

WorldInfo.Game.Broadcast(self, "It's Night !!",);

}
DefaultProperties
{
	ClockOn = true
	bStatic = false
}
