package com.tweenman.props
{
	import flash.filters.BlurFilter;

	public class BlurFilterProp extends BaseFilterProp
	{
		override public function init ():void
		{
			filterClass = BlurFilter;
			defaults = { blurX: 0.0, blurY: 0.0 };
			initializers = { quality: "" };
			super.init();
		}
	}
}