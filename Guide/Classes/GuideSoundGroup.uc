class GuideSoundGroup extends UTPawnSoundGroup;
struct FootStepSoundInfo
{
	var name MaterialType;
	var SoundCue Sound;
	var float LoudnessModifier;
};

var SoundCue PainSound;
var SoundCue DeathSound;
var SoundCue DefaultFootStep;
var SoundCue DefaultJump;
var SoundCue DefaultLand;

var array<FootStepSoundInfo> FootStepSounds;
var array<FootStepSoundInfo> LandingSounds;
var array<FootStepSoundInfo> JumpingSounds;


static function PlayFootstepSounds(BakanPawn P, name MaterialType) 
{
	local int i; 
	local SoundCue Result;
	local float Loudness;
	
	i = default.FootStepSounds.Find('MaterialType', MaterialType);

	Result = (i == -1) ? default.DefaultFootStep : default.FootStepSounds[i].Sound; // checking for a '' material in case of empty array elements
	Loudness = (i == -1) ? 0.2 : default.FootStepSounds[i].LoudnessModifier;
	Loudness *= VSize(P.Velocity)/P.GroundSpeed;
	P.Loudness = Loudness;
	Result.VolumeMultiplier = Loudness;
	`log('Multiplier  is'); 
	`log(Result.VolumeMultiplier);
	`log('FootStepSoundInfo SoundClass is'); 
	`log(Result);
	P.PlaySound(Result);
	P.MakeNoise(Loudness, 'Footstep');
}
static function PlayJumpingSound(BakanPawn P, name MaterialType)
{
	local int i;
	local SoundCue Result;
	local float Loudness;
	
	i = default.JumpingSounds.Find('MaterialType', MaterialType);
	Result = (i == -1) ? default.DefaultJump : default.JumpingSounds[i].Sound; // checking for a '' material in case of empty array elements
	Loudness = (i == -1) ? 0.3 : default.FootStepSounds[i].LoudnessModifier;
	Loudness *= VSize(P.Velocity)/P.GroundSpeed;
	P.Loudness = Loudness;
	Result.VolumeMultiplier = Loudness;
	`log(Result);
	P.PlaySound(Result,true);
	P.MakeNoise(Loudness, 'Footstep');
}

static function PlayLandingSound(BakanPawn P, name MaterialType)
{
	local int i;
	local SoundCue Result;
	local float Loudness;

	i = default.LandingSounds.Find('MaterialType', MaterialType);
	Result = (i == -1) ? default.DefaultLand : default.LandingSounds[i].Sound; // checking for a '' material in case of empty array elements
	Loudness = (i == -1) ? 0.5 : default.FootStepSounds[i].LoudnessModifier;
	P.Loudness = Loudness;
	`log(Result);
	P.PlaySound(Result);
	P.MakeNoise(Loudness, 'Footstep');
}
DefaultProperties
{
	DefaultFootStep=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_StoneCue'
	DefaultJump=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_StoneJumpCue'
	DefaultLand=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_StoneLandCue'

	FootstepSounds[0]=(MaterialType=PM_Stone,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_StoneCue',LoudnessModifier=0.9)
	FootstepSounds[1]=(MaterialType=PM_Dirt,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_DirtCue',LoudnessModifier=0.3)
	FootstepSounds[2]=(MaterialType=PM_Energy,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_EnergyCue',LoudnessModifier=0.01)
	FootstepSounds[3]=(MaterialType=PM_Flesh_Human,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FleshCue',LoudnessModifier=0.25)
	FootstepSounds[4]=(MaterialType=PM_Foliage,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FoliageCue',LoudnessModifier=0.35)
	FootstepSounds[5]=(MaterialType=PM_Glass,Sound=SoundCue'GuideBank.Tile_FootStep',LoudnessModifier=0.7)
	FootstepSounds[6]=(MaterialType=Water,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterDeepCue',LoudnessModifier=0.4)
	FootstepSounds[7]=(MaterialType=ShallowWater,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterShallowCue',LoudnessModifier=0.7)
	FootstepSounds[8]=(MaterialType=PM_Metal,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MetalCue',LoudnessModifier=1.0)
	FootstepSounds[9]=(MaterialType=PM_Snow,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_SnowCue',LoudnessModifier=0.25)
	FootstepSounds[10]=(MaterialType=PM_Wood,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WoodCue',LoudnessModifier=0.6)


	JumpingSounds[0]=(MaterialType=PM_Stone,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_StoneJumpCue',LoudnessModifier=0.2)
	JumpingSounds[1]=(MaterialType=PM_Dirt,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_DirtJumpCue',LoudnessModifier=0.2)
	JumpingSounds[2]=(MaterialType=PM_Energy,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_EnergyJumpCue',LoudnessModifier=0.01)
	JumpingSounds[3]=(MaterialType=PM_Flesh_Human,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FleshJumpCue',LoudnessModifier=0.2)
	JumpingSounds[4]=(MaterialType=PM_Foliage,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FoliageJumpCue',LoudnessModifier=0.2)
	JumpingSounds[5]=(MaterialType=PM_Glass,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GlassPlateJumpCue',LoudnessModifier=0.2)
	JumpingSounds[6]=(MaterialType=PM_GlassBroken,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GlassBrokenJumpCue',LoudnessModifier=0.2)
	JumpingSounds[7]=(MaterialType=PM_Grass,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GrassJumpCue',LoudnessModifier=0.2)
	JumpingSounds[8]=(MaterialType=PM_Metal,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MetalJumpCue',LoudnessModifier=0.2)
	JumpingSounds[9]=(MaterialType=PM_Mud,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MudJumpCue',LoudnessModifier=0.2)
	JumpingSounds[10]=(MaterialType=PM_Snow,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_SnowJumpCue',LoudnessModifier=0.2)
	JumpingSounds[11]=(MaterialType=PM_Tile,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_TileJumpCue',LoudnessModifier=0.2)
	JumpingSounds[12]=(MaterialType=Water,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterDeepJumpCue',LoudnessModifier=0.2)
	JumpingSounds[13]=(MaterialType=ShallowWater,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterShallowJumpCue',LoudnessModifier=0.2)
	JumpingSounds[14]=(MaterialType=PM_Wood,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WoodJumpCue',LoudnessModifier=0.2)

	LandingSounds[0]=(MaterialType=PM_Stone,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_StoneLandCue',LoudnessModifier=0.4)
	LandingSounds[1]=(MaterialType=PM_Dirt,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_DirtLandCue',LoudnessModifier=0.3)
	LandingSounds[2]=(MaterialType=PM_Energy,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_EnergyLandCue',LoudnessModifier=0.01)
	LandingSounds[3]=(MaterialType=PM_Flesh_Human,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FleshLandCue',LoudnessModifier=0.35)
	LandingSounds[4]=(MaterialType=PM_Foliage,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FoliageLandCue',LoudnessModifier=0.45)
	LandingSounds[5]=(MaterialType=PM_Glass,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GlassPlateLandCue',LoudnessModifier=0.5)
	LandingSounds[6]=(MaterialType=PM_GlassBroken,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GlassBrokenLandCue',LoudnessModifier=0.5)
	LandingSounds[7]=(MaterialType=PM_Grass,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GrassLandCue',LoudnessModifier=0.3)
	LandingSounds[8]=(MaterialType=PM_Metal,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MetalLandCue',LoudnessModifier=0.5)
	LandingSounds[9]=(MaterialType=PM_Mud,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MudLandCue',LoudnessModifier=0.3)
	LandingSounds[10]=(MaterialType=PM_Snow,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_SnowLandCue',LoudnessModifier=0.3)
	LandingSounds[11]=(MaterialType=PM_Tile,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_TileLandCue',LoudnessModifier=0.4)
	LandingSounds[12]=(MaterialType=Water,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterDeepLandCue',LoudnessModifier=0.5)
	LandingSounds[13]=(MaterialType=ShallowWater,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterShallowLandCue',LoudnessModifier=0.5)
	LandingSounds[14]=(MaterialType=PM_Wood,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WoodLandCue',LoudnessModifier=0.4)
}
