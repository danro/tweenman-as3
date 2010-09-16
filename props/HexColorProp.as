package com.tweenman.props
{		
	import fl.motion.Color;

	public class HexColorProp extends BaseProp
	{
		override public function init ():void
		{
			start = target[id];
		}
		
		override public function update ($position:Number):void
		{
			target[id] = Color.interpolateColor(start, value, $position);
		}
	}
}