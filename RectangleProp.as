package com.tweenman {

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class RectangleProp extends MultiProp {

		override function init () {
			if (!(target is DisplayObject)) return tween.typeError(id, "DisplayObject");
			propList = ["x", "y", "width", "height"];
			if (!target.scrollRect) {
				var w:Number = Math.max(1, target.width * ( 1 / target.scaleX ));
				var h:Number = Math.max(1, target.height * ( 1 / target.scaleY ));			
				target.scrollRect = new Rectangle( 0, 0, w, h );
			}
			if (isNaN(value[2]) || value[2] < 1) value[2] = 1; // restrict size to 1px
			if (isNaN(value[3]) || value[3] < 1) value[3] = 1;
			current = target.scrollRect;
			super.init();
		}
	
		override function update ($position) {
			super.update($position);
			target.scrollRect = current;
		}
	}
}