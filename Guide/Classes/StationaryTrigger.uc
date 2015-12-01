class StationaryTrigger extends TrapTrigger 
	placeable;

var BakanPawn Target;
var ParticleSystem Trap;
var SoundCue Stop;
function TriggerStat(BakanPawn T)
{
  //T.Mesh.SetHidden(true);
  T.bStationary=true;
  BakanPlayerController(T.Controller).IgnoreMoveInput(true);
  T.JumpZ = 0.0;
  PlaySound(Stop);
 // T.GroundSpeed = 0;
  SetTimer(10.0,false,'TriggerStatEnd');
  WorldInfo.MyEmitterPool.SpawnEmitter(Trap,T.Location);
  //WorldInfo.Game.Broadcast(T, "Stationary Worked!",);
   
}

function TriggerStatEnd()
{
    local BakanPawn B;
	foreach WorldInfo.AllActors(class 'BakanPawn',B)
	{
		//B.Mesh.SetHidden(false);
		B.bStationary =false;
		B.JumpZ = 322;
		B.Stopped = false;
		BakanPlayerController(B.Controller).IgnoreMoveInput(false);
		//B.GroundSpeed = 200;
	}
	checked = false;
}
simulated event Tick(float DeltaTime)
{
	local BakanPawn P;

	Myradius = 400;
   
  	foreach VisibleCollidingActors(class'BakanPawn',P,Myradius)
  	{ 

  	if (FacingTrapTrigger && checked == false && !P.Stopped) 
      {      	
		checked = true;
		P.Stopped = true;
      	TriggerStat(P);		      	
      } 	
    }
  
}
DefaultProperties
{
	checked = false
	Trap = ParticleSystem'GuideTech.TrapField'
	Stop = SoundCue'GuideSounds.Promise'
}

