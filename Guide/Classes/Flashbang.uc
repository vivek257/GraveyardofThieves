class Flashbang extends UTProjectile;
simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	//Option 1: Sticky grenade
	SetPhysics(PHYS_None);
	
	//Option 2: Non sticky grenade	
	/*if (Pawn(Wall) == None)
	{
		//Reflect off walls, taken from grenade function
		Velocity = 0.75*(( Velocity dot HitNormal ) * HitNormal * -2.0 + Velocity);   // Reflect off Wall w/damping
		Speed = VSize(Velocity);

		if (Velocity.Z > 400)
		{
			Velocity.Z = 0.5 * (400 + Velocity.Z);
		}
	}*/
}
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal);
// Call this to make the mines explode
simulated function CallToExplode()
{   
	local CereberusEye C;
	local BakanPawn B;
	local EyeClops EC;
		Explode(Location,  vect(0,0,0));
	foreach WorldInfo.Game.AllActors(class'BakanPawn',B)
	{

		if(PlayerCanSeeMe())	
		{
			B.cycleScreen = true;
			B.cycleScreenEffects();
		}

	}
	foreach VisibleCollidingActors(class'CereberusEye',C,1000) 
	{
		if (C.LineOfSightTo(self))
		{			
			CerberusEyeController(C.Controller).distraction = self.Location;
			CerberusEyeController(C.Controller).GotoState('Distracted');
		}
	}
	foreach VisibleCollidingActors(class'EyeClops',EC,1000) 
	{
		if (EC.LineOfSightTo(self))
		{			
			EyeClopsController(EC.Controller).distraction = self.Location;
			EyeClopsController(EC.Controller).GotoState('SearchForPlayer');
		}
	}

	ShutDown();
}

DefaultProperties
{
	MaxEffectDistance = 2000
	Speed = 1000
	MaxSpeed = 1000
	AccelRate = 0
	Damage = 0
	MomentumTransfer = 500000
	CheckRadius = 0
	bProjTarget = true
	Physics = PHYS_Falling
	bBounce = true //if you are making non sticky bombs, the bombs will bounce
	RotationRate=(Roll=50000)
	//DesiredRotation=(Roll=30000)
	TossZ=+90.0 //toss height
	bSwitchToZeroCollision = false
	ExplosionLightClass=class'Guide.FlashbangLight'
	ProjFlightTemplate=ParticleSystem'MyPackage.AppleBomb'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'
	LifeSpan = 300; 
}
