/**
 * Urre 2012
 * A text box inside which text wraps. Also supports manual linebreaks, but doesn't support aligning the text inside of the box
 */
class HUDKismetSeqAct_RenderTextBox extends HUDKismetSeqAct_RenderObject;

// Condition for scaling non-screen-relative positions and sizes
var bool bScaleAbsolutesByResolution;
// Condition for using localized text
var bool UsingLocalizedText;
// The position on X axis
var(RenderText, Position) float PositionX;
// The position on Y axis
var(RenderText, Position) float PositionY;
// Condition for using relative position coordinates on X axis
var(RenderText, Position) bool UsingScreenRelativePositionX;
// Condition for using relative position coordinates on Y axis
var(RenderText, Position) bool UsingScreenRelativePositionY;
// Clip area size on X axis
var(RenderText, ClipArea) float ClipX;
// Clip area size on Y axis (Note: text will go outside this height, but won't be visible if the clip area isn't on screen. Important for text scrolling across screen)
var(RenderText, ClipArea) float ClipY;
// Condition for using relative size coordinates on X axis
var(RenderText, ClipArea) bool UsingScreenRelativeClipX;
// Condition for using relative size coordinates on Y axis
var(RenderText, ClipArea) bool UsingScreenRelativeClipY;
// Internal anchor point, range from 0.0-1.0, offsets the position
var(RenderText, ClipArea) Vector2D ClipBasedPositionAnchor;

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

// Where on the screen to base our position
var(RenderText, ClipArea) ScreenAnchor ClipScreenAlignment;
// Base resolution to scale size and position of clip area by, recommended to set to resolution you work in
var(RenderText) int ScaleByResolutionWidth<EditCondition=bScaleAbsolutesByResolution>;
// Raw text to render
var(RenderText) String Text;
// Text width scale
var(RenderText) float TextScaleX;
// Text height scale
var(RenderText) float TextScaleY;
// Localization path to get the text from to render
var(RenderText) String LocalizedText<EditCondition=UsingLocalizedText>;
// Amount of red color
var(RenderText, Color) int ColorR;
// Amount of green color
var(RenderText, Color) int ColorG;
// Amount of blue color
var(RenderText, Color) int ColorB;
// Amount of opacity
var(RenderText, Color) int ColorA;
// Font to render the text
var(RenderText) Font Font;
// Character used for line breaks
var(RenderText) String NewLineChar;

var int PixelPosOutX;
var int PixelPosOutY;
var int PixelSizeOutX;
var int PixelSizeOutY;
// Whether to write the calculated position and size to pixelinfo variables (potentially performance heavy)
var(RenderTexMat) bool WritePixelInfo;

function Render(Canvas Canvas)
{
	//local IntPoint RenderPosition;
	local int i;
	local Vector2D ClipArea;
	local float TextWidth, TextHeight;
	local String RenderText;
	local array<String> BrokenStrings;
	local Vector2D ViewportSize;
	local SeqVar_Int SeqVar_Int;

	if (Canvas != None && Font != None)
	{
		// Get the render text
		if (UsingLocalizedText)
			RenderText = ParseLocalizedPropertyPath(LocalizedText);
		else
			RenderText = Text;

		if (RenderText != "")
		{
			LocalPlayer(PlayerOwner.Player).ViewportClient.GetViewportSize(ViewportSize);
			// calculate clip
			if (UsingScreenRelativeClipX)
				ClipArea.X = ClipX * ViewportSize.X;
			else
				ClipArea.X = bScaleAbsolutesByResolution ? ClipX * (ViewportSize.X/ScaleByResolutionWidth) : ClipX;
			if (UsingScreenRelativeClipY)
				ClipArea.Y = ClipY * ViewportSize.Y;
			else
				ClipArea.Y = bScaleAbsolutesByResolution ? ClipY * (ViewportSize.X/ScaleByResolutionWidth) : ClipY;
			// Calculate the position
			if (ClipScreenAlignment.WidthAnchor == Left)
			{
				if (UsingScreenRelativePositionX)
					RenderPosition.X = int(ViewportSize.X * PositionX - ClipArea.X*ClipBasedPositionAnchor.X);
				else
					RenderPosition.X = bScaleAbsolutesByResolution ? int(PositionX * (ViewportSize.X/ScaleByResolutionWidth) - ClipArea.X*ClipBasedPositionAnchor.X) : int(PositionX - ClipArea.X*ClipBasedPositionAnchor.X);
			}
			else if (ClipScreenAlignment.WidthAnchor == Right)
			{
				if (UsingScreenRelativePositionX)
					RenderPosition.X = int(ViewportSize.X * (1-PositionX) - ClipArea.X*ClipBasedPositionAnchor.X);
				else
					RenderPosition.X = bScaleAbsolutesByResolution ? int(ViewportSize.X - PositionX * (ViewportSize.X/ScaleByResolutionWidth) - ClipArea.X*ClipBasedPositionAnchor.X) : int(ViewportSize.X - PositionX - ClipArea.X*ClipBasedPositionAnchor.X);
			}
			else
			{
				if (UsingScreenRelativePositionX)
					RenderPosition.X = int(ViewportSize.X * 0.5 + ViewportSize.X * PositionX - ClipArea.X*ClipBasedPositionAnchor.X);
				else
					RenderPosition.X = bScaleAbsolutesByResolution ? int(ViewportSize.X * 0.5 + PositionX * (ViewportSize.X/ScaleByResolutionWidth) - ClipArea.X*ClipBasedPositionAnchor.X) : int(ViewportSize.X * 0.5 + PositionX - ClipArea.X*ClipBasedPositionAnchor.X);
			}
			if (ClipScreenAlignment.HeightAnchor == Top)
			{
				if (UsingScreenRelativePositionY)
					RenderPosition.Y = int(ViewportSize.Y * PositionY - ClipArea.Y*ClipBasedPositionAnchor.Y);
				else
					RenderPosition.Y = bScaleAbsolutesByResolution ? int(PositionY * (ViewportSize.X/ScaleByResolutionWidth) - ClipArea.Y*ClipBasedPositionAnchor.Y) : int(PositionY - ClipArea.Y*ClipBasedPositionAnchor.Y);
			}
			else if (ClipScreenAlignment.HeightAnchor == Bottom)
			{
				if (UsingScreenRelativePositionY)
					RenderPosition.Y = int(ViewportSize.Y * (1-PositionY) - ClipArea.Y*ClipBasedPositionAnchor.Y);
				else
					RenderPosition.Y = bScaleAbsolutesByResolution ? int(ViewportSize.Y - PositionY * (ViewportSize.X/ScaleByResolutionWidth) - ClipArea.Y*ClipBasedPositionAnchor.Y) : int(ViewportSize.Y - PositionY - ClipArea.Y*ClipBasedPositionAnchor.Y);
			}
			else
			{
				if (UsingScreenRelativePositionY)
					RenderPosition.Y = int(ViewportSize.Y * 0.5 + ViewportSize.Y * PositionY - ClipArea.Y*ClipBasedPositionAnchor.Y);
				else
					RenderPosition.Y = bScaleAbsolutesByResolution ? int(ViewportSize.Y * 0.5 + PositionY * (ViewportSize.X/ScaleByResolutionWidth) - ClipArea.Y*ClipBasedPositionAnchor.Y) : int(ViewportSize.Y * 0.5 + PositionY - ClipArea.Y*ClipBasedPositionAnchor.Y);
			}
			if (WritePixelInfo == true)
			{
				PixelPosOutX=RenderPosition.X;
				PixelPosOutY=RenderPosition.Y;
				PixelSizeOutX=int(ClipArea.X);
				PixelSizeOutY=int(ClipArea.Y);
				foreach LinkedVariables( class'SeqVar_Int', SeqVar_Int, "Pixel Position Out X" )
					SeqVar_Int.IntValue = PixelPosOutX;
				foreach LinkedVariables( class'SeqVar_Int', SeqVar_Int, "Pixel Position Out Y" )
					SeqVar_Int.IntValue = PixelPosOutY;
				foreach LinkedVariables( class'SeqVar_Int', SeqVar_Int, "Pixel Clip Size Out X" )
					SeqVar_Int.IntValue = PixelSizeOutX;
				foreach LinkedVariables( class'SeqVar_Int', SeqVar_Int, "Pixel Clip Size Out Y" )
					SeqVar_Int.IntValue = PixelSizeOutY;
			}
			// Set the font
			Canvas.Font = Font;
			ParseStringIntoArray(RenderText, BrokenStrings, NewLineChar, false);
			for (i = 0; i < BrokenStrings.Length; ++i)
			{
				// Set the canvas position
				Canvas.SetPos(RenderPosition.X, RenderPosition.Y);
				Canvas.SetClip(RenderPosition.X+ClipArea.X, RenderPosition.Y+ClipArea.Y);
				// Calculate the size of the text
				Canvas.StrLen(BrokenStrings[i], TextWidth, TextHeight);
				// Set the text color
				Canvas.SetDrawColor(ColorR, ColorG, ColorB, ColorA);
				// Render the text
				Canvas.DrawText(BrokenStrings[i],true,TextScaleX,TextScaleY);
				RenderPosition.Y += TextHeight*TextScaleY;
			}
			Canvas.SetClip(ViewportSize.X, ViewportSize.Y);
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

	ObjName="Render Text Box"
	ObjCategory="ExtHUD"

	bScaleAbsolutesByResolution=true
	ScaleByResolutionWidth=1280
	
	UsingScreenRelativeClipX=true
	UsingScreenRelativeClipY=true
	ClipX=1.0
	ClipY=1.0
	
	TextScaleX=1.0
	TextScaleY=1.0
	
	NewLineChar="¤"
	
	OutputLinks.Empty
	OutputLinks(0)=(LinkDesc="Next HUD object")
	
	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Text",MaxVars=1,PropertyName=Text)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Localized Text",MaxVars=1,PropertyName=LocalizedText,bHidden=true)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Font",PropertyName=Font,bHidden=true)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="SizeX",PropertyName=ClipX,bHidden=true)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Float',LinkDesc="SizeY",PropertyName=ClipY,bHidden=true)
	VariableLinks(5)=(ExpectedType=class'SeqVar_Float',LinkDesc="PositionX",PropertyName=PositionX,bHidden=true)
	VariableLinks(6)=(ExpectedType=class'SeqVar_Float',LinkDesc="PositionY",PropertyName=PositionY,bHidden=true)
	VariableLinks(7)=(ExpectedType=class'SeqVar_Int',LinkDesc="ColorR",PropertyName=ColorR,bHidden=true)
	VariableLinks(8)=(ExpectedType=class'SeqVar_Int',LinkDesc="ColorG",PropertyName=ColorG,bHidden=true)
	VariableLinks(9)=(ExpectedType=class'SeqVar_Int',LinkDesc="ColorB",PropertyName=ColorB,bHidden=true)
	VariableLinks(10)=(ExpectedType=class'SeqVar_Int',LinkDesc="ColorA",PropertyName=ColorA,bHidden=true)
	VariableLinks(11)=(ExpectedType=class'SeqVar_Int',LinkDesc="Pixel ClipPos Out X",PropertyName=PixelPosOutX,bWriteable=true,bHidden=true)
	VariableLinks(12)=(ExpectedType=class'SeqVar_Int',LinkDesc="Pixel ClipPos Out Y",PropertyName=PixelPosOutY,bWriteable=true,bHidden=true)
	VariableLinks(13)=(ExpectedType=class'SeqVar_Int',LinkDesc="Pixel ClipSize Out X",PropertyName=PixelSizeOutX,bWriteable=true,bHidden=true)
	VariableLinks(14)=(ExpectedType=class'SeqVar_Int',LinkDesc="Pixel ClipSize Out Y",PropertyName=PixelSizeOutY,bWriteable=true,bHidden=true)
}