class LightTrigger extends ActivateTrigger;
var() PointLightToggleable ToggleMe;
var SoundCue TurnOff;
var() float Offtime;






function ToggleOff()
{
  checked = true;
  ToggleMe.LightComponent.SetEnabled(false);
  PlaySound(TurnOff);
  Offtime = 5.0;
  SetTimer(Offtime,false,'ToggleOn');
}
function ToggleOn()
{
  ToggleMe.LightComponent.SetEnabled(true);
	checked = false;
}
function bool UsedBy(Pawn User)
{
	local BakanPawn P;
	local bool used;

	MyRadius = 512;
	used = super.UsedBy(User);

  	foreach VisibleCollidingActors(class'BakanPawn',P,MyRadius)
  	{ 
		//WorldInfo.Game.Broadcast(P, "inside radius",); 
  	if (FacingActivateTrigger  && checked == false)
      {

      		 
			 ToggleOff();

      } 	
    }
 return used;	 
}
DefaultProperties
{
	checked = false
	ActivateText = "E(Switch Off)"
	bVisible = true
	TurnOff = SoundCue'GuideSounds.AnamikaCue'
}
