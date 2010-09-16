package com.tweenman {
		
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	public class FrameProp extends BaseProp {

		override function init () {
			if (!(target is MovieClip)) return tween.typeError(id, "MovieClip");
			start = target.currentFrame;
			if (typeof(value) == "number") {
				change = value - start;
			} else {
				var labelFound:Boolean = false;
				for each (var f:FrameLabel in target.currentLabels) {
					if (f.name == value) {
						value = int(f.frame);
						change = value - start;
						labelFound = true;
						break;
					}
				}
				if (!labelFound) change = Number(value);
			}
		}

		override function update ($position) {
			var newFrame:int = int(start + ($position * change));
			target.gotoAndStop(newFrame > 0 ? newFrame : 1);
		}
	}
}