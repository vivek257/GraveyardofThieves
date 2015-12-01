class HowlController extends UDKBot;
var int index,ind;
var Pawn Player;
var Actor target;
var() Vector TempDest;
var float playerDistance;
var bool GotToDest,currentTargetIsReachable;
var Vector NavigationDestination,NextLocationToGoal,playerseenlocation;
simulated event Possess(Pawn inPawn, bool bVehicleTransition)
{
	super.Possess(inPawn, bVehicleTransition);
	`log("Possessed");
	// Important or bot will not move
	Pawn.SetMovementPhysics();
}

state SearchForPlayer
{
 	event SeePlayer (Pawn Seen)
	{
		`log("I SEE THE PLAYER");
		// Call AIControllers SeePlayer function
		super.SeePlayer(Seen);
		Player = Seen;

		// Get distance to player
		playerDistance = VSize( Pawn.location - Player.location );

		// If within 150 units start shooting at player, otherwise give chase
		if(Player.IsA('BakanPawn'))
		{
			if( playerDistance < 450 )
			 {
			
				GotoState('Shoot');
			 }
		}
	}
	
	
	       function bool FindNavMeshPath()
        {
                // Clear cache and constraints (ignore recycling for the moment)
                NavigationHandle.PathConstraintList = none;
                NavigationHandle.PathGoalList = none;
                // Create constraints
                class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, NavigationDestination );
                class'NavMeshGoal_At'.static.AtLocation( NavigationHandle, NavigationDestination, 50, );
                
                // Find path
                return NavigationHandle.FindPath();
        }

		Begin:
		
        if (Howl(Pawn)!=none)          
           {
				NavigationDestination = Howl(Pawn).PatrolRoute[index].Location;
				Howl(Pawn).AlertComponent.DetachFromAny(); 
				`log("Nav Dest set");
				if (NavigationHandle.PointReachable(NavigationDestination))
					{
						FlushPersistentDebugLines();
						MoveTo(NavigationDestination);
					        
						if(index < Howl(Pawn).PatrolRoute.length - 1)
							{
								// Go to next node
								index++;
							}
						else
							{
								// Return to beginning node
								index = 0;
							}
					}
				else if (FindNavMeshPath())
					{
						NavigationHandle.SetFinalDestination(NavigationDestination);					
						FlushPersistentDebugLines();
						NavigationHandle.DrawPathCache(,TRUE);

						if(NavigationHandle.GetNextMoveLocation(NextLocationToGoal,Pawn.GetCollisionRadius()))
						{
							MoveTo(NextLocationToGoal);
						}
					}
			    else if (!FindNavMeshPath() && !NavigationHandle.PointReachable(NavigationDestination)) 
				{	
					if (FindPathTo(NavigationDestination) != none)
						{
						  FindPathTo(NavigationDestination);
						}
				}

           }
		   Sleep(0.0);
           goto 'Begin';

}

state AttackMoveBakanPawn
{
 ignores SeePlayer;

	// Gets the navmesh path to the player
	function bool FindNavMeshPath()
	{
		`log("Attack Move");
		// Clear cache and constraints (ignore recycling for the moment)
		NavigationHandle.PathConstraintList = none;
		NavigationHandle.PathGoalList = none;
		NavigationHandle.bDebugConstraintsAndGoalEvals = true;

		// Create constraints
		class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle, Player );
		class'NavMeshGoal_At'.static.AtActor( NavigationHandle, Player, 25 );

		// Find path
		return NavigationHandle.FindPath();

	}

function bool LookNavMeshPath()
        {
                // Clear cache and constraints (ignore recycling for the moment)
                NavigationHandle.PathConstraintList = none;
                NavigationHandle.PathGoalList = none;
                // Create constraints
                class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, playerseenlocation );
                class'NavMeshGoal_At'.static.AtLocation( NavigationHandle, playerseenlocation, 50, );
                
                // Find path
                return NavigationHandle.FindPath();
        }

	Begin:
		Howl(Pawn).Mesh.AttachComponentToSocket(Howl(Pawn).AlertComponent,Howl(Pawn).AlertSocket);
        `log("EyeclopsActivated");
		//`log("BEGIN ALERT CHASE");
		Player = GetALocalPlayerController().Pawn;

		// Check if the player is within firing range
		playerDistance = VSize( Pawn.location - Player.location );
		playerseenlocation = Player.Location;

		// There is a direct path available to the player
		if( NavigationHandle.ActorReachable( Player ) )
		{
			/* 
				The player is reachable so move towards him
				Focus on the player
				Offset destination by 100
			*/				
			`log("PLAYER IS ALERT REACHABLE");
			MoveToward( Player,Player, 300 );
		}
		if(!CanSee(BakanPawn(Player)))
		  {
			
		  	if (LookNavMeshPath())
		  		{
		  			MoveTo(playerseenlocation);

					if( playerDistance < 450)
					{
					  GotoState('Shoot');
					}			
		  		} 
		  }
		// No direct path to player, use navmesh to find
		else if( FindNavMeshPath() )
		{
			`log("EYECLOPS ALERT returned TRUE");
	
			// Set the ultimate destination to the players location
			NavigationHandle.SetFinalDestination(Player.Location);
			
			/* 
				TempDest is passed in by reference, is set to next location to move to
				Stay outside of Pawns Collision Radius
			*/
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				`log("EYECLOPS MOVING TOWARD PLAYER");
				MoveTo( TempDest, Player );
			}
		}
		else if (!FindNavMeshPath() && !LookNavMeshPath()) 
			{	
				if (FindPathTo(Player.Location) != none)
				  {
				    FindPathTo(Player.Location);
				  }
			}
		if (BakanPawn(Player).Velocity.Z > 0 )
		 {
			
		 	while (BakanPawn(Player).bJustLanded != true )
		 	{
		 		`log("EYECLOPS PLAYER IS JUMPING");
				Sleep(0.2);

			}
		 }
		else if( playerDistance < 350)
		{

			GotoState('Shoot');
		}
		 else
		{
			// We can't get to the player so just go back to Patrolling
			`log("EYECLOPS UNABLE TO FIND PATH TO PLAYER VIA NAVIGATION MESH");
			Sleep(0.2);
			
		}
		Sleep(0.0);
		goto 'Begin';
}
state Shoot
{
	ignores SeePlayer;
	Begin:
	Howl(Pawn).Mesh.AttachComponentToSocket(Howl(Pawn).AlertComponent,Howl(Pawn).AlertSocket);
		Player = GetALocalPlayerController().Pawn;
		Focus = Player;
		
		
		// Stop pawn from moving
		Pawn.ZeroMovementVariables();
		Sleep(1);
    Pawn.StartFire(0);
    if (BakanPawn(Player).Teleported)
	{ 
		Pawn.StopFire(0);
		GotoState('SearchForPlayer');
		BakanPawn(Player).Teleported = false;
	}
		
		playerDistance = VSize( Pawn.location - Player.location );

		// If the player is too far away

		if(playerDistance > 1024)
		{
			GotoState('SearchForPlayer');
		}
		Sleep(0.0);
		goto 'Begin';
}


DefaultProperties
{
	index = 0;
	ind = 0;
}
