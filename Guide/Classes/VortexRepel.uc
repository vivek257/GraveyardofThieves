class VortexRepel extends TrapTrigger;


var BakanPawn Target;
var BakanPlayerController PC;
var ParticleSystem Repel;
var SoundCue Wind;
var bool playingsound;
function TriggerMovingEnd()
{
     local BakanPawn B;
	foreach WorldInfo.AllActors(class 'BakanPawn',B)
	{
		//B.Mesh.SetHidden(false);
		playingsound = false;
		B.MovingVoluntarily =true;
	}
}
simulated event Tick(float DeltaTime)
{

  foreach CollidingActors(class'BakanPawn',Target,800) 
  {

		if(FacingTrapTrigger)
		{
		 Target.Velocity = Normal(Target.Location-Location)*1000;
		 WorldInfo.MyEmitterPool.SpawnEmitter(Repel,Prop.Location);
		 Target.MovingVoluntarily = false;
		 if(!playingsound)
		 {
			PlaySound(Wind);
		 }
		 playingsound = true;
		 SetTimer(0.9,false,'TriggerMovingEnd');

		}
  }

}
DefaultProperties
{
	checked = false
	Repel = ParticleSystem'GuideTutorial.Wind'
	Wind = SoundCue'GuideSounds.Rudra'
	playingsound = false;
}
