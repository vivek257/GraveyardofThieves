class Teleport_Projectile extends UTProj_LinkPlasma;



simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
        local vector Temp;
		local HowlEar HE;
		local Howl H;
		local CereberusEye CE;
		local EyeClops EC;


		if ( BakanPawn( Other ) != none )
		{
                        //store the instigators (the player that shot the projectile) location and rotation
						if (Instigator.IsA('EyeClops'))
						{
						Temp = EyeClops(Instigator).PlayerDestination[0].Location;
						}
						else if (Instigator.IsA('Howl'))
						{
						 Temp = Howl(Instigator).PlayerDestination.Location;
						}
                        BakanPawn(Other).Teleported = true;
                        Other.SetLocation( Temp );
						foreach WorldInfo.AllActors(class'HowlEar',HE)
						{
							HowlEarController(HE.Controller).GotoState('Patrolling');
						}
						foreach WorldInfo.AllActors(class'Howl',H)
						{
							HowlController(H.Controller).GotoState('Patrolling');
						}
						foreach CollidingActors(class'CereberusEye',CE,2000)
						{
							CerberusEyeController(CE.Controller).GotoState('Patrolling');
						}
						foreach CollidingActors(class'EyeClops',EC,2000)
						{
							EyeClopsController(EC.Controller).GotoState('Patrolling');
						}
                        //PLAY ANY SOUND/EFFECT YOU WANT HERE
                        
		}
		Explode(HitLocation, HitNormal);
	
}
DefaultProperties
{
}
