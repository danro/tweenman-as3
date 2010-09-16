package com.tweenman.props
{
	import flash.filters.DropShadowFilter;

	public class DropShadowProp extends BaseFilterProp
	{
		override public function init ():void
		{
			filterClass = DropShadowFilter;
			defaults = { distance: 0.0, angle: 45, color: 0, alpha: 1.0, blurX: 0.0, blurY: 0.0, strength: 0 };
			classes = { color: HexColorProp };
			initializers = { quality: "", inner: "", knockout: "", hideObject: "" };
			super.init();
		}
	}
}