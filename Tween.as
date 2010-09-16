package com.tweenman {

	import flash.display.DisplayObject;
	import flash.utils.getTimer;

	public class Tween {

		var id:String;
		var target:Object;
		var duration:Number;
		var delay:Number;
		var vars:Object;
		var ease:Function;
		var props:Object;
		var children:uint;

		var activated:Boolean;
		var startTime:uint;
		var initTime:uint;
		var timeMethod:Function = getTimer;
		static var ZERO:Number = 0.001;

		public function Tween ($target:Object, $vars:Object, $id:String) {
			target = $target;
			vars = $vars;
			id = $id;
			children = 0;
			if (!isNaN(vars.time)) vars.duration = vars.time;
			duration =  vars.duration;
			delay = vars.delay;
			if (isNaN(delay) || delay < 0) delay = 0;
			if (!isNaN(vars.frames)) {
				timeMethod = TweenMan.getFrames;
				duration = int(vars.frames);
				delay = int(delay);
			}
			if (isNaN(duration) || duration <= 0) duration = ZERO;
			if (vars.ease is String) vars.ease = Easing[vars.ease];
			ease = vars.ease is Function ? vars.ease : TweenMan.defaultEase;
			if (vars.easeParams != null) {
				vars.proxiedEase = ease;
				ease = easeProxy;
			}
			props = {};
			initTime = timeMethod();
			activated = false;
			initProps();
			if (duration == ZERO && delay == 0) {
				startTime = 0;
				render(1, 1);
			} else {
				TweenMan.enableRender();
			}
		}

		function render ($t:uint, $f:uint) {
			var elapsed:Number;
			if (timeMethod == getTimer) {
				elapsed = ($t - startTime) / 1000;
			} else {
				elapsed = $f - startTime;
			}
			if (elapsed > duration) elapsed = duration;
			var position:Number = ease(elapsed, 0, 1, duration);
			for each (var prop:BaseProp in props) {
				prop.update(position);
			}
			if (vars.onUpdate != null) vars.onUpdate.apply(null, vars.onUpdateParams);
			if (elapsed == duration) {
				complete();
			}
		}

		function get active():Boolean {
			if (activated) {
				return true;
			} else {
				if (timeMethod == getTimer) {
					if ((timeMethod() - initTime) / 1000 > delay) {
						activated = true;
						startTime = initTime + (delay * 1000);
						if (vars.onStart != null) vars.onStart.apply(null, vars.onStartParams);
						if (duration == ZERO) startTime -= 1;
						return true;
					}
				} else {
					if (timeMethod() - initTime > delay) {
						activated = true;
						startTime = initTime + delay;
						if (vars.onStart != null) vars.onStart.apply(null, vars.onStartParams);
						if (duration == ZERO) startTime -= 1;
						return true;
					}
				}
			}
			return false;
		}

		function removeProp ($p:String):Boolean {
			if (props[$p] == null) {
				return false;
			} else {
				--children;
				delete props[$p];
				return true;
			}
		}

		function typeError ($p, $type) {
			trace("TweenMan says: target must be type [" + $type + "] to use [" + $p + "]");
			removeProp($p);
		}

		function valueError ($p) {
			trace("TweenMan says: unexpected value given for " + target + "[" + $p + "]");
			removeProp($p);
		}

		private function complete () {
			var onComplete:Function = vars.onComplete;
			var onCompleteParams:Object = vars.onCompleteParams;
			TweenMan.kill(this);
			if (onComplete != null) onComplete.apply(null, onCompleteParams);
		}

		private function initProps() {
			var prop:BaseProp;
			var p:String;
			for (p in vars) {
				if ( InternalProps[p] != null ) {
					continue;
				} else {
					var propClass:Class;
					if ( VirtualProps[p] != null ) {
						propClass = VirtualProps[p];
					} else if ( p == "array" && target is Array ) {
						propClass = ArrayProp;
					} else if ( target[p] != null ) {
						propClass = BaseProp;
					}
					if ( propClass != null ) {
						++children;
						prop = new propClass as BaseProp;
						props[p] = prop;
						prop.id = p;
						prop.tween = this;
						prop.target = target;
						prop.value = vars[p];
						prop.init();
					} else {
						trace("TweenMan says: target [" + target + "] does not contain property [" + p + "]");
					}
				}
			}
		}

		private function easeProxy (...$params:Array):Number {
			return vars.proxiedEase.apply(null, $params.concat(vars.easeParams));
		}
	}
}
