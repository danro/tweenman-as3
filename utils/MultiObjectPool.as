package com.tweenman.utils
{
	import flash.utils.Dictionary;
	
	public class MultiObjectPool
	{
		private var pools:Dictionary;
		
		public function MultiObjectPool (reusables:Object)
		{
			pools = new Dictionary(true);
			var Type:Class;
			for each (Type in reusables) add(Type);
		}
		
		public function add (Type:Class):void
		{
			pools[Type] = new ObjectPool(Type);
		}
		
		public function acquire (Type:Class):*
		{
			return ObjectPool(pools[Type]).acquire();
		}
		
		public function release (obj:Object):void
		{
			ObjectPool(pools[obj.constructor]).release(obj);
		}
		
		public function empty ():void
		{
			var pool:ObjectPool;
			for each(pool in pools) pool.empty();
		}
	}
}