package com.tweenman.props
{		
	import com.tweenman.utils.ColorUtil;

	public class HexColorProp extends BaseProp
	{
		override public function init ():void
		{
			this.start = uint(target[id]);
		}
		
		override public function update ($position:Number):void
		{
			target[id] = ColorUtil.interpolateColor(uint(this.start), uint(this.value), $position);
		}
	}
}