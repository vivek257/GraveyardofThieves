class TeleportVolume extends DetectorTrigger
	placeable;
var() PathNode PatDestination;
var() PathNode DontLookDestination;
var() bool dontlook;
var SoundCue TeleportSound;
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
			if(Other.IsA('BakanPawn') )
			{
				if(dontlook || AlarmTripped)
				
				Other.SetLocation(PatDestination.Location);
				PlaySound(TeleportSound);

			}

}
event UnTouch(Actor Other)
{

}
DefaultProperties
{
	dontlook = false
	TeleportSound = SoundCue'GuideSounds.YaliLaughCue'
}
