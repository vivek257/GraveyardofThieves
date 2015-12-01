class GuideGameInfo extends GameInfo;
var bool bNoSight;
var bool bNoHearing;
var bool bShowSuspicion;
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
return Default.class;
}

DefaultProperties
{

	HUDType=class'Guide.GuideGameHUD'
	PlayerControllerClass=class'Guide.BakanPlayerController'
	DefaultPawnClass = class'Guide.BakanPawn'
	bDelayedStart=false
}
