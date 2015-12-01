class ElectricVolume extends DetectorTrigger
	placeable;
var BakanPlayerController PC;
var CameraAnim p_anim;
var SoundCue shocked;
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local float scale, rate, blendInTime, blendOutTime;
    local bool loop, bIsDamageShake;
	local BakanPawn P;
	
	scale = 1.0f;
	rate = 1.0f;
	blendInTime = 0.1f;
	blendOutTime = 0.1f;
	loop = false;
	bIsdamageShake = false; 
	if(Other.IsA('BakanPawn'))
	{
		p_anim = CameraAnim'GuideTech.OutOfBody';
		foreach WorldInfo.AllActors(class 'BakanPawn',P)
		{
			
			P.exposure+=25.0;
		}
		PC = BakanPlayerController(BakanPawn(Other).Controller);
		PlaySound(shocked);
		PC.PlayCameraAnim(p_anim, scale, rate, blendInTime, blendOutTime, loop, bisdamageShake);
	}
}
event UnTouch(Actor Other)
{
	if(Other.IsA('BakanPawn'))
	{
		BakanPawn(Other).exposure-=25;;
	}
}
DefaultProperties
{
	shocked = SoundCue'GuideSounds.Shock_Cue'
}
