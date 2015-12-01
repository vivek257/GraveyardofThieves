class PlayerFlashLight extends SpotLightMovable
	notplaceable;
	
DefaultProperties
{
	Begin Object Name=SpotLightComponent0
		Radius=1000
		Brightness=3
		LightColor=(R=255,G=240,B=190)
		CastShadows=false
	End Object
	Components.Add(SpotLightComponent0)
	bNoDelete=false


}