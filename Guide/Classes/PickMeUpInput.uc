class PickMeUpInput extends PlayerInput;
var IntPoint MousePosition;

var bool HoldingLeftMouse;
var bool HoldingRightMouse;
var bool HoldingMiddleMouse;
var bool QuitFlag;
var GuideGameHUD GGH;
var HUDKismetSeqAct_RenderObject HoldLeftObject;
var HUDKismetSeqAct_RenderObject HoldRightObject;
var HUDKismetSeqAct_RenderObject HoldMiddleObject;
var int i;
var HUDKismetSeqAct_RenderObject HUDObject;
var HUDKismetSeqAct_RenderObject MouseObject;

function MouseLeftPressed()
{
	if (HoldingLeftMouse == false)
	{
		HoldingLeftMouse = true;
		if (HUDObject != None)
			HUDObject.MouseLeftPressed();
		if (MouseObject != None)
			MouseObject.MouseLeftPressed();
	}
}
function MouseLeftReleased()
{
	if (HoldingLeftMouse == true)
	{
		HoldingLeftMouse = false;
		if (HUDObject != None)
			HUDObject.MouseLeftReleased();
		if (MouseObject != None)
			MouseObject.MouseLeftReleased();
	}
}
function MouseRightPressed()
{
	if (HoldingRightMouse == false)
	{
		HoldingRightMouse = true;
		if (HUDObject != None)
			HUDObject.MouseRightPressed();
		if (MouseObject != None)
			MouseObject.MouseRightPressed();
	}
}
function MouseRightReleased()
{
	if (HoldingRightMouse == true)
	{
		HoldingRightMouse = false;
		if (HUDObject != None)
			HUDObject.MouseRightReleased();
		if (MouseObject != None)
			MouseObject.MouseRightReleased();
	}
}
function MouseMiddlePressed()
{
if (HoldingMiddleMouse == false)
	{
		HoldingMiddleMouse = true;
		if (HUDObject != None)
			HUDObject.MouseMiddlePressed();
		if (MouseObject != None)
			MouseObject.MouseMiddlePressed();
	}
}
function MouseMiddleReleased()
{
	if (HoldingMiddleMouse == true)
	{
		HoldingMiddleMouse = false;
		if (HUDObject != None)
			HUDObject.MouseMiddleReleased();
		if (MouseObject != None)
			MouseObject.MouseMiddleReleased();
	}
}
function MouseScrollUp()
{
	if (HUDObject != None)
		HUDObject.MouseScrollUp();
	if (MouseObject != None)
		MouseObject.MouseScrollUp();
}
function MouseScrollDown()
{
	if (HUDObject != None)
		HUDObject.MouseScrollDown();
	if (MouseObject != None)
		MouseObject.MouseScrollDown();
}

simulated exec function ToggleTranslocator() {
  local Actor HitActor;
  local BakanPawn NP;
  foreach WorldInfo.AllPawns(class'BakanPawn',NP)
  {
  HitActor = NP.MP;
  }
  if(HitActor.IsA('PickMeUp'))

    PickMeUp(HitActor).ToggleGrab();
}

simulated exec function Duck()
{
		if(bDuck == 0) bDuck = 1;
}
simulated exec function UnDuck()
{
		if(bDuck == 1) bDuck = 0;
}

// exec is used for functions that can be called from the console and by keys.
exec function QuitGame()
{
	
	i++;
	GGH = GuideGameHUD(GetALocalPlayerController().myHUD);
	GGH.ExitGame = true;
	GGH.ActivateTriggerVisible = false;
	GGH.StealableItemVisible = false;
	GGH.LoadingTriggerVisible = false;
	GGH.DisplayString = "Do you Want to exit the Game ? (Y/N)";
	QuitFlag = true;
	if(i%2==0)
	{
		QuitGameNo();
	}
	 
}

exec function QuitGameYes()
{

	if(QuitFlag)
	{
		ConsoleCommand("Quit");// call the quit command to quit.
	}
}

exec function QuitGameNo()
{
	//`log('QuitGameNo Is being CALLED !!!!');
	if(QuitFlag)
	{ 
	`log('QuitGameNo QuitFlag Is true');
	 GGH = GuideGameHUD(GetALocalPlayerController().myHUD);
	 GGH.ExitGame = false;
	 GGH.DisplayString = "";
	 QuitFlag = false;
	} 

}
DefaultProperties
{
	i=0
}
