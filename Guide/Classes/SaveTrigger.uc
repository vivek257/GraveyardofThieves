class SaveTrigger extends TriggerVolume
placeable;
var() int SaveKismetEventNo;
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	
	if(Other.IsA('BakanPawn'))
	{
		SaveGame();
	}
}
function SaveGame()
{
	local SaveObject SO;

	SO = new class'SaveObject';
	if(class'Engine'.static.BasicLoadObject(SO, "..\\Saves\\SaveGame.bin", true, 0))
	{
		if(SO.CheckPointNumber >= SaveKismetEventNo)
		{
		 class'Engine'.static.BasicSaveObject(SO, "..\\Saves\\SaveGame.bin", true, 0);
		}
		else
		{
		 SO.CheckPointNumber = SaveKismetEventNo;
		 class'Engine'.static.BasicSaveObject(SO, "..\\Saves\\SaveGame.bin", true, 0);
		}
	}
	else
	{
	SO.CheckPointNumber = SaveKismetEventNo;
	class'Engine'.static.BasicSaveObject(SO, "..\\Saves\\SaveGame.bin", true, 0);
	}
}
DefaultProperties
{
	SaveKismetEventNo = 0
}
