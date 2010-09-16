package com.tweenman.props
{	
	public class VisibleProp extends BaseProp
	{
		override public function init ():void
		{
			id = "alpha";		
			if (value is Boolean) value = Number(value);
			super.init();
		}
		
		override public function update ($position:Number):void
		{
			super.update($position);
			target.visible = target.alpha > 0.01;
		}
	}
}