class NoteTrigger extends ActivateTrigger;

	var int i;
	var() bool ObjectAudio;
function LockMovement(BakanPawn B)
{
  BakanPlayerController(B.Controller).IgnoreMoveInput(true);

checked = true;

}
function UnlockMovement(BakanPawn B)
{
  BakanPlayerController(B.Controller).IgnoreMoveInput(false);

  checked = false;
}
function bool UsedBy(Pawn User)
{
 	local BakanPawn P;
	local bool used;
	used = super.UsedBy(User);
	if(!ObjectAudio)
    {


	i = 0;
	i ++;
	Myradius = 100;

	`log(i);
	if (checked)
	{
		i++;
	}
  	foreach VisibleCollidingActors(class'BakanPawn',P,Myradius)
  	{ 

	  if (i%2 != 0 && FacingActivateTrigger)
	     {
			TriggerRemoteKismetEvent(SetName);
			
			LockMovement(P);


		 }
	   else if (i%2 == 0)
	   {
		TriggerRemoteKismetEvent(SetName);
	   	UnlockMovement(P);
		

	   }

    }
    }
 return used;	 
}

DefaultProperties
{
	checked = false
	bVisible = true
	ActivateText = "E(Read)"
	ObjectAudio = false
}
