package com.tweenman.props
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import com.tweenman.utils.ColorMatrix;

	public class ColorFilterProp extends ArrayProp
	{
		private static var defaults:Object = { brightness: 0, contrast: 0, saturation: 1, hue: 0, colorize: 0x000000, 
										colorizeAmount: 0, blend: false };
		
		override public function init ():void
		{
			if (!(target is DisplayObject)) { tween.typeError(id, "DisplayObject"); return; }
			if (value == null) value = defaults;
			var cmf:ColorMatrixFilter;
			var filters:Array = target.filters;
			var filterCount:int = filters.length;
			var i:int;
			for (i = 0; i < filterCount; ++i)
			{
				if (filters[i] is ColorMatrixFilter)
				{
					cmf = filters[i];
				}
			}
			current = cmf == null ? ColorMatrix.IDENTITY.concat() : cmf.matrix.concat();
			var cm:ColorMatrix = new ColorMatrix;
			if (value.blend) cm.matrix = current.concat();
			var p:String;
			for (p in value)
			{
				if (value[p] == null) continue;
				switch (p)
				{
					case "brightness": cm.adjustBrightness(value[p]); break;
					case "contrast": cm.adjustContrast(value[p]); break;
					case "saturation": cm.adjustSaturation(value[p]); break;
					case "hue": cm.adjustHue(value[p]); break;
					case "colorize":
					case "colorizeAmount":
						if (value.colorize == null) value.colorize = defaults.colorize;
						if (value.colorizeAmount == null) value.colorizeAmount = defaults.colorizeAmount;
						cm.adjustColorize(value.colorize, value.colorizeAmount);
						break;
				}
			}
			value = cm.matrix;
			super.init();
		}
		
		override public function update ($position:Number):void
		{
			super.update($position);
			var filters:Array = target.filters;
			var filterCount:int = filters.length;
			var i:int;
			for (i = 0; i < filterCount; ++i)
			{
				if (filters[i] is ColorMatrixFilter)
				{
					ColorMatrixFilter(filters[i]).matrix = current.concat();
					target.filters = filters;
					return;
				}
			}
			if (filters == null) filters = [];
			filters.push(new ColorMatrixFilter(current.concat()));
			target.filters = filters;
		}
	}
}