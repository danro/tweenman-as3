package com.tweenman {
	
	public class ArrayProp extends BaseProp {

		protected var props:Object = {};
		protected var current:Array;

		override function init () {
			if (current == null) {
				if (target is Array) {
					current = target;
				} else if (target[id] is Array) {
					current = target[id];
				}
			}
			var valueIsArray:Boolean = value is Array;
			if (!valueIsArray) return tween.valueError(id);
			var count:int = current.length;
			var i:int, prop:BaseProp;
			for ( i = 0; i < count; i++ ) {
				prop = new BaseProp;
				props[ String(i) ] = prop;
				prop.id = i;
				prop.value = value[i];
				prop.target = current;
				prop.init();
			}
		}

		override function update ($position) {
			var prop:BaseProp;
			for each (prop in props) {
				prop.update($position);
			}
		}
	}
}