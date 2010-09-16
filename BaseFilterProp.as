package com.tweenman {

	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;

	public class BaseFilterProp extends MultiProp {

		protected var filterClass:Class;
		protected var initializers:Object;

		override function init () {
			if (!(target is DisplayObject)) return tween.typeError(id, "DisplayObject");
			if (value == null) value = defaults;
			propList = [];
			var p:String;
			var initList:Object = {};
			for ( p in value ) {
				if (defaults[p] != null) {
					propList.push(p);
				} else if (initializers[p] != null) {
					initList[p] = value[p];
					delete value[p];
				}
			}
			var filters:Array = target.filters;
			var filterCount:int = filters.length;
			var filterFound:Boolean = false;
			var i:int;
			for ( i = 0; i < filterCount; i++ ) {
				if ( filters[i] is filterClass ) {
					current = filters[i];
					filterFound = true;
				}
			}
			if (!filterFound) {
				current = new filterClass;
				for ( p in defaults ) {
					current[p] = defaults[p];
				}
			}
			for ( p in initList ) {
				current[p] = initList[p];
			}
			var valueIsArray:Boolean = value is Array;
			var valueIsObject:Boolean = typeof value == "object" && !valueIsArray;
			if (!valueIsObject) return tween.valueError(id);
			super.init();
		}

		override function update ($position) {
			super.update($position);
			var filters:Array = target.filters;
			var filterCount:int = filters.length;
			var i:int;
			for ( i = 0; i < filterCount; i++ ) {
				if ( filters[i] is filterClass ) {
					filters[i] = current as BitmapFilter;
					target.filters = filters;
					return;
				}
			}
			if (filters == null) filters = [];
			filters.push(current as BitmapFilter);
			target.filters = filters;
		}
	}
}