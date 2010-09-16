package com.tweenman
{
	import fl.motion.easing.*;
	import com.tweenman.props.*;
	
	public class Config
	{
		static const virtualProps = {
			visible: 				VisibleProp,
			frame: 					FrameProp,
			scale: 					ScaleProp,
			rectangle: 				RectangleProp,
			color: 					ColorProp,
			volume: 				SoundProp,
			pan: 					SoundProp,
			colormatrix: 			ColorFilterProp,
			bevel: 					BevelFilterProp,
			blur: 					BlurFilterProp,
			convolution: 			ConvolutionProp,
			displace: 				DisplaceProp,
			dropshadow: 			DropShadowProp,
			glow: 					GlowFilterProp,
			backgroundColor: 		HexColorProp,
			borderColor: 			HexColorProp,
			textColor: 				HexColorProp,
			hexColor: 				HexColorProp,
			text: 					TextProp,
			array: 					ArrayProp
		};
		
		static const conflictMap = {
			visible: 				["alpha", "color"],
			alpha: 					["visible", "color"],
			color: 					["visible", "alpha"],
			scale: 					["scaleX", "scaleY"],
			scaleX: 				"scale",
			scaleY: 				"scale"
		};
				
		static const internalProps = {
			time: 					true,
			duration: 				true,
			frames: 				true,
			ease: 					true,
			delay: 					true,
			onComplete: 			true,
			onCompleteParams: 		true,
			onUpdate: 				true,
			onUpdateParams: 		true,
			onStart: 				true,
			onStartParams: 			true,
			easeParams: 			true,
			proxiedEase: 			true
		};
		
		static const easeShortcuts = {
			easeLinear: 			Linear.easeNone,
			linear: 				Linear.easeNone,
			none: 					Linear.easeNone,

			easeOutSine: 			Sine.easeOut,
			easeInSine: 			Sine.easeIn,
			easeInOutSine: 			Sine.easeInOut,

			easeOutQuint: 			Quintic.easeOut,
			easeInQuint: 			Quintic.easeIn,
			easeInOutQuint: 		Quintic.easeInOut,
	
			easeOutQuart: 			Quartic.easeOut,
			easeInQuart: 			Quartic.easeIn,
			easeInOutQuart: 		Quartic.easeInOut,
	
			easeOutQuad: 			Quadratic.easeOut,
			easeInQuad: 			Quadratic.easeIn,
			easeInOutQuad: 			Quadratic.easeInOut,
	
			easeOutExpo: 			Exponential.easeOut,
			easeInExpo: 			Exponential.easeIn,
			easeInOutExpo: 			Exponential.easeInOut,

			easeOutElastic: 		Elastic.easeOut,
			easeInElastic: 			Elastic.easeIn,
			easeInOutElastic: 		Elastic.easeInOut,
	
			easeOutCircular: 		Circular.easeOut,
			easeInCircular: 		Circular.easeIn,
			easeInOutCircular: 		Circular.easeInOut,
	
			easeOutBack: 			Back.easeOut,
			easeInBack: 			Back.easeIn,
			easeInOutBack: 			Back.easeInOut,
	
			easeOutBounce: 			Bounce.easeOut,
			easeInBounce: 			Bounce.easeIn,
			easeInOutBounce: 		Bounce.easeInOut,
	
			easeOutCubic: 			Cubic.easeOut,
			easeInCubic: 			Cubic.easeIn,
			easeInOutCubic: 		Cubic.easeInOut
		};
	}
}