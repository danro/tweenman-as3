/*
	Version: 2.2 AS3
	---------------------------------------------------------------------------------
	TweenMan is a complicated man, and no one understands him but his woman...
	Initially influenced by Jack Doyle's TweenLite engine, TweenMan is now his own man 
	attempting to provide extended tweening functionality while remaining fit and slim.
	
	Weighing in at approximately 12k compiled, TweenMan does a few things you probably 
	haven't seen other engines do. He can tween the scrollRect property of sprites, 
	tween to frame labels in movieclips, tween just about every filter's properties 
	including the color of glows, bevels, etc., and he can accomplish all of this 
	while using time-based or frame-based animation.
	
	For updates and examples, visit: http://www.tweenman.com
	
	Author: Dan Rogers - dan@danro.net
	
	Special Thanks:	Jack Doyle (greensock.com)
					Mario Klingemann (quasimondo.com)
					Robert Penner (robertpenner.com)
	
	Basic Usage
	---------------------------------------------------------------------------------
	import com.tweenman.TweenMan;

	// time-based alpha tween
	TweenMan.addTween(target, { time: 1, alpha: 0, ease: "easeInOutExpo" });

	// frame-based scrollRect tween
	TweenMan.addTween(target, { frames: 50, rectangle: [0,0,100,100], ease: "easeOutBack" });

	// time-based ColorMatrixFilter tween
	TweenMan.addTween(target, { time: 2, colorMatrix: { saturation: 0, contrast: 2 } });

	// tween an array
	var myArray:Array = [1, 4, 5, 6];
	TweenMan.addTween(myArray, { time: 1, array: [0, 3, 4, 4] });

	// remove tweens by property
	TweenMan.removeTweens(target, "alpha", "rectangle", "color");

	// remove all tweens on target
	TweenMan.removeTweens(target);

	// see if a tween is active
	TweenMan.isTweening(target, "color");
	
	// remove all tweens
	TweenMan.removeAll();
	
	// remove all tweens (and empty object pools)
	TweenMan.dispose();


	Tween Properties
	---------------------------------------------------------------------------------
	time					time or duration of tween in seconds
	frames					frame-based duration, overrides time duration once set
	ease					function or string, default is "easeOutQuart"
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
	[property]			[type]					[description]
	  { prop: value } indicates tweenable sub-properties and default values
	---------------------------------------------------------------------------------
	visible				Number or Boolean		same as alpha but toggles visibility
	frame				Number or String		frame number or frame label of a MovieClip
	scale				Number					scaleX and scaleY properties combined
	color				Object					transform a DisplayObject using Color
	  { redMultiplier: 1.0, greenMultiplier: 1.0, blueMultiplier: 1.0, alphaMultiplier: 1.0, 
		redOffset: 0, greenOffset: 0, blueOffset: 0, alphaOffset: 0, brightness: 0,
		tintColor: 0x000000, tintMultiplier: 0, burn: 0 }
	
	rectangle			[0,0,100,100]			scrollRect property of a DisplayObject
	volume				Number					volume using the soundTransform property
	pan					Number					pan using the soundTransform property
	
	colorMatrix			Object					ColorMatrixFilter
	  { brightness: 0, contrast: 0, saturation: 1, hue: 0, colorize: 0x000000, 
		colorizeAmount: 0, blend: false } // set blend for additive blending
	
	bevel				Object					BevelFilter
	  { distance: 4.0,  angle: 45, highlightColor: 0xFFFFFF, highlightAlpha: 1.0, 
		shadowColor: 0x000000, shadowAlpha: 1.0, blurX: 4.0, blurY: 4.0, strength: 0 }
	
	blur				Object					BlurFilter
	  { blurX: 0.0, blurY: 0.0 }
	
	convolution			Object					ConvolutionFilter
	  { divisor: 1.0, bias: 0.0, color: 0, alpha: 0.0 }
	
	displace			Object					DisplacementMapFilter
	  { scaleX: 0.0, scaleY: 0.0, color: 0, alpha: 0.0 }
	
	dropShadow			Object					DropShadowFilter
	  { distance: 0.0, angle: 45, color: 0, alpha: 1.0, blurX: 0.0, blurY: 0.0, strength: 0 }
	
	glow				Object					GlowFilter
	  { alpha: 1, blurX: 0.0, blurY: 0.0, strength: 0, color: 0 }
	
	text				String					simple text tween for TextField
	hexColor			Number					generic interpolated hex color value
	backgroundColor		Number					TextField.backgroundColor as hex value
	borderColor			Number					TextField.borderColor as hex value
	textColor			Number					TextField.textColor as hex value


	TweenMan is Licensed under the MIT License
	---------------------------------------------------------------------------------
	Copyright (c) 2010 Dan Rogers

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

package com.tweenman
{
	import flash.events.Event;
	import flash.display.Shape;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import com.tweenman.props.BaseProp;
	import com.tweenman.utils.ObjectPool;
	import com.tweenman.utils.MultiObjectPool;

	public class TweenMan
	{
		public static const defaultEase:Function = Easing.easeOutQuart;
		
		internal static var initialized:Boolean;
		internal static var listenTarget:Shape;
		internal static var listenerEnabled:Boolean;
		internal static var tweenDict:Dictionary;
		internal static var renderDict:Dictionary;
		internal static var frameCount:int;
		internal static var tweenCount:int;
		internal static var tweenPool:ObjectPool;
		internal static var propertyPool:MultiObjectPool;
		
		public function TweenMan ()
		{
			if (initialized) return;
			this.initialize();
			initialized = true;
		}
		
		public static function addTween ($target:Object, $vars:Object):void
		{
			if (!initialized) new TweenMan;
			if ($target == null)
			{
				trace("TweenMan says: target is null, vars [" + $vars + "]");
				return;
			}
			if (tweenDict[$target] == null)
			{
				tweenDict[$target] = {};
			}
			else
			{
				var removeParams:Array = [$target];
				for (var p:String in $vars)
				{
					if (Config.internalProps[p] != null) continue;
					removeParams.push(p);
					if (Config.conflictMap[p] != null) removeParams = removeParams.concat(Config.conflictMap[p]);
				}
				removeTweens.apply(null, removeParams);
			}
			if (tweenDict[$target] == null) tweenDict[$target] = {};
			var tweenID:String = "t" + String(++tweenCount);
			var tweenObj:Object = tweenDict[$target];
			var tween:Tween = tweenObj[tweenID] = tweenPool.acquire();
			tween.init($target, $vars, tweenID);
		}
		
		public static function removeTweens ($target:Object, ...$props:Array):void
		{
			if (!initialized || $target == null || tweenDict[$target] == null) return;
			var tween:Tween;
			if ($props.length == 0)
			{
				for each (tween in tweenDict[$target])
				{
					kill(tween);
				}
				delete tweenDict[$target];
			}
			else
			{
				var p:String, prop:BaseProp, removed:Boolean;
				for each (p in $props)
				{
					for each (tween in tweenDict[$target])
					{
						prop = tween.props[p];
						removed = tween.removeProp(p);
						if (removed)
						{
							prop.dispose();
							propertyPool.release(prop);
							if (tween.children == 0) kill(tween);
						}
					}
				}
			}
		}
		
		public static function removeAll ():void
		{
			if (!initialized) return;
			disableRender();
		}
		
		public static function dispose ():void
		{
			if (!initialized) return;
			removeAll();
			tweenPool.empty();
			propertyPool.empty();
		}
		
		public static function isTweening ($target:Object, $prop:String=null):Boolean
		{
			if (!initialized || tweenDict[$target] == null) return false;
			if ($prop == null) return true;
			var tween:Tween;
			for each (tween in tweenDict[$target])
			{
				if (tween.props[$prop] != null) return true;
			}
			return false;
		}
		
		public static function getPropByClass ($propClass:Class):BaseProp
		{
			if (!initialized) return null;
			return propertyPool.acquire($propClass);
		}
		
		internal static function completeTween ($tween:Tween, $onComplete:Function, $onCompleteParams:Object):void
		{
			kill($tween);
			$tween = null;
			if ($onComplete != null) $onComplete.apply(null, $onCompleteParams);
		}
		
		internal static function kill ($tween:Tween):void
		{
			var targ:Object = $tween.target;
			var tweenID:String = $tween.id;
			delete renderDict[tweenID];
			if (tweenDict[targ])
			{
				delete tweenDict[targ][tweenID];
				var found:Boolean = false;
				var tween:Tween;
				for each (tween in tweenDict[targ])
				{
					found = true;
					break;
				}
				if (!found) delete tweenDict[targ];
			}
			for each (var prop:BaseProp in $tween.props)
			{
				prop.dispose();
				propertyPool.release(prop);
			}
			$tween.dispose();
			tweenPool.release($tween);
		}
		
		internal static function getFrames ():int
		{
			return frameCount;
		}
		
		internal static function addToRender ($tween:Tween):void
		{
			renderDict[$tween.id] = $tween;
			if (!listenerEnabled) enableRender();
		}
		
		internal static function enableRender ():void
		{
			listenTarget.addEventListener(Event.ENTER_FRAME, render);
			listenerEnabled = true;
		}

		internal static function disableRender ():void
		{
			listenTarget.removeEventListener(Event.ENTER_FRAME, render);
			listenerEnabled = false;
			resetState();
		}
		
		private static function countFrames ($e:Event):void
		{
			++frameCount;
		}
		
		private static function render ($e:Event=null):void
		{
			var t:int = getTimer();
			var f:int = frameCount;
			var tween:Tween;
			var found:Boolean = false;
			for each (tween in renderDict)
			{
				if (tween.isActive(t,f)) tween.render(t,f);
				found = true;
			}
			if (!found) disableRender();
		}
		
		private static function resetState ():void
		{
			tweenDict = new Dictionary(true);
			renderDict = new Dictionary(true);
			frameCount = 0;
			tweenCount = 0;
		}
		
		private function initialize ():void
		{
			resetState();
			listenTarget = new Shape;
			listenTarget.addEventListener(Event.ENTER_FRAME, countFrames);
			tweenPool = new ObjectPool(Tween);
			propertyPool = new MultiObjectPool(Config.virtualProps);
			propertyPool.add(BaseProp);
		}
	}
}