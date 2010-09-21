package com.tweenman.props
{	
	import com.tweenman.TweenMan;
	
	public class ArrayProp extends BaseProp
	{
		protected var props:Object = {};
		protected var current:Array;

		override public function init ():void
		{
			if (current == null)
			{
				if (target is Array) {
					current = target;
				} else if (target[id] is Array) {
					current = target[id];
				}
			}
			var valueIsArray:Boolean = value is Array;
			if (!valueIsArray) { tween.valueError(id); return; }
			var count:int = current.length;
			var i:int, prop:BaseProp;
			for (i = 0; i < count; ++i)
			{
				prop = TweenMan.getPropByClass(BaseProp);
				props[ String(i) ] = prop;
				prop.id = i;
				prop.value = value[i];
				prop.target = current;
				prop.init();
			}
		}
		
		override public function update ($position:Number):void
		{
			var prop:BaseProp;
			for each (prop in props)
			{
				prop.update($position);
			}
		}
		
		override public function dispose ():void
		{
			super.dispose();
			this.props = {};
			this.current = undefined;
		}
	}
}