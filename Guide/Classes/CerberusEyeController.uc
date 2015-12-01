class CerberusEyeController extends AIController;
var Actor target;
var() Vector TempDest;
var float playerDistance;
var bool GotToDest,currentTargetIsReachable;
var Vector NavigationDestination,NextLocationToGoal,playerseenlocation,lightmadelocation,distraction;
var Vector2D DistanceCheck;
var int index,ind;

var BakanPawn BP;
var Pawn Player;
var CereberusEye CE;
var Controller CEI;
var EyeClops ECT;
var SkeletalMesh AlertMesh,NormalMesh;
simulated event Possess(Pawn inPawn, bool bVehicleTransition)
{
	super.Possess(inPawn, bVehicleTransition);
	`log("Possessed");
	// Important or bot will not move
	Pawn.SetMovementPhysics();
}

	event SeePlayer (Pawn Seen)
	{
		`log("I SEE THE PLAYER");
		// Call AIControllers SeePlayer function
		super.SeePlayer(Seen);
		Player = Seen;
		
		ECT = CereberusEye(Pawn).EC[0];	
		// Get distance to player
		playerDistance = VSize( Pawn.location - Player.location );
		if(Seen.IsA('BakanPawn') && playerDistance<1500)
		{
			CereberusEye(Pawn).UnhideAlertRing();
		}
		// If within 150 units start shooting at player, otherwise give chase
		if(Seen.IsA('BakanPawn') && playerDistance < 512)
		{			
			
			
			 if (BakanPawn(Seen).Hidden() < 50)
			 {
				BeginState('Patrolling');
				
				 
			 }
			 
			 if(BakanPawn(Seen).Hidden() > 50 && !BakanPawn(Seen).bIsInvisible)
			 {
				
				playerseenlocation = Seen.Location;
				
			 	BeginState('Investigate');
				`log("investigate");
				
			 }
			 if(BakanPawn(Seen).Hidden() > 60)
			 {
				if(!BakanPawn(Seen).bIsInvisible) 
				{ 
				 `log("Chasing");
				 CereberusEye(Pawn).ALR.RedRing();

				 GotoState('Chase');
				 CereberusEye(Pawn).Mesh.SetSkeletalMesh(AlertMesh);
				 //EyeClopsController(ECT.Controller).GotoState('AttackMoveBakanPawn');
				}
			 }
			if( playerDistance < 350 && !BakanPawn(Seen).bIsInvisible && BakanPawn(Seen).Hidden()!= 0)
			  {
				GotoState('Shoot');
				 CereberusEye(Pawn).ALR.RedRing();
				 EyeClopsController(ECT.Controller).GotoState('AttackMoveBakanPawn');

			  }	
		}
	}
auto state Patrolling
{
	
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
		 
		
        if (CereberusEye(Pawn)!=none)          
           {
				NavigationDestination = CereberusEye(Pawn).PatDestination[index].Location;
				
				
				//`log("Nav Dest set");
				if (NavigationHandle.PointReachable(NavigationDestination))
					{
						FlushPersistentDebugLines();
						MoveTo(NavigationDestination);
					        
						if(index < CereberusEye(Pawn).PatDestination.length - 1)
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
						//NavigationHandle.DrawPathCache(,TRUE);
						
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
					else
					{
						Pawn.SetLocation(NavigationDestination);
					}
				}
           }
		   Sleep(0.0);
           goto 'Begin';
}
// Chases the player using direct movetoward if player is reachable and pathfinding if not
state Chase
{

	

	// Gets the navmesh path to the player

	function bool FindNavMeshPath()
	{
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
	function AlertCerBros()
	{
		while (ind < 2)
		{
			CE = CereberusEye(Pawn).CerBros[ind];
			CE.Controller.GotoState('AlertChase');
			ind++;
		}
	}
	Begin:
		CereberusEye(Pawn).Mesh.AttachComponentToSocket(CereberusEye(Pawn).AlertComponent,CereberusEye(Pawn).AlertSocket);
		//`log("BEGIN STATE CHASE");
		Player = GetALocalPlayerController().Pawn;
		playerseenlocation = Player.Location;
		AlertCerBros();
		`log("ALERT cer bros called");
		// Check if the player is within firing range
		playerDistance = VSize( Pawn.location - Player.location );

		// Give up if player is farther than 512 units away
		if( playerDistance > 1024 )
		{
			`log("PLAYER IS TOO FAR AWAY, GOING BACK TO PATROLLING STATE");
			GotoState('Patrolling');
		}
		
		// If player is between 400 and 1000 chase timer is equal to 0 start shooting
		if( playerDistance < 350)
		{

			GotoState('Shoot');
		}
		if(!CanSee(BakanPawn(Player)))
		  {
			
		  	if (LookNavMeshPath())
		  		{
		  			MoveTo(playerseenlocation);

					if(CanSee(BakanPawn(Player)))
					{
						Sleep(0.0);
						goto 'Begin';
					}
			
		  		}

			else
				{
					GotoState('Patrolling');
				}
		  }

		// There is a direct path available to the player
		if( NavigationHandle.ActorReachable( Player ) )
		{
			/* 
				The player is reachable so move towards him
				Focus on the player
				Offset destination by 100
			*/
			`log("PLAYER IS REACHABLE");
			MoveToward( Player,Player, 100 );
			Focus = Player;
		}
		// No direct path to player, use navmesh to find
		else if( FindNavMeshPath() )
		{
			`log("FindNavMeshPath returned TRUE");
	
			// Set the ultimate destination to the players location
			NavigationHandle.SetFinalDestination(Player.Location);
			
			/* 
				TempDest is passed in by reference, is set to next location to move to
				Stay outside of Pawns Collision Radius
			*/
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				`log("MOVING TOWARD PLAYER");
				MoveTo( TempDest, Player );
			}

		}
		 if (BakanPawn(Player).Velocity.Z > 0 )
		 {
			
		 	while (BakanPawn(Player).bJustLanded != true )
		 	{
		 		`log("PLAYER IS JUMPING");
				Sleep(0.2);

			}
		 }
		else
		{
			// We can't get to the player so just go back to being Idle
			`log("UNABLE TO FIND PATH TO PLAYER VIA NAVIGATION MESH");
			GotoState('Patrolling');
		}
		Sleep(0.0);
		goto 'Begin';
}

state AlertChase
{

	

	// Gets the navmesh path to the player
	function bool FindNavMeshPath()
	{
		`log("ALERT CHASE");
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

	Begin:
		//`log("BEGIN ALERT CHASE");
		Player = GetALocalPlayerController().Pawn;

		// Check if the player is within firing range
		playerDistance = VSize( Pawn.location - Player.location );

		// Give up if player is farther than 2000 units away
		if( playerDistance > 1024)
		{

			GotoState('Patrolling');
		}
		// If player is between 400 and 1000 chase timer is equal to 0 start shooting
		if( playerDistance < 350)
		{

			GotoState('Shoot');
		}
		// There is a direct path available to the player
		if( NavigationHandle.ActorReachable( Player ) )
		{
			/* 
				The player is reachable so move towards him
				Focus on the player
				Offset destination by 100
			*/				
			`log("PLAYER IS ALERT REACHABLE");
			MoveToward( Player,Player, 100 );
		}
		// No direct path to player, use navmesh to find
		else if( FindNavMeshPath() )
		{
			`log("FindNavMeshPath ALERT returned TRUE");
	
			// Set the ultimate destination to the players location
			NavigationHandle.SetFinalDestination(Player.Location);
			
			/* 
				TempDest is passed in by reference, is set to next location to move to
				Stay outside of Pawns Collision Radius
			*/
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				`log("ALERT MOVING TOWARD PLAYER");
				MoveTo( TempDest, Player );
			}
		}
		if (BakanPawn(Player).Velocity.Z > 0 )
		 {
			
		 	while (BakanPawn(Player).bJustLanded != true )
		 	{
		 		`log("ALERT PLAYER IS JUMPING");
				Sleep(0.2);

			}
		 }
		else
		{
			// We can't get to the player so just go back to Patrolling
			`log("UNABLE TO FIND PATH TO PLAYER VIA NAVIGATION MESH");
			GotoState('Patrolling');
		}
		Sleep(0.0);
		goto 'Begin';
}
// Stop and fire at the player
state Shoot
{

	event EndState(Name PreviousStateName)
	{
		CereberusEye(Pawn).AlertComponent.DetachFromAny();
		CereberusEye(Pawn).Mesh.SetSkeletalMesh(NormalMesh);
		
	}	
	Begin:
		Player = GetALocalPlayerController().Pawn;
		Focus = Player;

		// Stop pawn from moving
		Pawn.ZeroMovementVariables();
		Sleep(1);
		if (CereberusEye(Pawn)!= none)
	{
			`log("OPEN FIRE");
			foreach WorldInfo.Game.AllActors(class'BakanPawn',BP)
			{
				BP.SetSpeed();

			}			
		
	}	
		playerDistance = VSize( Pawn.location - Player.location );

		// If the player is too far away
		if(playerDistance > 150)
		{
			GotoState('Chase');
		}
		Sleep(0.0);
		goto 'Begin';
}
state Investigate
{
	event EndState(Name PreviousStateName)
	{
		CereberusEye(Pawn).AlertComponent.DetachFromAny();

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
		CereberusEye(Pawn).Mesh.AttachComponentToSocket(CereberusEye(Pawn).QuestionComponent,CereberusEye(Pawn).AlertSocket); 
		NavigationDestination = playerseenlocation;
				


		 if (CereberusEye(Pawn)!=none)          
           {
				`log("Nav Dest set");
				if (NavigationHandle.PointReachable(NavigationDestination))
					{
						FlushPersistentDebugLines();
						MoveTo(NavigationDestination);
					}
				else if (FindNavMeshPath())
					{
						NavigationHandle.SetFinalDestination(NavigationDestination);					
						FlushPersistentDebugLines();
						//NavigationHandle.DrawPathCache(,TRUE);

						if(NavigationHandle.GetNextMoveLocation(NextLocationToGoal,Pawn.GetCollisionRadius()))
						{
							MoveTo(NextLocationToGoal);
						}
					}

           }

}

state Distracted
{

	ignores SeePlayer;
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
		 if (CereberusEye(Pawn)!=none)          
			{
				NavigationDestination = distraction;
				
			}		


		 if (CereberusEye(Pawn)!=none)          
           {
				NavigationDestination = CereberusEye(Pawn).PatDestination[index].Location;
				`log("Nav Dest set"); 
				if (NavigationHandle.PointReachable(NavigationDestination))
					{
						FlushPersistentDebugLines();
						MoveTo(NavigationDestination);
						SetTimer(7.0,false,'GotoPatrol');

					}
				else if (FindNavMeshPath())
					{
						NavigationHandle.SetFinalDestination(NavigationDestination);					
						FlushPersistentDebugLines();
						//NavigationHandle.DrawPathCache(,TRUE);

						if(NavigationHandle.GetNextMoveLocation(NextLocationToGoal,Pawn.GetCollisionRadius()))
						{
							MoveTo(NextLocationToGoal);
						}
					}

           }

}
simulated function GotoPatrol()
{
GotoState('Patrolling');

}
DefaultProperties
{
	index = 0;
	ind = 0;
	AlertMesh = SkeletalMesh'GuidePackageForJafar.Eyeclops_Eye'
	NormalMesh = SkeletalMesh'MyPackage.Eyeclops_Eye'

}
