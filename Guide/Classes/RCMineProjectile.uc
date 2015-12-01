class RCMineProjectile extends UTProj_Grenade;


// Call this to make the mines explode
simulated function Timer()
{   
	local HowlEar H;
	
	foreach CollidingActors(class'HowlEar',H,2000)
	{
	 H.GroundSpeed = 0;
	 HowlEarController(H.Controller).GotoState('Distracted');
	}
	Explode(Location,  vect(0,0,0));


	
	ShutDown();
}

defaultproperties
{
	MaxEffectDistance = 2000
	//Make the range short, incraese the speed to make it shoot further
	Speed = 1000
	MaxSpeed = 1000
	AccelRate = 0
	Damage=0.0
	MomentumTransfer = 500000
	CheckRadius = 0
	Physics = PHYS_Falling
	bProjTarget = true
	bBounce = true //if you are making non sticky bombs, the bombs will bounce
	RotationRate=(Roll=50000)
	//DesiredRotation=(Roll=30000)
	TossZ=+90.0 //toss height
	bSwitchToZeroCollision = false
	ExplosionLightClass=class'Guide.FlashbangLight'
	ProjFlightTemplate=ParticleSystem'MyPackage.OrangeBomb'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'
	
	MyDamageType = class'UTDmgType_Rocket'
	LifeSpan = 300; //so that the projectile model won't vanish
}

