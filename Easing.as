package com.tweenman
{
	import fl.motion.easing.*;
	
	public class Easing
	{
		public static var easeLinear:Function = Linear.easeNone;
		public static var linear:Function = Linear.easeNone;
		public static var none:Function = Linear.easeNone;

		public static var easeOutSine:Function = Sine.easeOut;
		public static var easeInSine:Function = Sine.easeIn;
		public static var easeInOutSine:Function = Sine.easeInOut;
	
		public static var easeOutQuint:Function = Quintic.easeOut;
		public static var easeInQuint:Function = Quintic.easeIn;
		public static var easeInOutQuint:Function = Quintic.easeInOut;
		
		public static var easeOutQuart:Function = Quartic.easeOut;
		public static var easeInQuart:Function = Quartic.easeIn;
		public static var easeInOutQuart:Function = Quartic.easeInOut;
		
		public static var easeOutQuad:Function = Quadratic.easeOut;
		public static var easeInQuad:Function = Quadratic.easeIn;
		public static var easeInOutQuad:Function = Quadratic.easeInOut;
		
		public static var easeOutExpo:Function = Exponential.easeOut;
		public static var easeInExpo:Function = Exponential.easeIn;
		public static var easeInOutExpo:Function = Exponential.easeInOut;

		public static var easeOutElastic:Function = Elastic.easeOut;
		public static var easeInElastic:Function = Elastic.easeIn;
		public static var easeInOutElastic:Function = Elastic.easeInOut;
		
		public static var easeOutCircular:Function = Circular.easeOut;
		public static var easeInCircular:Function = Circular.easeIn;
		public static var easeInOutCircular:Function = Circular.easeInOut;
		
		public static var easeOutBack:Function = Back.easeOut;
		public static var easeInBack:Function = Back.easeIn;
		public static var easeInOutBack:Function = Back.easeInOut;
		
		public static var easeOutBounce:Function = Bounce.easeOut;
		public static var easeInBounce:Function = Bounce.easeIn;
		public static var easeInOutBounce:Function = Bounce.easeInOut;
		
		public static var easeOutCubic:Function = Cubic.easeOut;
		public static var easeInCubic:Function = Cubic.easeIn;
		public static var easeInOutCubic:Function = Cubic.easeInOut;
		
	}
}