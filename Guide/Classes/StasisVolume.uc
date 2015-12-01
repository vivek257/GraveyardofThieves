class StasisVolume extends DetectorTrigger;
var bool checked,timeractive;
var ParticleSystem Trap;
var SoundCue Stop;
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{

	if(Other.IsA('BakanPawn') && !timeractive)
	{
		
		checked = true;
		timeractive = true;
		
		 PlaySound(Stop);
		SetTimer(0.5,false,'TriggerStasis');

		
	}
}
simulated function TriggerStasis()
{
    local BakanPawn B;
	foreach WorldInfo.AllActors(class 'BakanPawn',B)
	{
		if(checked)
		{
			WorldInfo.MyEmitterPool.SpawnEmitter(Trap,B.Location);
			BakanPlayerController(B.Controller).IgnoreMoveInput(true);

		}
	}
}
event UnTouch(Actor Other)
{

	if(Other.IsA('BakanPawn'))
	{
		checked = false;
		BakanPlayerController(BakanPawn(Other).Controller).IgnoreMoveInput(false);
		timeractive = false;
	}
}
DefaultProperties
{
	bStatic = false
	Trap = ParticleSystem'GuideTech.TrapField'
	Stop = SoundCue'GuideSounds.Promise'
checked = false
timeractive = false
}
