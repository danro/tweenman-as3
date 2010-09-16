package com.tweenman.props
{
	import flash.filters.GlowFilter;
	
	public class GlowFilterProp extends BaseFilterProp
	{
		override public function init ():void
		{
			filterClass = GlowFilter;
			defaults = { alpha: 1, blurX: 0.0, blurY: 0.0, strength: 0, color: 0 };
			classes = { color: HexColorProp };
			initializers = { quality: "", inner: "", knockout: "" };
			super.init();
		}
	}
}