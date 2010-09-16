package com.tweenman {
		
	import fl.motion.Color;

	public class HexColorProp extends BaseProp {

		override function init () {
			start = target[id];
		}
	
		override function update ($position) {
			target[id] = Color.interpolateColor(start, value, $position);
		}
	}
}