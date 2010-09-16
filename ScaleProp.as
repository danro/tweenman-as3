package com.tweenman {
		
	public class ScaleProp extends MultiProp {

		override function init () {
			propList = ["scaleX", "scaleY"];
			current = target;
			super.init();
		}
	}
}