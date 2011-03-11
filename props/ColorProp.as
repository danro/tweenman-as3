package com.tweenman.props
{	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import com.tweenman.utils.ColorUtil;

	public class ColorProp extends BaseProp
	{
		public var startColor:ColorTransform;
		
		override public function init ():void
		{
			if (!(target is DisplayObject)) { tween.typeError(id, "DisplayObject"); return; }
			var defaults:Object = { redMultiplier: 1.0, greenMultiplier: 1.0, blueMultiplier: 1.0, alphaMultiplier: 1.0, 
						 redOffset: 0, greenOffset: 0, blueOffset: 0, alphaOffset: 0, brightness: 0,
						 tintColor: 0x000000, tintMultiplier: 0, burn: 0 };
			this.startColor = target.transform.colorTransform || new ColorTransform;
			this.value = ColorUtil.initColorTransform(value || defaults);
		}

		override public function update ($position:Number):void
		{
			target.transform.colorTransform = ColorUtil.interpolateTransform(this.startColor, ColorTransform(value), $position);
		}
		
		override public function dispose ():void
		{
			super.dispose();
			this.startColor = undefined;
		}
	}
}