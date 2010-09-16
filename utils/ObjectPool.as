package com.tweenman.utils
{
	public class ObjectPool
	{
		var Reusable:Class;
		var length:int = 0;
		var list:Array = [];
		
		public function ObjectPool (Reusable:Class)
		{
			this.Reusable = Reusable;
		}
		
		public function add ():void
		{
			list[length++] = new Reusable();
		}
		
		public function acquire ():*
		{
			if (length == 0) return new Reusable();
			return list[--length];			
		}
		
		public function release (obj:Object):void
		{
			list[length++] = obj;
		}
		
		public function empty ():void
		{
			length = list.length = 0;
		}
	}
}