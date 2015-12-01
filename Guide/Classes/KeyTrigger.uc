class KeyTrigger extends Trigger;
var bool checked;
var() LockTrigger LT;
var() editconst StaticMeshComponent StaticMeshComponent;
var const editconst DynamicLightEnvironmentComponent LightEnvironment;
var BakanPawn B;

function bool UsedBy(Pawn User)
{
	local bool used;
	used = super.UsedBy(User);
	if(LT != none)
	{
		LT.locked = false;
	}
	return used;
}
DefaultProperties
{
			Begin Object  Name=Sprite
		Sprite=none
		HiddenEditor=true
		SpriteCategoryName=none
	End Object
	Components.Add(Sprite)
 
 Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=TRUE
    End Object
    LightEnvironment=MyLightEnvironment
    Components.Add(MyLightEnvironment)

    begin object class=StaticMeshComponent Name=StaticMeshComponent
        StaticMesh=StaticMesh'MyPackage.Key'
        LightEnvironment=MyLightEnvironment
    end object
    Components.Add(StaticMeshComponent)



	checked = false
}
