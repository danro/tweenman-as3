package com.tweenman.props
{		
	public class TextProp extends BaseProp
	{
		override public function init ():void
		{
			start = target[id];
		}
		
		override public function update ($position:Number):void
		{
			target[id] = value.substr(0, Math.round($position * value.length));
		}
	}
}