class HowlEarController extends UDKBot;

var float fLastHeardTime;
var Actor LastHeardActor;
var float LevelOfSuspicion;
var bool bStartled;
var bool bPatrolling;
var bool bSearching;
var bool bSearchedLastPosition;
var bool bAttackMove;
var Vector distraction;
var float StartedExamining;
var Vector LastHeardPosition;
var float flastSeenTime;
var float FinishedLastMove;
var float IdleTime;
var int index;
var int CurrentPatrolPoint;
var Vector Destination;
var Vector NewDestination;
var BakanPawn PC;
var ParticleSystem Smoke;
var float PlayerDistance;
var Pawn Player;
var BakanPawn BP;
var BakanPlayerController BPC;
var CameraAnim p_anim;
var Vector MoveToVector;
var Howl HOController;
simulated event Possess(Pawn inPawn, bool bVehicleTransition)
{
	super.Possess(inPawn, bVehicleTransition);
	`log("Possessed");
	// Important or bot will not move
	Pawn.SetMovementPhysics();
}
/**
HearNoise
    Counterpart to the Actor::MakeNoise() function, called whenever this player is within range of a given noise.
    Used as AI audio cues, instead of processing actual sounds.
*/

event HearNoise( float Loudness, Actor NoiseMaker, optional Name NoiseType )
{
	local float CurrentLevelOfSuspicion;
	PlayerDistance = VSize( Pawn.location - NoiseMaker.location );
	if(PlayerDistance > 512)
		return;
	`log("I CAN HEAR A NOISE");
	`log(Pawn);

	if (GuideGameInfo(WorldInfo.Game).bNoHearing || Loudness < GetHearingThreshold() || NoiseMaker == Pawn || HowlEar(NoiseMaker) != none || CereberusEye(NoiseMaker) != none || EyeClops(NoiseMaker) != none || Howl(NoiseMaker) != none)
		return;

    fLastHeardTime = WorldInfo.TimeSeconds;
    LastHeardActor = NoiseMaker;
	CurrentLevelOfSuspicion = LevelOfSuspicion;
	
	if (NoiseMaker.Location.Z - Pawn.Location.Z > 64.0 || Pawn.Location.Z - NoiseMaker.Location.Z > 64.0 )
	{
		return;
	}
	 if (NoiseMaker.IsA('BakanPawn'))
	{
		Player = Pawn(NoiseMaker);
		LevelOfSuspicion += (NoiseType == 'Distraction') ? Loudness : 0.3*Loudness;
		LastHeardPosition = NoiseMaker.Location;
		fLastHeardTime = WorldInfo.TimeSeconds;
		if (CurrentLevelOfSuspicion < 1.0)
		{
			LevelOfSuspicion = fclamp(LevelOfSuspicion, 0, 0.99);
		}
		StartedExamining = 0;
	}

	LevelOfSuspicion = fclamp(LevelOfSuspicion, 0, 10.0);
	`log(LevelOfSuspicion);
	if (LevelOfSuspicion >= 0.2 && LevelOfSuspicion < 0.5)
	{
		bStartled = true;
	}
	else if (LevelOfSuspicion >= 0.1 && PlayerDistance < 512)
	{
		bStartled = true;
	}

	WhatToDoNext();
}

simulated function float GetHearingThreshold()
{
	return 0.3;
}


/** triggers ExecuteWhatToDoNext() to occur during the next tick
 * this is also where logic that is unsafe to do during the physics tick should be added
 * @note: in state code, you probably want LatentWhatToDoNext() so the state is paused while waiting for ExecuteWhatToDoNext() to be called
 */
event WhatToDoNext()
{   
	super.WhatToDoNext();

    if (bExecutingWhatToDoNext || Pawn == none)
    {
		return;
    }
    
    DecisionComponent.bTriggered = true;
}

/**
ExecuteWhatToDoNext
    Entry point for AI decision making
    This gets executed during the physics tick so actions that could change the physics state (e.g. firing weapons) are not allowed
*/
protected event ExecuteWhatToDoNext()
{

	PlayerDistance = VSize( Pawn.location - Player.location );
	if (Pawn == None)
        return;

    if (Pawn.Physics == PHYS_None)
        Pawn.SetMovementPhysics();

    if ((Pawn.Physics == PHYS_Falling))
        return;
	if (ShouldEngageEnemy())
	{
		if (WorldInfo.TimeSeconds - FinishedLastMove > IdleTime)
		{
			SetDestinationPosition(RandomLocationOnCircumference(Pawn.Location, 64.0));
			bAttackMove=true;
			
			
		}
		else
		{
			bAttackMove=false;
		}
		HowlEar(Pawn).ALR.RedRing();
		GoToState('EngageEnemy');

		return;
	}
	if (bStartled && PlayerDistance < 512)
	{
		HowlEar(Pawn).ALR.RedRing();
		
		NewDestination = LastHeardPosition;
		while (CanFindPath(,NewDestination) == 0 || NewDestination == Vect(0,0,0))
			{
				NewDestination = RandomLocationOnCircumference(LastHeardPosition, 512.0);
			}
		SetDestinationPosition(NewDestination);
		
		GoToState('SearchArea');
		return;

	}
	else if (!ShouldEngageEnemy() && !bStartled)
	{
		GotoState('Patrolling');
	}
}
/** Will pick a random spot in a radius around the Origin of radius Distance **/
function Vector RandomLocationOnCircumference( Vector Origin, float Distance, optional bool RandomHeight = false, optional float MinDistance = -1.0 )
{
    local Vector V;
    local float Angle;
	local float finalDist;

	if (MinDistance == -1.0)
	{
		finalDist = Distance;
	}
	else
	{
		finalDist = RandRange(MinDistance, Distance);
	}

    Angle = FRand() * Pi * 2.0;

    V.x = Sin( Angle ) * finalDist;
    V.y = Cos( Angle ) * finalDist;

	if (RandomHeight)
	{
		V.Z = Tan( Angle ) * finalDist;
	}

    return Origin + V;
}
simulated function bool ShouldEngageEnemy()
{
	return (LevelOfSuspicion > 0.9 && (WorldInfo.TimeSeconds - fLastHeardTime < 10.0) && PlayerDistance  < 300);
	`log('Should EngageEnemy ENEMY');
}
/**
 * Try to find a path to the target using navmesh
 */

function bool FindNavMeshPath(optional Actor Target, optional Vector TargetDest)
{
	if (Target == none && TargetDest == Vect(0,0,0))
	{
		return false;
	}
     
	// Clear cache and constraints (ignore recycling for the moment)
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;

    // Create constraints
	if (Target != none)
	{
		class'NavMeshPath_Toward'.static.TowardGoal(NavigationHandle, Target);
		class'NavMeshGoal_At'.static.AtActor(NavigationHandle, Target, 32);
	}
	else
	{
		class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, TargetDest ); 
		class'NavMeshGoal_At'.static.AtLocation( NavigationHandle, TargetDest, 50, );
	}

    // Find path
    return NavigationHandle.FindPath();
}
simulated function int CanFindPath(optional Actor DestTarget, optional Vector DestPoint)
{
	if(DestTarget != none)
	{
		// Check if the target is directly reachable
		if (NavigationHandle.ActorReachable(DestTarget) || ActorReachable(DestTarget))
		{
			return 1;
		}
		// Failing that, check if a path can be found using navmesh
		else if(FindNavMeshPath(DestTarget))
		{
			return 2;
		}
		// Failing that, check if a path can be found using pathnodes
		else if (FindPathToward(DestTarget) != none)
		{
			return 3;
		}
	}
	else if (DestPoint != Vect(0,0,0))
	{
		if (NavigationHandle.PointReachable(DestPoint) || PointReachable(DestPoint) )
		{
			return 1;
		}
		else if (FindNavMeshPath(,DestPoint) )
		{
			return 2;
		}
		else if (FindPathTo(DestPoint) != none)
		{
			return 3;
		}
	}
	// If it didn't find a route, return a fail code
	return 0;
}
/**
 * Returns a Vector which indicates where the bot's next move should be, using whichever method it can to reach the supplied destination Actor or Vector
 */
simulated function Vector GetNextMove(optional Actor DestActor, optional Vector DestVector)
{
	local Vector TempDest;

	if (DestActor != none)
	{
		switch(CanFindPath(DestActor))
		{
			// If the enemy is directly reachable then run straight for them
		case 1:
			return DestVector ;
		case 2:
			// If not, but I can find a path with navmesh then use that
			NavigationHandle.SetFinalDestination(DestVector);
			if (NavigationHandle.GetNextMoveLocation(TempDest, Pawn.GetCollisionRadius()))
			{
				return TempDest;
			}
			break;
		case 3:
			// If not, but I can find a path using pathnodes then use that instead
			return FindPathToward(DestActor).Location;
			break;
		Default:
			return Vect(0,0,0);
		}
	}
	else if (DestVector != Vect(0,0,0))
	{
		switch(CanFindPath(,DestVector))
		{
			// If the enemy is directly reachable then run straight for them
		case 1:
			return DestVector;
		case 2:
			// If not, but I can find a path with navmesh then use that
			NavigationHandle.SetFinalDestination(DestVector);
			if (NavigationHandle.GetNextMoveLocation(TempDest, Pawn.GetCollisionRadius()))
			{
				return TempDest;
			}
			break;
		case 3:
			// If not, but I can find a path using pathnodes then use that instead
			return FindPathTo(DestVector).Location;
			break;
		Default:
			return Vect(0,0,0);
		}
	}
	return Vect(0,0,0);
}
auto State Patrolling
{
	event BeginState(Name PreviousStateName)
	{
		SetTimer(0.1, true);
		bPatrolling = true;
	}

	event EndState(Name NextStateName)
	{
		bPatrolling = false;
	}

Begin:
	Destination = HowlEar(Pawn).PatrolRoute[index].Location;
	MoveTo(GetNextMove(,Destination),Focus,,true);
	FinishedLastMove = WorldInfo.TimeSeconds;
	// Go to next node
	
     if(index < HowlEar(Pawn).PatrolRoute.length - 1)
		{
			// Return to beginning node
			index++;
		}
	else
	{
		index = 0;
	}
			
		Sleep(0.0);
		Goto('Begin');
}
State SearchArea
{

	event BeginState(Name PreviousStateName)
	{
		bSearching = true;
		bSearchedLastPosition=false;
	}

	simulated function float GetHearingThreshold()
	{
		return 0.2;
	}

Begin:
    MoveTo(GetNextMove(,GetDestinationPosition()),Focus,,true);
	FinishedLastMove = WorldInfo.TimeSeconds;
	IdleTime = fclamp(1.0 + frand() * 2.0, 1.0, 3.0);
	bSearchedLastPosition = true;
    LatentWhatToDoNext();
	Sleep(0.f);
	GoTo('Begin');
}
state EngageEnemy
{
	

	event BeginState(Name PreviousStateName)
	{
		p_anim = CameraAnim'GuidePackageForJafar.Shake';
		BPC = BakanPlayerController(GetALocalPlayerController());
		SetTimer(0.1, true);
		HOController = HowlEar(Pawn).HO;
		HowlController(HOController.Controller).GotoState('AttackMoveBakanPawn');
	}

	event Timer()
	{
		if ((WorldInfo.TimeSeconds - fLastHeardTime) > 10.0)
		{
			LevelOfSuspicion -= 0.003;
			LevelOfSuspicion = fclamp(LevelOfSuspicion, 0.0, 10.0);
		}
		else
		{
			if (WorldInfo.TimeSeconds - fLastHeardTime > 0.5)
			{
				//ShootAt(,RandomLocationOnCircumference(LastHeardPosition, 512.0));
				WorldInfo.MyEmitterPool.SpawnEmitter(Smoke,Pawn.Location);



			}
			else
			{
				//ShootAt(,LastHeardPosition);
				WorldInfo.MyEmitterPool.SpawnEmitter(Smoke,Pawn.Location);
				BPC.PlayCameraAnim(p_anim);
				//SetTimer(3.0,false,'LockMouse');

			}
		}
	}

	simulated function float GetHearingThreshold()
	{
		return 0.4;
	}

Begin:
	`log('EngagingEnemy');
	if (bAttackMove)
	{
		MoveTo(GetNextMove(,GetDestinationPosition()),,,false);
		FinishedLastMove = WorldInfo.TimeSeconds;
		IdleTime = fclamp(2.0 + frand() * 1.0, 2.0, 3.0);
	}
    LatentWhatToDoNext();
	Sleep(0.f);
	GoTo('Begin');


}
state Distracted
{

	ignores HearNoise;

	Begin:
		 if (HowlEar(Pawn)!=none)          
			{				
				SetTimer(10.0,false,'SlowDownEnd'); 				
			}		
}

function SlowDownEnd()
{
    Pawn.GroundSpeed = 400;
	GotoState('Patrolling');

}
DefaultProperties
{
	index = 0
	Smoke = ParticleSystem'GuidePackageforJafar.Effects.P_FX_SmokeColumn'
	
}
