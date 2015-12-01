/**
 * Urre 2012
 * Renders a cursor on screen, and sends mousecursor related events such as clicking and mouseover to other HUD kismet actions
 */
class HUDKismetSeqAct_RenderCursor extends HUDKismetSeqAct_RenderObject;

struct TextureCoords
{
	var() float U;
	var() float V;
	var() float UL;
	var() float VL;

	structdefaultproperties
	{
		U=0.f
		V=0.f
		UL=-1.f
		VL=-1.f
	}
};

struct TextureSize
{
	var bool ScaleActualSize;
	var() IntPoint Size;
	var() int ScaleByResolutionWidth<EditCondition=ScaleActualSize>;

	structdefaultproperties
	{
		ScaleByResolutionWidth=1280
	}
};

var int PositionX;
var int PositionY;

// Condition to overriding the blend mode
var bool OverrideBlendMode;

// Texture or Material to render
var(RenderCursor) Object TexMat<DisplayName=Texture/Material>;
// Size to render the cursor
var(RenderCursor) TextureSize CursorSize;
// Internal anchor point, range from 0.0-1.0, offsets the position
var(RenderCursor) Vector2D InternalPositionAnchor;
// Coordinates of the texture to render
var(RenderCursor) TextureCoords Coords;
// Amount of red color
var(RenderCursor, Color) int ColorR;
// Amount of green color
var(RenderCursor, Color) int ColorG;
// Amount of blue color
var(RenderCursor, Color) int ColorB;
// Amount of opacity
var(RenderCursor, Color) int ColorA;
// Blend mode for rendering the texture (Only for non rotated, non stretched tiles) (Always overrided for materials on iOS)
var(RenderCursor) EBlendMode BlendMode<EditCondition=OverrideBlendMode>;

var bool bAddedRenderHUDEvents;
var array<HUDKismetSeqEvent_RenderHUD> RenderHUDSequenceEvents;

function Render(Canvas Canvas)
{
	local MaterialInterface RenderMaterialInterface;
	local Material RenderMaterial;
	local WorldInfo worldInfo;
	local Texture2D RenderTexture;
	local int UL;
	local int VL;
	local SeqVar_Object SeqVar_Object;
	

	local PickMeUpInput UTGameExtHUDPlayerInput;

	local int i;
	local int j;
	local int k;
	local array<Sequence> RootSequences;
	local array<SequenceObject> RenderHUDs;
	local HUDKismetSeqEvent_RenderHUD RenderHUD;
	local HUDKismetSeqAct_RenderObject RenderObject;
	local HUDKismetSeqAct_RenderObject FoundRenderObject;

	WorldInfo = class'WorldInfo'.static.GetWorldInfo();

	if (bAddedRenderHUDEvents != true)
	if (WorldInfo != None)
	{
		RootSequences = WorldInfo.GetAllRootSequences();
		if (RootSequences.Length > 0)
		{
			for (i = 0; i < RootSequences.Length; ++i)
			{
				if (RootSequences[i] != None)
				{
					RootSequences[i].FindSeqObjectsByClass(class'HUDKismetSeqEvent_RenderHUD', true, RenderHUDs);
					if (RenderHUDs.Length > 0)
					{
						for (j = 0; j < RenderHUDs.Length; ++j)
						{
							RenderHUD = HUDKismetSeqEvent_RenderHUD(RenderHUDs[j]);
							if (RenderHUD != None)
							{
								if (RenderHUDSequenceEvents.Length > 0)
								{
									for (k = 0; k < RenderHUDSequenceEvents.Length; ++k)
									{
										if (RenderHUDSequenceEvents[k] == RenderHUD)
										{
											continue;
										}
										else
											RenderHUDSequenceEvents.AddItem(RenderHUD);
									}
								}
								else
									RenderHUDSequenceEvents.AddItem(RenderHUD);
							}
						}
					}
				}
			}
		}
		bAddedRenderHUDEvents = true;
	}

	if (PlayerOwner == None)
		return;


	UTGameExtHUDPlayerInput = PickMeUpInput(PlayerOwner.PlayerInput);
	
	if (UTGameExtHUDPlayerInput != None)
	{

		 if (UTGameExtHUDPlayerInput != None)
			UTGameExtHUDPlayerInput.MouseObject = Self;
		if (VariableLinks.Length > 0)
		{
			SeqVar_Object = SeqVar_Object(VariableLinks[0].LinkedVariables[0]);

			if (SeqVar_Object != None)
			{
				if (MaterialInterface(SeqVar_Object.GetObjectValue()) != None)
				{
					RenderMaterialInterface = MaterialInterface(SeqVar_Object.GetObjectValue());
				}
				else if (MaterialInstanceActor(SeqVar_Object.GetObjectValue()) != None)
				{
					RenderMaterialInterface = MaterialInstanceActor(SeqVar_Object.GetObjectValue()).MatInst;
				}
				else if (Texture2D(SeqVar_Object.GetObjectValue()) != None)
				{
					RenderTexture = Texture2D(SeqVar_Object.GetObjectValue());
				}
			}
		}
		if (RenderMaterialInterface == None && RenderTexture == None)
		{
			if (MaterialInterface(TexMat) != None)
			{
				RenderMaterialInterface = MaterialInterface(TexMat);
			}
			else if (MaterialInstanceActor(TexMat) != None)
			{
				RenderMaterialInterface = MaterialInstanceActor(TexMat).MatInst;
			}
			else if (Texture2D(TexMat) != None)
			{
				RenderTexture = Texture2D(TexMat);
			}
		}
		// Check if we're allowed to run on this platform
		if (WorldInfo != None && (WorldInfo.IsConsoleBuild(CONSOLE_Mobile) || WorldInfo.IsConsoleBuild(CONSOLE_IPhone)))
		{
			if (RenderMaterialInterface != None)
			{
				RenderMaterial = Material(RenderMaterialInterface);
				if (RenderMaterial != None)
				{
					OverrideBlendMode = true;
					BlendMode = RenderMaterial.BlendMode;
				}

				TexMat = RenderMaterialInterface.MobileBaseTexture;

				if (TexMat != None)
				{
					RenderTexture = Texture2D(TexMat);
					RenderMaterialInterface = None;
				}
			}		
		}
		if (Canvas != None)
		{
			// Calculate the size
			RenderSize.X = CursorSize.ScaleActualSize ? int(CursorSize.Size.X * (Canvas.ClipX/CursorSize.ScaleByResolutionWidth)) : CursorSize.Size.X;
			RenderSize.Y = CursorSize.ScaleActualSize ? int(CursorSize.Size.Y * (Canvas.ClipX/CursorSize.ScaleByResolutionWidth)) : CursorSize.Size.Y;
			// Calculate the position and clamp mouse values
		 if (UTGameExtHUDPlayerInput != None)
			{
				UTGameExtHUDPlayerInput.MousePosition.X = Clamp(UTGameExtHUDPlayerInput.MousePosition.X, 0, Canvas.ClipX);
				UTGameExtHUDPlayerInput.MousePosition.Y = Clamp(UTGameExtHUDPlayerInput.MousePosition.Y, 0, Canvas.ClipY);
				PositionX = UTGameExtHUDPlayerInput.MousePosition.X;
				PositionY = UTGameExtHUDPlayerInput.MousePosition.Y;
				PopulateLinkedVariableValues();
				RenderPosition.X = int(UTGameExtHUDPlayerInput.MousePosition.X - RenderSize.X*InternalPositionAnchor.X);
				RenderPosition.Y = int(UTGameExtHUDPlayerInput.MousePosition.Y - RenderSize.Y*InternalPositionAnchor.Y);
			}
			if (RenderMaterialInterface != None)
			{
				// Calculate the texture width
				UL = (Coords.UL == -1) ? 1.f : Coords.UL;
				// Calculate the texture height
				VL = (Coords.VL == -1) ? 1.f : Coords.VL;

				// Set the position to render
				Canvas.SetPos(RenderPosition.X, RenderPosition.Y);

				// Render the material normally
				Canvas.DrawMaterialTile(RenderMaterialInterface, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL);
			}
			else if (RenderTexture != None)
			{
				// Calculate the texture width
				UL = (Coords.UL == -1) ? RenderTexture.SizeX : int(Coords.UL);
				// Calculate the texture height
				VL = (Coords.VL == -1) ? RenderTexture.SizeY : int(Coords.VL);

				// Set the position to render
				Canvas.SetPos(RenderPosition.X, RenderPosition.Y);
				// Set the draw color
				Canvas.SetDrawColor(ColorR, ColorG, ColorB, ColorA);

				if (OverrideBlendMode)
				{					
					Canvas.DrawTile(RenderTexture, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL,, false, BlendMode);
				}
				else
				{
					Canvas.DrawTile(RenderTexture, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL,, false);
				}
			}
		}
		// handle mouse targets
		if (RenderHUDSequenceEvents.Length > 0)
		{
			for (i = 0; i < RenderHUDSequenceEvents.Length; ++i)
			{
				if (RenderHUDSequenceEvents[i].bEnabled)
				if (RenderHUDSequenceEvents[i].OutputLinks.Length > 0)
				{
					if (RenderHUDSequenceEvents[i].OutputLinks[0].Links.Length > 0)
					{
						for (j = 0; j < RenderHUDSequenceEvents[i].OutputLinks[0].Links.Length; ++j)
						{
							RenderObject = HUDKismetSeqAct_RenderObject(RenderHUDSequenceEvents[i].OutputLinks[0].Links[j].LinkedOp);
							while (RenderObject != None)
							{
								if (HUDKismetSeqAct_RenderTexMat(RenderObject) != None)
								{
									if (PositionX <= RenderObject.RenderPosition.X + RenderObject.RenderSize.X && PositionX >= RenderObject.RenderPosition.X)
									if (PositionY <= RenderObject.RenderPosition.Y + RenderObject.RenderSize.Y && PositionY >= RenderObject.RenderPosition.Y)
										FoundRenderObject = RenderObject;
								}
								if (RenderObject.OutputLinks.Length > 0)
								{
									if (RenderObject.OutputLinks[0].Links.Length > 0)
									{
										for (k = 0; k < RenderObject.OutputLinks[0].Links.Length; ++k)
										{
											RenderObject = HUDKismetSeqAct_RenderObject(RenderObject.OutputLinks[0].Links[k].LinkedOp);
											if (RenderObject != None)
												continue;
										}
									}
									else
										RenderObject = None;
								}
								else
									RenderObject = None;
							}
						}
					}
				}
			}
			// mouseover events
		 if (UTGameExtHUDPlayerInput != None)
			{
				if (!UTGameExtHUDPlayerInput.HoldingLeftMouse)
				if (!UTGameExtHUDPlayerInput.HoldingRightMouse)
				if (!UTGameExtHUDPlayerInput.HoldingMiddleMouse)
				if (UTGameExtHUDPlayerInput.HUDObject != FoundRenderObject)
				{
					if (UTGameExtHUDPlayerInput.HUDObject != None)
						UTGameExtHUDPlayerInput.HUDObject.MouseOut();
					UTGameExtHUDPlayerInput.HUDObject = FoundRenderObject;
					if (UTGameExtHUDPlayerInput.HUDObject != None)
						UTGameExtHUDPlayerInput.HUDObject.MouseOver();
				}
			}
		}
	}
	Super.Render(Canvas);
}

defaultproperties
{
	ColorR=255
	ColorG=255
	ColorB=255
	ColorA=255
	
	ObjName="Render Mouse Cursor"
	ObjCategory="ExtHUD"
	
	OutputLinks.RemoveIndex(10)
	OutputLinks.RemoveIndex(9)
	
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Texture/Material",PropertyName=TexMat,bHidden=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="PositionX",PropertyName=PositionX,bWriteable=true,bHidden=true)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="PositionY",PropertyName=PositionY,bWriteable=true,bHidden=true)
}