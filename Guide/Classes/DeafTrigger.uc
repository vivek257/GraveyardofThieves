class DeafTrigger extends TrapTrigger;


var BakanPawn Target;
var BakanPlayerController PC;
function GoDeaf(Pawn T)
{
	local float setvol;
	setvol = 0.01f;
	PC = BakanPlayerController(T.Controller);
	PC.adjustvolume(setvol);
	SetTimer(10.0,false,'DeafTriggerEnd');
}

function DeafTriggerEnd()
{
    local BakanPawn B;
	local float setvolume;
	setvolume = 1.0f;
    foreach WorldInfo.AllActors(class 'BakanPawn',B)
	{
		PC = BakanPlayerController(B.Controller);
		B.Deaf = false;
		PC.adjustvolume(setvolume);
	}
	checked = false;
}
simulated event Tick(float DeltaTime)
{
	local BakanPawn P;

	Myradius = 400;
  	foreach VisibleCollidingActors(class'BakanPawn',P,Myradius)
  	{ 
		
  	if (FacingTrapTrigger && checked == false && !P.Deaf) 
      {
      	

      			WorldInfo.Game.Broadcast(P, "Used Worked!",);
				P.Deaf = true;
				checked = true;
				GoDeaf(P);
				
				

      	
      } 	
    }
  
}
DefaultProperties
{


}
