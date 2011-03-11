package com.tweenman.utils
{
	import flash.geom.ColorTransform;
	
	public class ColorUtil
	{		
		public static function initColorTransform ($value:Object):ColorTransform
		{
			var resultColor:ColorTransform = new ColorTransform;
			var p:String;
			for (p in $value)
			{
				switch (p)
				{
					case "brightness":
						setBrightness(resultColor, $value.brightness);
						break;
					case "tintColor":
					case "tintMultiplier":
						setTint(resultColor, $value);
						break;
					case "burn":
						resultColor.redOffset = resultColor.greenOffset = resultColor.blueOffset = 255 * $value.burn;
						break;
					default:
						resultColor[p] = $value[p];
						break;
				}
			}
			return resultColor;
		}
		
		public static function setBrightness ($ct:ColorTransform, $value:Number):void
		{
			if ($value > 1) $value = 1;
			else if ($value < -1) $value = -1;
			var percent:Number = 1 - ($value < 0 ? -$value : $value);
			var offset:Number = 0;
			if ($value > 0) offset = $value * 255;
			$ct.redMultiplier = $ct.greenMultiplier = $ct.blueMultiplier = percent;
			$ct.redOffset = $ct.greenOffset = $ct.blueOffset = offset;
		}
		
		public static function setTint ($ct:ColorTransform, $value:Object):void
		{
			var tintColor:Number = $value.tintColor == undefined ? 0x000000 : $value.tintColor;
			var tintMultiplier:Number = $value.tintMultiplier == undefined ? 1 : $value.tintMultiplier;
			$ct.redMultiplier = $ct.greenMultiplier = $ct.blueMultiplier = 1 - tintMultiplier;
			var r:uint = (tintColor >> 16) & 0xFF;
			var g:uint = (tintColor >>  8) & 0xFF;
			var b:uint =  tintColor        & 0xFF;
			$ct.redOffset   = Math.round(r * tintMultiplier);
			$ct.greenOffset = Math.round(g * tintMultiplier);
			$ct.blueOffset  = Math.round(b * tintMultiplier);
		}
		
		public static function interpolateTransform ($from:ColorTransform, $to:ColorTransform, $position:Number):ColorTransform
		{
			var q:Number = 1-$position;
			var resultColor:ColorTransform = new ColorTransform
			(
				  $from.redMultiplier*q   + $to.redMultiplier*$position
				, $from.greenMultiplier*q + $to.greenMultiplier*$position
				, $from.blueMultiplier*q  + $to.blueMultiplier*$position
				, $from.alphaMultiplier*q + $to.alphaMultiplier*$position
				, $from.redOffset*q       + $to.redOffset*$position
				, $from.greenOffset*q     + $to.greenOffset*$position
				, $from.blueOffset*q      + $to.blueOffset*$position
				, $from.alphaOffset*q     + $to.alphaOffset*$position
			)
			return resultColor;
		}
		
		public static function interpolateColor ($from:uint, $to:uint, $position:Number):uint
		{
			var q:Number = 1-$position;
			var fromA:uint = ($from >> 24) & 0xFF;
			var fromR:uint = ($from >> 16) & 0xFF;
			var fromG:uint = ($from >>  8) & 0xFF;
			var fromB:uint =  $from        & 0xFF;
			
			var toA:uint = ($to >> 24) & 0xFF;
			var toR:uint = ($to >> 16) & 0xFF;
			var toG:uint = ($to >>  8) & 0xFF;
			var toB:uint =  $to        & 0xFF;
			
			var resultA:uint = fromA*q + toA*$position;
			var resultR:uint = fromR*q + toR*$position;
			var resultG:uint = fromG*q + toG*$position;
			var resultB:uint = fromB*q + toB*$position;
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			return resultColor;
		}
	}
}