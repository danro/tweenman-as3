package com.tweenman {

	import flash.filters.BlurFilter;

	public class BlurFilterProp extends BaseFilterProp {
	
		override function init () {
			filterClass = BlurFilter;
			defaults = { blurX: 0.0, blurY: 0.0 };
			initializers = { quality: "" };
			super.init();
		}
	}
}