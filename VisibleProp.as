package com.tweenman {
		
	public class VisibleProp extends BaseProp {

		override function init () {
			id = "alpha";		
			if (value is Boolean) value = Number(value);
			super.init();
		}

		override function update ($position) {
			super.update($position);
			if (target.alpha < 0.01) {
				if (target.visible) target.visible = false;
			} else if (target.alpha > 0.01) {
				if (!target.visible) target.visible = true;
			}
		}
	}
}