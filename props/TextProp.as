package com.tweenman.props
{		
	public class TextProp extends BaseProp
	{
		override public function init ():void
		{
		}
		
		override public function update ($position:Number):void
		{
			target[id] = this.value.substr(0, Math.round($position * this.value.length));
		}
	}
}