package com.tweenman.props
{		
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	public class FrameProp extends BaseProp
	{
		override public function init ():void
		{
			if (!(target is MovieClip)) { tween.typeError(id, "MovieClip"); return; }
			start = int(target.currentFrame);
			if (typeof(value) == "number")
			{
				change = value - start;
			}
			else
			{
				var labelFound:Boolean = false;
				for each (var f:FrameLabel in target.currentLabels)
				{
					if (f.name == value)
					{
						value = int(f.frame);
						change = value - start;
						labelFound = true;
						break;
					}
				}
				if (!labelFound) change = Number(value);
			}
		}

		override public function update ($position:Number):void
		{
			var newFrame:int = int(start + ($position * change));
			target.gotoAndStop(newFrame > 0 ? newFrame : 1);
		}
	}
}