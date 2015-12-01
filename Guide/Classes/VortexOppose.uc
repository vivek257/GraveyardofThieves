class VortexOppose extends TrapTrigger;

var BakanPawn Target;
var BakanPlayerController PC;
var ParticleSystem Vortex;
var SoundCue Suck;
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

		if(FacingTrapTrigger && !checked)
		{

			Target.Velocity = Normal(Location-Target.Location)*700;
		 WorldInfo.MyEmitterPool.SpawnEmitter(Vortex,Target.Location+Vector(Target.Rotation)*96);
		 Target.MovingVoluntarily = false;
		 if(!playingsound)
		 {
			PlaySound(Suck);
		 }
		 playingsound = true;
		 SetTimer(0.5,false,'TriggerMovingEnd');
		}
  }

}
DefaultProperties
{
		checked = false
		Vortex = ParticleSystem'GuideTutorial.Vortex'
		playingsound = false
		Suck = SoundCue'GuideSounds.Ahudra'
}
