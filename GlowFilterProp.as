package com.tweenman {

	import flash.filters.GlowFilter;

	public class GlowFilterProp extends BaseFilterProp {
	
		override function init () {
			filterClass = GlowFilter;
			defaults = { alpha: 1, blurX: 0.0, blurY: 0.0, strength: 0, color: 0 };
			classes = { color: HexColorProp };
			initializers = { quality: "", inner: "", knockout: "" };
			super.init();
		}
	}
}