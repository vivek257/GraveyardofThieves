class GuideGameHUD extends HUD;
var Actor HitActor;
var bool ActivateTriggerVisible,LoadingTriggerVisible,StealableItemVisible,DefaultCrosshairImage,PickupText,ExitGame;
var Texture2D CrosshairImage;
var string DisplayString;
function DrawHUD() {
  Super.DrawHUD();
		Canvas.SetPos(Canvas.ClipX/2, Canvas.ClipY-30, 0);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.Font = class'Engine'.static.GetMediumFont();
		Canvas.DrawText("Visibility: "@int(BakanPawn(PlayerOwner.Pawn).Hidden())$"%");
		if(DefaultCrosshairImage)
		{
			Canvas.SetPos(Canvas.ClipX/2, Canvas.ClipY/2);
			Canvas.DrawText("."); 

		}
		/*if(LightTriggerVisible)
		{ 
				Canvas.SetDrawColor(255, 255, 255, 230);
				Canvas.SetPos(CenterX-(CrosshairImage.SizeX*0.5),CenterY-(CrosshairImage.SizeY*0.5));
				Canvas.DrawTexture(CrosshairImage,1);
		}*/
		if(ActivateTriggerVisible)
		{
			Canvas.SetPos(Canvas.ClipX/2, Canvas.ClipY/2);
			
			if(DisplayString == "")
			{
				Canvas.DrawText(""); 
			}
			else
			{
				Canvas.DrawText(DisplayString);
			}
		}
		if(StealableItemVisible)
		{
			Canvas.SetPos(Canvas.ClipX/2, Canvas.ClipY/2);
			
			if(DisplayString == "")
			{
				Canvas.DrawText(""); 
			}
			else
			{
				Canvas.DrawText(DisplayString);
			}
		}
		if(LoadingTriggerVisible)
		{
			Canvas.SetPos(Canvas.ClipX/2, Canvas.ClipY/2);
			
			if(DisplayString == "")
			{
				Canvas.DrawText(""); 
			}
			else
			{
				Canvas.DrawText(DisplayString);
			}
		}
		if(PickupText)
		{
			Canvas.SetPos(Canvas.ClipX/2, Canvas.ClipY/2);
			Canvas.DrawText(DisplayString);
		}
		if (ExitGame)
		{
			Canvas.SetPos(Canvas.ClipX/2, Canvas.ClipY/2);
			if(DisplayString == "")
			{
				Canvas.DrawText(""); 
			}
			else
			{
				Canvas.DrawText(DisplayString);
			}
		}


  //HUDTrace();
}

/*function HUDTrace() {
  local Vector Loc, Norm, End, PlayerViewPointLoc;
  local BakanPlayerController Player;
  local Rotator PlayerViewPointRot;
  local BakanPawn B;
  foreach WorldInfo.AllActors(class 'BakanPawn',B)
  {
   B.GetActorEyesViewPoint(PlayerViewPointLoc, PlayerViewPointRot);
   PlayerViewPointLoc = PlayerViewPointLoc + (32 * Vector(PlayerViewPointRot));
   End = PlayerViewPointLoc + Normal(Vector(PlayerViewPointRot)) * 32768;
   HitActor = Trace(Loc, Norm, End, PlayerViewPointLoc, true);
  }
}*/



DefaultProperties
{

	DefaultCrosshairImage = false
		ActivateTriggerVisible = false
	ExitGame = false;
	CrosshairImage = Texture2D'GuideTech.Crossbones'

}
