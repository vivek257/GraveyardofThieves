class GuideGame extends UTGame;
function AddDefaultInventory (pawn P)
{
    local Weapon humanWeapon;
	local Weapon FlWeapon;
    humanWeapon = Spawn(class'Guide.RCMineWeapon');
	FlWeapon = Spawn(class'Guide.FlashGun');
    if(P.IsA('BakanPawn'))
    {
 		FlWeapon.GiveTo(P);
    	humanWeapon.GiveTo(P); 

    }

}
// disabled functions
function bool CheckScore(PlayerReplicationInfo Scorer);
function ScoreKill(Controller Killer, Controller Other);
function SendFlagKillMessage(Controller Killer, UTPlayerReplicationInfo KillerPRI);
function PlayRegularEndOfMatchMessage(); 
function AnnounceScore(int ScoringTeam);
function Logout(Controller Exiting);
function ParseSpeechRecipients(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words, out array<UTBot> Recipients);
function ProcessSpeechOrders(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words, const out array<UTBot> Recipients);
function ProcessSpeechRecognition(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words);
function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> DamageType);
function SetTeam(Controller Other, UTTeamInfo NewTeam, bool bNewTeam);
function PlayStartupMessage();
function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType );
DefaultProperties
{
	NumBots = 0
    MaxSpectatorsAllowed=0
    MaxPlayersAllowed=2
	HUDType=class'Guide.GuideGameHUD'
	bUseClassicHUD=true
	PlayerControllerClass=class'Guide.BakanPlayerController'
	DefaultPawnClass = class'Guide.BakanPawn'
	bDelayedStart=false
    //FlagKillMessageName=None
    DeathMessageClass=None
    CountDown=0
}
