class GravityTrigger extends ActivateTrigger;

var() GravityReversalVolume GRV;


var BakanPawn B;

function TriggerZeroG()
{
	B = BakanPawn(GetALocalPlayerController().Pawn);
	if (GRV != none)
	{
		
		B.DoJump(true);
		GRV.GravityZ = 0;
		GRV.TerminalVelocity = 50;
		BakanPlayerController(B.Controller).IgnoreMoveInput(true);
		B.SetPhysics(PHYS_Falling);	
		B.PhysicsVolume.FluidFriction = 0.8;


	}
	SetTimer(0.75,false,'TriggerMove');		
	SetTimer(25.0,false,'TriggerZeroGEnd');
}
function TriggerMove()
{
	B = BakanPawn(GetALocalPlayerController().Pawn); 
	BakanPlayerController(B.Controller).IgnoreMoveInput(false);
	
}
function TriggerZeroGEnd()
{
	B = BakanPawn(GetALocalPlayerController().Pawn); 
	
	if(GRV != none)
	{

		GRV.TerminalVelocity = 4000;
		GRV.GravityZ = -520;
		B.SetPhysics(PHYS_Walking);
		B.PhysicsVolume.FluidFriction = 0.3;
	}
}
function bool UsedBy(Pawn User)
{
	local BakanPawn P;
	local bool used;

	MyRadius = 200;
	used = super.UsedBy(User);

  	foreach VisibleCollidingActors(class'BakanPawn',P,MyRadius)
  	{ 
  	
  	  if (FacingActivateTrigger  && checked == false && !P.bIsCrouched)
      {
			 TriggerZeroG();
      }

    }
 return used;	 
}
DefaultProperties
{
 Swap = Material'MyPackage.spiralAFLASH_Mat'
 ReSwap = Material'MyPackage.spiralA_Mat'
	ActivateText = "E(Zero Gravity)"


	checked = false
}
