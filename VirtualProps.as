package com.tweenman {
	
	public class VirtualProps {

		static var visible:Class 			= VisibleProp;
		static var frame:Class 				= FrameProp;
		static var scale:Class				= ScaleProp;
		static var rectangle:Class			= RectangleProp;
		static var color:Class				= ColorProp;
		static var volume:Class				= SoundProp;
		static var pan:Class				= SoundProp;

		static var colormatrix:Class		= ColorFilterProp;
		static var bevel:Class				= BevelFilterProp;
		static var blur:Class				= BlurFilterProp;
		static var convolution:Class		= ConvolutionProp;
		static var displace:Class			= DisplaceProp;
		static var dropshadow:Class			= DropShadowProp;
		static var glow:Class				= GlowFilterProp;

		static var backgroundColor:Class	= HexColorProp;
		static var borderColor:Class		= HexColorProp;
		static var textColor:Class			= HexColorProp;
		static var hexColor:Class			= HexColorProp;
		static var text:Class				= TextProp;
	}
}