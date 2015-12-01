class TeleportTrigger extends ActivateTrigger;


var BakanPawn Target;
var() PathNode PatDestination;


function TriggerActivate(BakanPawn T)
{
  //T.Mesh.SetHidden(true);
  T.SetLocation(PatDestination.Location);
  PlaySound(SoundCue'GuideSounds.YaliLaughCue');
  SetTimer(5.0,false,'checkflag');
}
function checkflag()
{
	checked = false;
}
function bool UsedBy(Pawn User)
{
	local BakanPawn P;
	local bool used;
	Myradius = 400;
	used = super.UsedBy(User);
  	foreach VisibleCollidingActors(class'BakanPawn',P,Myradius)
  	{ 
		//WorldInfo.Game.Broadcast(P, "inside radius",);
  	if (FacingActivateTrigger && checked == false) 
      {      	
		checked = true;
      	TriggerActivate(P);		      	
      } 	
    }
return used;  
}
DefaultProperties
{
	checked = false
	ActivateText = "E(Teleport)"

}
