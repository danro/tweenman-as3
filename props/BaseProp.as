package com.tweenman.props
{
	import com.tweenman.Tween;
	
	public class BaseProp
	{
		public var id:Object;
		public var tween:Tween;
		public var start:Number;
		public var change:Number;
		public var target:*;
		public var value:*;
		
		public function BaseProp () {}
		
		public function init ():void
		{
			this.start = Number(this.target[id]);
			this.change = typeof(this.value) == "number" ? Number(this.value - this.start) : Number(this.value);
		}
		
		public function update ($position:Number):void
		{
			var result:Number = this.start + ($position * this.change);
			this.target[id] = result;
		}
		
		public function dispose ():void
		{
			this.id = undefined;
			this.tween = undefined;
			this.start = undefined;
			this.change = undefined;
			this.target = undefined;
			this.value = undefined;
		}
	}
}