class InvisibleTrigger extends ActivateTrigger;


var BakanPawn Target;



var SoundCue invisiblecue;

function TriggerInvisible(BakanPawn T)
{
  //T.Mesh.SetHidden(true);
  T.bIsInvisible=true;
  SetTimer(10.0,false,'TriggerInvisibleEnd');
  T.Invisible = true;
  T.cycleScreenEffects();
  PlaySound(invisiblecue);

}

function TriggerInvisibleEnd()
{
    local BakanPawn B;
	foreach WorldInfo.AllActors(class 'BakanPawn',B)
	{
		//B.Mesh.SetHidden(false);
		B.bIsInvisible =false;
	}
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
      			TriggerInvisible(P); 



      					      	
			} 	
		}
return used;	
}
DefaultProperties
{

	ActivateText = "E(Turn Invisible)"
	invisiblecue = SoundCue'MyPackage.invisiblecue'
}
