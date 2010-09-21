package com.tweenman.utils
{
	public class ColorMatrix
	{
		public var matrix:Array;
		public static const IDENTITY:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		
		private static const NEG_INF:Number = Number.NEGATIVE_INFINITY;
		private static const MATH_PI_180:Number = Math.PI/180;
		private static const r_lum:Number = 0.212671;
		private static const g_lum:Number = 0.715160;
		private static const b_lum:Number = 0.072169;

		public function ColorMatrix ()
		{
			matrix = IDENTITY.concat();
		}

		public function adjustBrightness (r:Number, g:Number=NEG_INF, b:Number=NEG_INF):void
		{
			g = (g == NEG_INF) ? r : g;
			b = (b == NEG_INF) ? r : b;
			concat([1,0,0,0,r,0,1,0,0,g ,0,0,1,0,b ,0,0,0,1,0 ]);
		}

		public function adjustContrast (r:Number, g:Number=NEG_INF, b:Number=NEG_INF):void
		{
			g = (g == NEG_INF) ? r : g;
			b = (b == NEG_INF) ? r : b;
			r+=1; g+=1; b+=1;
			concat([r,0,0,0,128*(1-r), 0,g,0,0,128*(1-g), 0,0,b,0,128*(1-b), 0,0,0,1,0 ]);
		}

		public function adjustSaturation (s:Number):void
		{
			var i:Number=1-s;
		    var irlum:Number = i * r_lum;
			var iglum:Number = i * g_lum;
			var iblum:Number = i * b_lum;
			concat([irlum + s, iglum, iblum, 0, 0, irlum, iglum + s, iblum, 0, 0, irlum, iglum, iblum + s, 0, 0, 0, 0, 0, 1, 0 ]);
		}

		public function adjustHue (angle:Number):void
		{
			angle *= MATH_PI_180;
			var c:Number = Math.cos(angle);
			var s:Number = Math.sin(angle);
			var f1:Number = 0.213;
			var f2:Number = 0.715;
			var f3:Number = 0.072;
			concat([(f1 + (c * (1 - f1))) + (s * (-f1)), (f2 + (c * (-f2))) + (s * (-f2)), (f3 + (c * (-f3))) + (s * (1 - f3)), 0, 0, (f1 + (c * (-f1))) + (s * 0.143), (f2 + (c * (1 - f2))) + (s * 0.14), (f3 + (c * (-f3))) + (s * -0.283), 0, 0, (f1 + (c * (-f1))) + (s * (-(1 - f1))), (f2 + (c * (-f2))) + (s * f2), (f3 + (c * (1 - f3))) + (s * f3), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}

		public function adjustColorize (rgb:Number, amount:Number=1):void
		{
			var r:Number = ((rgb >> 16) & 0xff) / 255;
			var g:Number = ((rgb >> 8 ) & 0xff) / 255;
			var b:Number = (  rgb         & 0xff) / 255;
			var inv_amount:Number = 1 - amount;
			concat([inv_amount + amount*r*r_lum, amount*r*g_lum,  amount*r*b_lum, 0, 0, amount*g*r_lum, inv_amount + amount*g*g_lum, amount*g*b_lum, 0, 0, amount*b*r_lum,amount*b*g_lum, inv_amount + amount*b*b_lum, 0, 0, 0 , 0 , 0 , 1, 0]);
		}

		public function concat (mat:Array):void
		{
			var temp:Array = [];
			var i:Number = 0;
			for (var y:Number = 0; y < 4; y++)
			{
				for (var x:Number = 0; x < 5; x++)
				{
					temp[i + x] = mat[i   ] * matrix[x     ] + 
								   mat[i+1] * matrix[x +  5] + 
								   mat[i+2] * matrix[x + 10] + 
								   mat[i+3] * matrix[x + 15] +
								   (x == 4 ? mat[i+4] : 0);
				}
				i+=5;
			}
			matrix = temp;
		}
	}
}