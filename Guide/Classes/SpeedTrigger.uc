class SpeedTrigger extends TrapTrigger;


var BakanPawn Target;
var BakanPlayerController PC;
var CameraAnim p_anim;
var ParticleSystem Slowdown;
var SoundCue Slowed;
function TriggerSlowDown(BakanPawn T)
{
  local float gamespeed;

  //local float scale, rate, blendInTime, blendOutTime;
  //local bool loop, bIsDamageShake;
	//scale = 1.0f;
	//rate = 1.0f;
	//blendInTime = 0.1f;
	//blendOutTime = 0.1f;
	//loop = false;
	//bIsdamageShake = false;
	//p_anim = CameraAnim'FX_HitEffects.DamageViewShake';
	//PC = BakanPlayerController(T.Controller);
   // PC.PlayCameraAnim(p_anim, scale, rate, blendInTime, blendOutTime, loop, bisdamageShake);
  gamespeed = 25;
  T.GroundSpeed = gamespeed; 
  WorldInfo.MyEmitterPool.SpawnEmitter(Slowdown,T.Location);
  PlaySound(Slowed);
  SetTimer(10.0,false,'TriggerSlowDownEnd'); 
}

function TriggerSlowDownEnd()
{
    local BakanPawn B;
	foreach WorldInfo.AllActors(class 'BakanPawn',B)
	{
		B.GroundSpeed = 200;
		B.Slowed = false;
	}
	checked = false;
}
simulated event Tick(float DeltaTime)
{
	local BakanPawn P;
	Myradius = 400;
  	foreach VisibleCollidingActors(class'BakanPawn',P,Myradius)
  	{ 
		
  	if (FacingTrapTrigger && checked == false && !P.Slowed) 
      {
      			WorldInfo.Game.Broadcast(P, "Used Worked!",);
				checked = true;
				P.Slowed = true;
      			TriggerSlowDown(P);      	
      } 	
    }
  
}
DefaultProperties
{
Slowdown = ParticleSystem'GuideTech.Slowdown'
Slowed = SoundCue'GuideSounds.YamaCue'
}
