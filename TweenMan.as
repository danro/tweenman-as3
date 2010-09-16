/*
	Version: 1.7 AS3
	---------------------------------------------------------------------------------
	TweenMan is a complicated man, and no one understands him but his woman...
	Initially influenced by Jack Doyle's TweenLite engine, TweenMan is now his own man 
	attempting to provide extended tweening functionality while remaining fit and slim.
	
	Weighing in at approximately 10k compiled, TweenMan does a few things you probably 
	haven't seen other engines do. He can tween the scrollRect property of sprites, 
	tween to frame labels in movieclips, tween just about every filter's properties 
	including the color of glows, bevels, etc., and he can accomplish all of this 
	while using time-based or frame-based animation.
	
	For updates and examples, visit: http://www.tweenman.com

	Author: Dan Rogers - dan@danro.net

	Special Thanks:	Jack Doyle for sharing TweenLite (greensock.com)
					Mario Klingemann for sharing ColorMatrix (quasimondo.com)

	Basic Usage
	---------------------------------------------------------------------------------
	import com.tweenman.TweenMan;

	// time-based alpha tween
	TweenMan.addTween(target, { time: 1, alpha: 0, ease: "easeInOutExpo" });

	// frame-based scrollRect tween
	TweenMan.addTween(target, { frames: 50, rectangle: [0,0,100,100], ease: "easeOutBack" });

	// time-based ColorMatrixFilter tween
	TweenMan.addTween(target, { time: 2, colormatrix: { saturation: 0, contrast: 2 } });

	// tween an array
	var myArray:Array = [1, 4, 5, 6];
	TweenMan.addTween(myArray, { time: 1, array: [0, 3, 4, 4] });

	// remove tweens by property
	TweenMan.removeTweens(target, "alpha", "rectangle", "color");

	// remove all tweens on target
	TweenMan.removeTweens(target);

	// see if a tween is active
	TweenMan.isTweening(target, "color");


	Tween Properties
	---------------------------------------------------------------------------------
	time					time or duration of tween in seconds
	duration				eqivalent to time, duration in seconds
	frames					frame-based duration, overrides time/duration if set
	ease					function or string, default is Quartic.easeOut or "easeOutQuart"
	delay					delay before start, in seconds or frames depending on setting
	onComplete				callback function gets called when tween finishes
	onCompleteParams		params for onComplete function
	onUpdate				callback function gets called when tween updates
	onUpdateParams			params for onUpdate function
	onStart					callback function gets called when tween starts
	onStartParams			params for onStart function
	easeParams				params for ease function, mostly Back and Elastic
	array					if the target is an array, this property sets the end values


	Virtual Properties  
	  { prop: value } indicates tweenable sub-properties and default values
	---------------------------------------------------------------------------------
	visible			number or boolean		same as alpha but toggles visibility
	frame			number or string		frame number or frame label of a MovieClip
	scale			number					scaleX and scaleY properties combined
	color			object					transform a DisplayObject using Color
	  { redMultiplier: 1.0, greenMultiplier: 1.0, blueMultiplier: 1.0, alphaMultiplier: 1.0, 
		redOffset: 0, greenOffset: 0, blueOffset: 0, alphaOffset: 0, brightness: 0,
		tintColor: 0x000000, tintMultiplier: 0, burn: 0 }
	
	rectangle		[0,0,100,100]			scrollRect property of a DisplayObject
	volume			number					volume using the soundTransform property
	pan				number					pan using the soundTransform property
	
	colormatrix		object					ColorMatrixFilter
	  { brightness: 0, contrast: 0, saturation: 1, hue: 0, colorize: 0x000000, 
		colorizeAmount: 0, blend: false } // set blend for additive blending
	
	bevel			object					BevelFilter
	  { distance: 4.0,  angle: 45, highlightColor: 0xFFFFFF, highlightAlpha: 1.0, 
		 shadowColor: 0x000000, shadowAlpha: 1.0, blurX: 4.0, blurY: 4.0, strength: 0 }
	
	blur			object					BlurFilter
	  { blurX: 0.0, blurY: 0.0 }
	
	convolution		object					ConvolutionFilter
	  { divisor: 1.0, bias: 0.0, color: 0, alpha: 0.0 }
	
	displace		object					DisplacementMapFilter
	  { scaleX: 0.0, scaleY: 0.0, color: 0, alpha: 0.0 }
	
	dropshadow		object					DropShadowFilter
	  { distance: 0.0, angle: 45, color: 0, alpha: 1.0, blurX: 0.0, blurY: 0.0, strength: 0 }
	
	glow			object					GlowFilter
	  { alpha: 1, blurX: 0.0, blurY: 0.0, strength: 0, color: 0 }


	TweenMan is Licensed under the MIT License
	---------------------------------------------------------------------------------
	Copyright (c) 2008 Dan Rogers

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

package com.tweenman {

	import flash.events.Event;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import fl.motion.easing.Quartic;

	public class TweenMan {

		public static var version:String = "1.7 AS3";
		public static var defaultEase:Function = Quartic.easeOut;
		
		static var initialized:Boolean;
		static var listenTarget:Sprite = new Sprite;
		static var listenerEnabled:Boolean;
		static var cleanupTimer:Timer = new Timer(2000);
		static var tweenDict:Dictionary = new Dictionary();
		static var frameCount:uint = 0;
		static var tweenCount:uint = 0;
		
		public function TweenMan () {
			if (initialized) return;
			listenTarget.addEventListener(Event.ENTER_FRAME, countFrames);
			initialized = true;
		}
		
		public static function addTween ($target:Object, $vars:Object) {
			if (!initialized) new TweenMan;
			
			if ($target == null) {
				trace("TweenMan says: target is null, vars [" + $vars + "]");
				return;
			}
			
			if (tweenDict[$target] == null ) {
				tweenDict[$target] = {};
			} else {
				var removeParams:Array = [$target];
				for (var p:String in $vars) {
					if ( InternalProps[p] != null ) continue;
					removeParams.push(p);
					if ( ConflictMap[p] != null ) {
						removeParams = removeParams.concat(ConflictMap[p]);
					}
				}
				removeTweens.apply(null, removeParams);
			}
			if (tweenDict[$target] == null) tweenDict[$target] = {};
			var tweenID:String = "t" + String(++tweenCount);
			tweenDict[$target][tweenID] = new Tween($target, $vars, tweenID);
		}
		
		public static function removeTweens ($target:Object, ...$props:Array) {
			if ($target == null || tweenDict[$target] == null) return;
			if ($props.length == 0) {
				delete tweenDict[$target];
			} else {
				var p:String, tween:Tween, removed:Boolean;
				for each (p in $props) {
					for each (tween in tweenDict[$target]) {
						removed = tween.removeProp(p);
						if (removed && tween.children == 0) kill(tween);
					}
				}
			}
		}
		
		public static function removeAll () {
			tweenDict = new Dictionary();
			killGarbage();
		}
		
		public static function isTweening ($target:Object, $prop:String=null):Boolean {
			killGarbage();
			if (tweenDict[$target] == null) return false;
			if ($prop == null) return true;
			var tween:Tween;
			for each (tween in tweenDict[$target]) {
				if (tween.props[$prop] != null) return true;
			}
			return false;
		}
		
		public static function killGarbage ($e:Event=null) {
			var count:uint = 0;
			var found:Boolean;
			var targ:Object, tweenID:String;
			for (targ in tweenDict) {
				found = false;
				for (tweenID in tweenDict[targ]) {
					found = true;
					break;
				}
				if (!found) {
					delete tweenDict[targ];
				} else {
					++count;
				}
			}
			if (count == 0) {
				disableRender();
			}
		}
		
		static function kill ($tween:Tween) {
			if (tweenDict[$tween.target] == null || tweenDict[$tween.target][$tween.id] == null) return;
			delete tweenDict[$tween.target][$tween.id];
		}
		
		static function getFrames ():uint {
			return frameCount;
		}
		
		static function enableRender () {
			if (!listenerEnabled) {
				listenTarget.addEventListener(Event.ENTER_FRAME, render);
				cleanupTimer.addEventListener("timer", killGarbage);
	           	cleanupTimer.start();
				listenerEnabled = true;
			}
			render();
		}

		static function disableRender () {
			listenTarget.removeEventListener(Event.ENTER_FRAME, render);
			cleanupTimer.removeEventListener("timer", killGarbage);
			cleanupTimer.stop();
			resetCounts();
			listenerEnabled = false;
		}
		
		private static function countFrames ($e:Event) {
			++frameCount;
		}
		
		private static function render ($e:Event=null) {
			var t:uint = getTimer();
			var f:uint = frameCount;
			var obj:Object, tween:Tween;
			for each (obj in tweenDict) {
				for each (tween in obj) {
					if (tween.active) tween.render(t,f);
				}
			}
		}
		
		private static function resetCounts () {
			frameCount = 0;
			tweenCount = 0;
		}
	}
}