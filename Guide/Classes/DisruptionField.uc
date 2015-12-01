class DisruptionField extends DetectorTrigger;
var bool checked,timeractive;
var float prevspeed;
var ParticleSystem Slowdown;
var SoundCue Slowed;
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{

	if(Other.IsA('BakanPawn'))
	{
		BakanPawn(Other).Slowed = true;
		prevspeed = BakanPawn(Other).GroundSpeed;
		if(!timeractive && !BakanPawn(Other).SlowMo)
		{
			checked = true;
			timeractive = true;
			BakanPawn(Other).GroundSpeed = 25;
			WorldInfo.MyEmitterPool.SpawnEmitter(Slowdown,BakanPawn(Other).Location);
			PlaySound(Slowed);
		}
		
	}
}

event UnTouch(Actor Other)
{
	if(Other.IsA('BakanPawn'))
	{
		checked = false;
        
		timeractive = false;
		`log(prevspeed);
		BakanPawn(Other).GroundSpeed = prevspeed;
		BakanPawn(Other).Slowed = false;
	}
}
DefaultProperties
{
	Slowdown = ParticleSystem'GuideTech.Slowdown'
	Slowed = SoundCue'GuideSounds.YamaCue'
	bStatic = false
	checked = false
	timeractive = false
}
