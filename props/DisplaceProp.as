package com.tweenman.props
{
	import flash.filters.DisplacementMapFilter;
	
	public class DisplaceProp extends BaseFilterProp
	{
		override public function init ():void
		{
			filterClass = DisplacementMapFilter;
			defaults = { scaleX: 0.0, scaleY: 0.0, color: 0, alpha: 0.0 };
			classes = { color: HexColorProp };
			initializers = { mapBitmap: "", mapPoint: "", componentX: "", componentY: "", mode: "" };
			super.init();
		}
	}
}