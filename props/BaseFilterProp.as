package com.tweenman.props
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	public class BaseFilterProp extends BaseMultiProp
	{
		protected var filterClass:Class;
		protected var initializers:Object;

		override public function init ():void
		{
			if (!(target is DisplayObject)) { tween.typeError(id, "DisplayObject"); return; }
			if (value == null) value = defaults;
			propList = [];
			var p:String;
			var initList:Object = {};
			for ( p in value )
			{
				if (defaults[p] != null)
				{
					propList.push(p);
				}
				else if (initializers[p] != null)
				{
					initList[p] = value[p];
					delete value[p];
				}
			}
			var filters:Array = target.filters;
			var filterCount:int = filters.length;
			var filterFound:Boolean = false;
			var i:int;
			for ( i = 0; i < filterCount; ++i )
			{
				if ( filters[i] is filterClass )
				{
					current = filters[i];
					filterFound = true;
				}
			}
			if (!filterFound)
			{
				current = new filterClass;
				for ( p in defaults )
				{
					current[p] = defaults[p];
				}
			}
			for ( p in initList )
			{
				current[p] = initList[p];
			}
			var valueIsArray:Boolean = value is Array;
			var valueIsObject:Boolean = typeof value == "object" && !valueIsArray;
			if (!valueIsObject) { tween.valueError(id); return; }
			super.init();
		}
		
		override public function update ($position:Number):void
		{
			super.update($position);
			var filters:Array = target.filters;
			var filterCount:int = filters.length;
			var i:int;
			for ( i = 0; i < filterCount; ++i )
			{
				if ( filters[i] is filterClass )
				{
					filters[i] = current as BitmapFilter;
					target.filters = filters;
					return;
				}
			}
			if (filters == null) filters = [];
			filters.push(current as BitmapFilter);
			target.filters = filters;
		}
		
		override public function dispose ():void
		{
			super.dispose();
			this.filterClass = undefined;
			this.initializers = undefined;
		}
	}
}