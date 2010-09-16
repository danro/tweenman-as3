package com.tweenman {
		
	public class TextProp extends BaseProp {

		override function init () {
			start = target[id];
		}
	
		override function update ($position) {
			target[id] = value.substr(0, Math.round($position * value.length));
		}
	}
}