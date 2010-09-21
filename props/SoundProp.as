package com.tweenman.props
{		
	import flash.media.Microphone;
	import flash.net.NetStream;
	import flash.display.SimpleButton;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.display.Sprite;
	import flash.media.SoundTransform;

	public class SoundProp extends BaseProp
	{
		private static var types:Array = [ Microphone, NetStream, SimpleButton, SoundChannel, Sprite ];
		private var previous:Object;

		override public function init ():void
		{
			var typeFound:Boolean = false;
			if (target == SoundMixer) {
				typeFound = true;
			} else {
				for each (var soundType:Class in types) {
					if (target is soundType) { typeFound = true; break; }
				}
			}
			if (!typeFound) { tween.typeError(id, "Microphone, NetStream, SimpleButton, SoundChannel, SoundMixer, Sprite"); return; }
			if (target.soundTransform == null) target.soundTransform = new SoundTransform;
			previous = target;
			target = target.soundTransform;
			super.init();
		}

		override public function update ($position:Number):void
		{
			target = previous.soundTransform;
			super.update($position);
			previous.soundTransform = target;
		}
		
		override public function dispose ():void
		{
			super.dispose();
			this.previous = undefined;
		}
	}
}