class DumbTrigger extends ActivateTrigger;


var BakanPawn Target;
var BakanPlayerController PC;
var() SoundCue SC;
var() PathNode Destination;

function GoDumb()
{
	local HowlEar HE;
	
	PlaySound(SC);
	
	foreach CollidingActors(class'HowlEar',HE,2000)
	{
        WorldInfo.Game.Broadcast(HE, "Dumb Worked!",);
		HE.GroundSpeed = 0;
		HE.SetLocation(Destination.Location);
		HowlEarController(HE.Controller).GotoState('Distracted');
		SetTimer(10.0,false,'DumbEnd');
	}
}
function DumbEnd()
{
	checked = false;
}
function bool UsedBy(Pawn User)
{
		local BakanPawn P;	
		local bool used;
		MyRadius = 400;

	    used = super.UsedBy(User);
  		foreach VisibleCollidingActors(class'BakanPawn',P,MyRadius)
  		{ 
			//WorldInfo.Game.Broadcast(P, "inside radius",);
  			if (FacingActivateTrigger && checked == false) 
			{      	
				checked = true;
      			GoDumb();      					      	
			} 	
		}
return used;	
}
DefaultProperties
{

	ActivateText = "E(Distract Howl)"
	checked = false
}
