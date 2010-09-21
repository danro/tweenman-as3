package com.tweenman.props
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class RectangleProp extends BaseMultiProp
	{
		override public function init ():void
		{
			if (!(target is DisplayObject)) { tween.typeError(id, "DisplayObject"); return; }
			propList = ["x", "y", "width", "height"];
			if (!target.scrollRect)
			{
				var w:Number = Math.max(1, target.width * ( 1 / target.scaleX ));
				var h:Number = Math.max(1, target.height * ( 1 / target.scaleY ));			
				target.scrollRect = new Rectangle( 0, 0, w, h );
			}
			if (isNaN(value[2]) || value[2] < 1) value[2] = 1; // restrict size to 1px
			if (isNaN(value[3]) || value[3] < 1) value[3] = 1;
			current = target.scrollRect;
			super.init();
		}
	
		override public function update ($position:Number):void
		{
			super.update($position);
			target.scrollRect = current;
		}
	}
}