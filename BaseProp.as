package com.tweenman {
	
	public class BaseProp {

		var id:Object;
		var tween:Tween;
		var start:Number;
		var change:Number;
		var target:*;
		var value:*;
	
		function init () {
			start = target[id];
			change = typeof(value) == "number" ? value - start : Number(value);
		}
	
		function update ($position) {
			var result:Number = start + ($position * change);
			if (target[id] != result) target[id] = result;
		}
	}
}