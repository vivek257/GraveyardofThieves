/**
 * Urre 2012
 * The abstract class for all the Kismet HUD nodes, contains shared information
 */
class HUDKismetSeqAct_RenderObject extends SequenceAction
	abstract;

// PlayerOwner from HUD
var PlayerController PlayerOwner; // always the actual owner
var IntPoint RenderSize;
var IntPoint RenderPosition;

event Activated()
{
	ActivateOutPutLink(0);
}

function MouseLeftPressed()
{
	ActivateOutPutLink(1);
}
function MouseLeftReleased()
{
	ActivateOutPutLink(2);
}
function MouseRightPressed()
{
	ActivateOutPutLink(3);
}
function MouseRightReleased()
{
	ActivateOutPutLink(4);
}
function MouseMiddlePressed()
{
	ActivateOutPutLink(5);
}
function MouseMiddleReleased()
{
	ActivateOutPutLink(6);
}
function MouseScrollUp()
{
	ActivateOutPutLink(7);
}
function MouseScrollDown()
{
	ActivateOutPutLink(8);
}
function MouseOver()
{
	ActivateOutPutLink(9);
}
function MouseOut()
{
	ActivateOutPutLink(10);
}

function Render(Canvas Canvas)
{
	local int i;
	local HUDKismetSeqAct_RenderObject RenderObject;

	// Propagate the rendering call to all other child links
	if (OutputLinks.Length > 0)
	{
		if (OutputLinks[0].Links.Length > 0)
		{
			for (i = 0; i < OutputLinks[0].Links.Length; ++i)
			{
				RenderObject = HUDKismetSeqAct_RenderObject(OutputLinks[0].Links[i].LinkedOp);

				if (RenderObject != None)
				{
					RenderObject.PlayerOwner = PlayerOwner;
					RenderObject.Render(Canvas);
				}
			}
		}
	}
}

defaultproperties
{
	bAutoActivateOutputLinks=false

	OutputLinks.Empty
	OutputLinks(0)=(LinkDesc="Next HUD object")
	OutputLinks(1)=(LinkDesc="Mouse Left Down")
	OutputLinks(2)=(LinkDesc="Mouse Left Up")
	OutputLinks(3)=(LinkDesc="Mouse Right Down",bHidden=true)
	OutputLinks(4)=(LinkDesc="Mouse Right Up",bHidden=true)
	OutputLinks(5)=(LinkDesc="Mouse Middle Down",bHidden=true)
	OutputLinks(6)=(LinkDesc="Mouse Middle Up",bHidden=true)
	OutputLinks(7)=(LinkDesc="Mouse Scroll Up",bHidden=true)
	OutputLinks(8)=(LinkDesc="Mouse Scroll Down",bHidden=true)
	OutputLinks(9)=(LinkDesc="Mouse Over",bHidden=true)
	OutputLinks(10)=(LinkDesc="Mouse Out",bHidden=true)

	VariableLinks.Empty
}