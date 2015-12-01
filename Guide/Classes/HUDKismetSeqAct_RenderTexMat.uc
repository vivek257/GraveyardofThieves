/**
 * Urre 2012
 * Combined render texture and render material node
 */
class HUDKismetSeqAct_RenderTexMat extends HUDKismetSeqAct_RenderObject;

struct TextureRotation
{
	// Amount to rotate the texture in Unreal units (65536 == 360 degrees)
	var() int Rotation;
	// Relative point to perform the rotation (0.5f is at the center)
	var() Vector2D Anchor;

	structdefaultproperties
	{
		Anchor=(X=0.5f,Y=0.5f)
	}
};

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

struct TextureStretched
{
	var() bool StretchHorizontally;
	var() bool StretchVertically;
	var() float ScalingFactor;

	structdefaultproperties
	{
		ScalingFactor=1.f
	}
};

var const enum eWidthAnchor
{
	Left,
	Center,
	Right
} WidthAnchor;

var const enum eHeightAnchor
{
	Top,
	Middle,
	Bottom
} HeightAnchor;

struct ScreenAnchor
{
	var() eWidthAnchor WidthAnchor;
	var() eHeightAnchor HeightAnchor;
	
	structdefaultproperties
	{
		HeightAnchor=Top
		WidthAnchor=Left
	}
};

// Condition for scaling non-screen-relative positions and sizes
var bool bScaleAbsolutesByResolution;
// Condition to using the stretched method
var bool UsingStretched;
// Condition to overriding the blend mode
var bool OverrideBlendMode;
// Texture or Material to render
var(RenderTexMat) Object TexMat<DisplayName=Texture/Material>;
// Size on X axis
var(RenderTexMat, Size) float SizeX;
// Size on Y axis
var(RenderTexMat, Size) float SizeY;
// Condition for using relative position coordinates on X axis
var(RenderTexMat, Size) bool UsingScreenRelativeSizeX;
// Condition for using relative position coordinates on Y axis
var(RenderTexMat, Size) bool UsingScreenRelativeSizeY;
// The position on X axis
var(RenderTexMat, Position) float PositionX;
// The position on Y axis
var(RenderTexMat, Position) float PositionY;
// Condition for using relative position coordinates on X axis
var(RenderTexMat, Position) bool UsingScreenRelativePositionX;
// Condition for using relative position coordinates on Y axis
var(RenderTexMat, Position) bool UsingScreenRelativePositionY;
// Base resolution to scale size and position by, recommended to set to resolution you work in
var(RenderTexMat) int ScaleByResolutionWidth<EditCondition=bScaleAbsolutesByResolution>;
// Internal anchor point, range from 0.0-1.0, offsets the position
var(RenderTexMat) Vector2D InternalPositionAnchor;
// Where on the screen to base our position
var(RenderTexMat) ScreenAnchor ScreenAlignment;
// Rotation of the texture to render
var(RenderTexMat) TextureRotation Rotation;
// Coordinates of the texture to render
var(RenderTexMat) TextureCoords Coords;
// Amount of red color
var(RenderTexMat, Color) int ColorR;
// Amount of green color
var(RenderTexMat, Color) int ColorG;
// Amount of blue color
var(RenderTexMat, Color) int ColorB;
// Amount of opacity
var(RenderTexMat, Color) int ColorA;
// Stretched properties when rendering the texture
var(RenderTexMat) TextureStretched Stretched<EditCondition=UsingStretched>;
// If the texture is partially outside the rendering bounds, should we clip it? (Only for non rotated, non stretched textures)
var(RenderTexMat) bool ClipTile;
// Blend mode for rendering the texture (Only for non rotated, non stretched tiles) (Always overrided for materials on iOS)
var(RenderTexMat) EBlendMode BlendMode<EditCondition=OverrideBlendMode>;

var int PixelPosOutX;
var int PixelPosOutY;
var int PixelSizeOutX;
var int PixelSizeOutY;
// Whether to write the calculated position and size to pixelinfo variables (potentially performance heavy)
var(RenderTexMat) bool WritePixelInfo;

function Render(Canvas Canvas)
{
	local MaterialInterface RenderMaterialInterface;
	local Material RenderMaterial;
	local WorldInfo worldInfo;

	local Texture2D RenderTexture;
	local int UL;
	local int VL;
	local Rotator R;
	local SeqVar_Object SeqVar_Object;
	local SeqVar_Int SeqVar_Int;

	WorldInfo = class'WorldInfo'.static.GetWorldInfo();
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
	if (Canvas != None && (RenderTexture != None || RenderMaterialInterface != None))
	{
		// Calculate the size
		if (UsingScreenRelativeSizeX)
			RenderSize.X = int(Canvas.ClipX * SizeX);
		else
			RenderSize.X = bScaleAbsolutesByResolution ? int(SizeX * (Canvas.ClipX/ScaleByResolutionWidth)) : int(SizeX);
		if (UsingScreenRelativeSizeY)
			RenderSize.Y = int(Canvas.ClipY * SizeY);
		else
			RenderSize.Y = bScaleAbsolutesByResolution ? int(SizeY * (Canvas.ClipX/ScaleByResolutionWidth)) : int(SizeY);
		// Calculate the position
		if (ScreenAlignment.WidthAnchor == Left)
		{
			if (UsingScreenRelativePositionX)
				RenderPosition.X = int(Canvas.ClipX * PositionX - RenderSize.X*InternalPositionAnchor.X);
			else
				RenderPosition.X = bScaleAbsolutesByResolution ? int(PositionX * (Canvas.ClipX/ScaleByResolutionWidth) - RenderSize.X*InternalPositionAnchor.X) : int(PositionX - RenderSize.X*InternalPositionAnchor.X);
		}
		else if (ScreenAlignment.WidthAnchor == Right)
		{
			if (UsingScreenRelativePositionX)
				RenderPosition.X = int(Canvas.ClipX * (1-PositionX) - RenderSize.X*InternalPositionAnchor.X);
			else
				RenderPosition.X = bScaleAbsolutesByResolution ? int(Canvas.ClipX - PositionX * (Canvas.ClipX/ScaleByResolutionWidth) - RenderSize.X*InternalPositionAnchor.X) : int(Canvas.ClipX - PositionX - RenderSize.X*InternalPositionAnchor.X);
		}
		else
		{
			if (UsingScreenRelativePositionX)
				RenderPosition.X = int(Canvas.ClipX * 0.5 + Canvas.ClipX * PositionX - RenderSize.X*InternalPositionAnchor.X);
			else
				RenderPosition.X = bScaleAbsolutesByResolution ? int(Canvas.ClipX * 0.5 + PositionX * (Canvas.ClipX/ScaleByResolutionWidth) - RenderSize.X*InternalPositionAnchor.X) : int(Canvas.ClipX * 0.5 + PositionX - RenderSize.X*InternalPositionAnchor.X);
		}
		if (ScreenAlignment.HeightAnchor == Top)
		{
			if (UsingScreenRelativePositionY)
				RenderPosition.Y = int(Canvas.ClipY * PositionY - RenderSize.Y*InternalPositionAnchor.Y);
			else
				RenderPosition.Y = bScaleAbsolutesByResolution ? int(PositionY * (Canvas.ClipX/ScaleByResolutionWidth) - RenderSize.Y*InternalPositionAnchor.Y) : int(PositionY - RenderSize.Y*InternalPositionAnchor.Y);
		}
		else if (ScreenAlignment.HeightAnchor == Bottom)
		{
			if (UsingScreenRelativePositionY)
				RenderPosition.Y = int(Canvas.ClipY * (1-PositionY) - RenderSize.Y*InternalPositionAnchor.Y);
			else
				RenderPosition.Y = bScaleAbsolutesByResolution ? int(Canvas.ClipY - PositionY * (Canvas.ClipX/ScaleByResolutionWidth) - RenderSize.Y*InternalPositionAnchor.Y) : int(Canvas.ClipY - PositionY - RenderSize.Y*InternalPositionAnchor.Y);
		}
		else
		{
			if (UsingScreenRelativePositionY)
				RenderPosition.Y = int(Canvas.ClipY * 0.5 + Canvas.ClipY * PositionY - RenderSize.Y*InternalPositionAnchor.Y);
			else
				RenderPosition.Y = bScaleAbsolutesByResolution ? int(Canvas.ClipY * 0.5 + PositionY * (Canvas.ClipX/ScaleByResolutionWidth) - RenderSize.Y*InternalPositionAnchor.Y) : int(Canvas.ClipY * 0.5 + PositionY - RenderSize.Y*InternalPositionAnchor.Y);
		}
		if (WritePixelInfo == true)
		{
			PixelPosOutX=RenderPosition.X;
			PixelPosOutY=RenderPosition.Y;
			PixelSizeOutX=RenderSize.X;
			PixelSizeOutY=RenderSize.Y;
			foreach LinkedVariables( class'SeqVar_Int', SeqVar_Int, "Pixel Position Out X" )
				SeqVar_Int.IntValue = PixelPosOutX;
			foreach LinkedVariables( class'SeqVar_Int', SeqVar_Int, "Pixel Position Out Y" )
				SeqVar_Int.IntValue = PixelPosOutY;
			foreach LinkedVariables( class'SeqVar_Int', SeqVar_Int, "Pixel Size Out X" )
				SeqVar_Int.IntValue = PixelSizeOutX;
			foreach LinkedVariables( class'SeqVar_Int', SeqVar_Int, "Pixel Size Out Y" )
				SeqVar_Int.IntValue = PixelSizeOutY;
		}
		// if we has material
		if (RenderMaterialInterface != None)
		{
			// Calculate the texture width
			UL = (Coords.UL == -1) ? 1.f : Coords.UL;
			// Calculate the texture height
			VL = (Coords.VL == -1) ? 1.f : Coords.VL;

			// Set the position to render
			Canvas.SetPos(RenderPosition.X, RenderPosition.Y);

			if (Rotation.Rotation == 0)
			{
				// Render the material normally
				Canvas.DrawMaterialTile(RenderMaterialInterface, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL);
			}
			else
			{
				// Render the material rotated
				R.Pitch = 0;
				R.Yaw = Rotation.Rotation;
				R.Roll = 0;
				Canvas.DrawRotatedMaterialTile(RenderMaterialInterface, R, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL, Rotation.Anchor.X, Rotation.Anchor.Y);
			}
		}
		// if no material, try texture
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
			if (UsingStretched)
			{
				// Render the texture stretched
				Canvas.DrawTileStretched(RenderTexture, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL,, Stretched.StretchHorizontally, Stretched.StretchVertically, Stretched.ScalingFactor);
			}
			else
			{
				if (Rotation.Rotation == 0)
				{
					// Render the texture normally
					if (OverrideBlendMode)
					{					
						Canvas.DrawTile(RenderTexture, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL,, ClipTile, BlendMode);
					}
					else
					{
						Canvas.DrawTile(RenderTexture, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL,, ClipTile);
					}
				}
				else
				{
					// Render the texture rotated
					R.Pitch = 0;
					R.Yaw = Rotation.Rotation;
					R.Roll = 0;
					Canvas.DrawRotatedTile(RenderTexture, R, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL, Rotation.Anchor.X, Rotation.Anchor.Y);
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
	
	ObjName="Render Texture or Material"
	ObjCategory="ExtHUD"

	bScaleAbsolutesByResolution=true
	ScaleByResolutionWidth=1280
	
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Texture/Material",PropertyName=TexMat,bHidden=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="SizeX",PropertyName=SizeX,bHidden=true)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="SizeY",PropertyName=SizeY,bHidden=true)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="PositionX",PropertyName=PositionX,bHidden=true)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Float',LinkDesc="PositionY",PropertyName=PositionY,bHidden=true)
	VariableLinks(5)=(ExpectedType=class'SeqVar_Int',LinkDesc="ColorR",PropertyName=ColorR,bHidden=true)
	VariableLinks(6)=(ExpectedType=class'SeqVar_Int',LinkDesc="ColorG",PropertyName=ColorG,bHidden=true)
	VariableLinks(7)=(ExpectedType=class'SeqVar_Int',LinkDesc="ColorB",PropertyName=ColorB,bHidden=true)
	VariableLinks(8)=(ExpectedType=class'SeqVar_Int',LinkDesc="ColorA",PropertyName=ColorA,bHidden=true)
	VariableLinks(9)=(ExpectedType=class'SeqVar_Int',LinkDesc="Pixel Position Out X",PropertyName=PixelPosOutX,bWriteable=true,bHidden=true)
	VariableLinks(10)=(ExpectedType=class'SeqVar_Int',LinkDesc="Pixel Position Out Y",PropertyName=PixelPosOutY,bWriteable=true,bHidden=true)
	VariableLinks(11)=(ExpectedType=class'SeqVar_Int',LinkDesc="Pixel Size Out X",PropertyName=PixelSizeOutX,bWriteable=true,bHidden=true)
	VariableLinks(12)=(ExpectedType=class'SeqVar_Int',LinkDesc="Pixel Size Out Y",PropertyName=PixelSizeOutY,bWriteable=true,bHidden=true)
}