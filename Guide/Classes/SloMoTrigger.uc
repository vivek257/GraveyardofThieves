class SloMoTrigger extends ActivateTrigger;

var float PrevSpeed;

//var() StaticMeshComponent TeleportMesh;

var SoundCue pulse;

function TriggerSloMo(BakanPawn P)
{

  checked = true;
  PrevSpeed = P.GroundSpeed;
  P.GroundSpeed = 1500;
  P.CustomTimeDilation = 1.5;
  WorldInfo.TimeDilation=0.3;

  PlaySound(pulse);
  
  
	P.SlowMo = true;
	P.cycleScreenEffects();
  SetTimer(10.0,false,'TriggerSloMoEnd');
}

function TriggerSloMoEnd()
{   
    local BakanPawn P;
	foreach WorldInfo.AllActors(class 'BakanPawn',P)
	{
		if(P.Slowed)
		{
			PrevSpeed = 25;
		}
		else
		{
			PrevSpeed = 200;
		}
		
		P.GroundSpeed = PrevSpeed;
		WorldInfo.TimeDilation = 1.0;
		P.CustomTimeDilation = 1.0;
		checked = false;
	}
}
function bool UsedBy(Pawn User)
{
	local BakanPawn P;

	local bool used;

	Myradius = 200;
	used = super.UsedBy(User);

  	foreach VisibleCollidingActors(class'BakanPawn',P,Myradius)
  	{ 
		//WorldInfo.Game.Broadcast(P, "inside radius",);
  	if (FacingActivateTrigger && checked == false)
      {
		TriggerSloMo(P);
      } 	
    }
 return used;	 
}
DefaultProperties
{
	bStatic = false
	pulse = SoundCue'MyPackage.PulseCue'
	ActivateText = "E(Slow Down Time)"
	checked = false
}
