package com.tweenman
{
	import com.tweenman.props.*;
	
	public class Config
	{
		internal static const virtualProps:Object = {
			visible: 				VisibleProp,
			frame: 					FrameProp,
			scale: 					ScaleProp,
			rectangle: 				RectangleProp,
			color: 					ColorProp,
			volume: 				SoundProp,
			pan: 					SoundProp,
			colorMatrix: 			ColorFilterProp,
			bevel: 					BevelFilterProp,
			blur: 					BlurFilterProp,
			convolution: 			ConvolutionProp,
			displace: 				DisplaceProp,
			dropShadow: 			DropShadowProp,
			glow: 					GlowFilterProp,
			text: 					TextProp,
			hexColor: 				HexColorProp,
			backgroundColor: 		HexColorProp,
			borderColor: 			HexColorProp,
			textColor: 				HexColorProp,
			array: 					ArrayProp
		};
		
		internal static const conflictMap:Object = {
			visible: 				["alpha", "color"],
			alpha: 					["visible", "color"],
			color: 					["visible", "alpha"],
			scale: 					["scaleX", "scaleY"],
			scaleX: 				"scale",
			scaleY: 				"scale"
		};
				
		internal static const internalProps:Object = {
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
	}
}