package com.tweenman.props
{	
	import com.tweenman.TweenMan;
	
	public class BaseMultiProp extends BaseProp
	{
		protected var props:Object = {};
		protected var propList:Array = [];
		protected var current:Object = {};
		protected var defaults:Object = {};
		protected var classes:Object = {};

		override public function init ():void
		{
			var propCount:int = propList.length;
			var valueIsArray:Boolean = value is Array;
			var valueIsObject:Boolean = typeof value == "object" && !valueIsArray;
			var i:int, prop:BaseProp, propID:String, propClass:Class;
			for ( i = 0; i < propCount; ++i )
			{
				propID = propList[i];
				propClass = classes[propID] == null ? BaseProp : classes[propID];
				prop = BaseProp(TweenMan.getPropByClass(propClass));
				props[propID] = prop;
				if (valueIsArray)
				{
					prop.value = value[i];
				}
				else if ( valueIsObject )
				{
					if (value[propID] == null) value[propID] = defaults[propID];
					prop.value = value[propID];
				}
				else
				{
					prop.value = value;
				}
				prop.id = propID;
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
			this.propList = [];
			this.current = {};
			this.defaults = {};
			this.classes = {};
		}
	}
}