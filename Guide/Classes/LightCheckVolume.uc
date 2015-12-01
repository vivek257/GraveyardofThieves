class LightCheckVolume extends TriggerVolume
	placeable;
var() PointLight PL;
var bool inlightvolume;
var BakanPawn BP;
var() array<LightCheckVolume> OverlapVolume;
function CheckOverlap()
{
	local float mydist,overlapdist;
	local int i;
	i = 0;
	if(OverlapVolume[i]!=none)
	  {
		
	  	if(i < OverlapVolume.Length - 1)
		{
			if(OverlapVolume[i].inlightvolume && inlightvolume)

			mydist = VSize(PL.Location - BP.Location);
			overlapdist = VSize(OverlapVolume[i].PL.Location - BP.Location);
			if(mydist < overlapdist)
			{
			 BP.LightCheck = self;
			}
		      if(overlapdist < mydist)
				{
				  BP.LightCheck = OverlapVolume[i];
				}
			i++;
		}
		else
		{
		 BP.LightCheck = self;
		}
      }

}
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if(Other.IsA('BakanPawn'))
	{
		inlightvolume = true;
		BP = BakanPawn(Other);
		CheckOverlap();
	}
}

event UnTouch(Actor Other)
{
	local LightCheckVolume LCV;
	if(Other.IsA('BakanPawn'))
	{
		BakanPawn(Other).LightCheck = none;
		inlightvolume = false;
	}
	foreach WorldInfo.AllActors(class'LightCheckVolume',LCV)
	{
		if (LCV.inlightvolume)
		{
			BakanPawn(Other).LightCheck = LCV;
		}

	}
}
DefaultProperties
{
	inlightvolume = false;
}
