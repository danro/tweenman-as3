package com.tweenman {

	import flash.filters.ConvolutionFilter;

	public class ConvolutionProp extends BaseFilterProp {
	
		override function init () {
			filterClass = ConvolutionFilter;
			defaults = { divisor: 1.0, bias: 0.0, color: 0, alpha: 0.0 };
			classes = { color: HexColorProp };
			initializers = { matrix: "", matrixX: "", matrixY: "", preserveAlpha: "", clamp: "" };
			super.init();
		}
	}
}