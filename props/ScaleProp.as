package com.tweenman.props
{		
	public class ScaleProp extends BaseMultiProp
	{
		override public function init ():void
		{
			propList = ["scaleX", "scaleY"];
			current = target;
			super.init();
		}
	}
}