package com.tweenman.props
{	
	import flash.display.DisplayObject;
	import fl.motion.Color;

	public class ColorProp extends BaseProp
	{
		override public function init ():void
		{
			if (!(target is DisplayObject)) { tween.typeError(id, "DisplayObject"); return; }
			var defaults:Object = { redMultiplier: 1.0, greenMultiplier: 1.0, blueMultiplier: 1.0, alphaMultiplier: 1.0, 
						 redOffset: 0, greenOffset: 0, blueOffset: 0, alphaOffset: 0, brightness: 0,
						 tintColor: 0x000000, tintMultiplier: 0, burn: 0 };
			if (value != null)
			{
				if (value.burn != null) value.redOffset = value.greenOffset = value.blueOffset = 255 * value.burn;
				if (value.tintColor != null && value.tintMultiplier == null) value.tintMultiplier = 1;
			}
			if (value == null) value = defaults;
			var p:String;
			var c:Color = new Color();
			for ( p in value )
			{
				if (p == "burn") continue;
				c[p] = value[p];
			}
			value = c;
		}

		override public function update ($position:Number):void
		{
			target.transform.colorTransform = Color.interpolateTransform(target.transform.colorTransform, value as Color, $position);
		}
	}
}