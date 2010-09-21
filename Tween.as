package com.tweenman
{
	import flash.utils.getTimer;
	import com.tweenman.props.BaseProp;
	
	public class Tween
	{
		internal static const ZERO:Number = 0.001;
		
		internal var id:String;
		internal var target:Object;
		internal var duration:Number;
		internal var delay:Number;
		internal var vars:Object;
		internal var ease:Function;
		internal var props:Object;
		internal var children:int;
		internal var activated:Boolean;
		internal var startTime:int;
		internal var initTime:int;
		internal var timerMode:Boolean;
		
		public function Tween () {}

		internal function init ($target:Object, $vars:Object, $id:String):void
		{
			this.target = $target;
			this.vars = $vars;
			this.id = $id;
			this.children = 0;
			this.timerMode = true;
			if (!isNaN(this.vars.time)) this.vars.duration = this.vars.time;
			this.duration =  this.vars.duration;
			this.delay = this.vars.delay;
			if (isNaN(this.delay) || this.delay < 0) this.delay = 0;
			if (!isNaN(this.vars.frames))
			{
				this.timerMode = false;
				this.duration = int(this.vars.frames);
				this.delay = int(this.delay);
			}
			if (isNaN(this.duration) || this.duration <= 0) this.duration = ZERO;
			if (this.vars.ease is String) this.vars.ease = Easing[this.vars.ease];
			this.ease = this.vars.ease is Function ? this.vars.ease : TweenMan.defaultEase;
			if (this.vars.easeParams != null)
			{
				this.vars.proxiedEase = this.ease;
				this.ease = easeProxy;
			}
			this.props = {};
			this.initTime = this.timerMode ? getTimer() : TweenMan.getFrames();
			this.activated = false;
			initProps();
			if (this.duration == ZERO && this.delay == 0)
			{
				this.startTime = 0;
				render(1, 1);
			}
			else
			{
				TweenMan.addToRender(this);
			}
		}

		internal function isActive ($t:int, $f:int):Boolean
		{
			if (this.activated)
			{
				return true;
			}
			else
			{
				if (this.timerMode)
				{
					if (($t - this.initTime) / 1000 > this.delay)
					{
						this.activated = true;
						this.startTime = this.initTime + (this.delay * 1000);
						if (this.vars.onStart != null) this.vars.onStart.apply(null, this.vars.onStartParams);
						if (this.duration == ZERO) this.startTime -= 1;
						return true;
					}
				}
				else
				{
					if ($f - this.initTime > this.delay)
					{
						this.activated = true;
						this.startTime = this.initTime + this.delay;
						if (this.vars.onStart != null) this.vars.onStart.apply(null, this.vars.onStartParams);
						if (this.duration == ZERO) this.startTime -= 1;
						return true;
					}
				}
			}
			return false;
		}

		internal function render ($t:int, $f:int):void
		{
			var elapsed:Number = this.timerMode ? ($t - this.startTime) / 1000 : $f - this.startTime;
			if (elapsed > this.duration) elapsed = this.duration;
			var position:Number = this.ease(elapsed, 0, 1, this.duration);
			for each (var prop:BaseProp in this.props)
			{
				prop.update(position);
			}
			if (this.vars.onUpdate != null) this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
			if (elapsed == this.duration)
			{
				TweenMan.completeTween(this, this.vars.onComplete, this.vars.onCompleteParams);
			}
		}

		internal function removeProp ($p:String):Boolean
		{
			if (this.props[$p] == null)
			{
				return false;
			}
			else
			{
				--this.children;
				delete this.props[$p];
				return true;
			}
		}

		internal function dispose ():void
		{
			this.id = undefined;
			this.target = undefined;
			this.duration = undefined;
			this.delay = undefined;
			this.vars = undefined;
			this.ease = undefined;
			this.props = undefined;
			this.children = undefined;
			this.activated = undefined;
			this.startTime = undefined;
			this.initTime = undefined;
			this.timerMode = undefined;
		}

		public function typeError ($p:Object, $type:String):void
		{
			trace("TweenMan says: target must be type [" + $type + "] to use [" + $p + "]");
			removeProp(String($p));
		}

		public function valueError ($p:Object):void
		{
			trace("TweenMan says: unexpected value given for " + this.target + "[" + $p + "]");
			removeProp(String($p));
		}

		private function initProps():void
		{
			var prop:BaseProp;
			var p:String;
			for (p in this.vars)
			{
				if (Config.internalProps[p] != null) continue;
				var propClass:Class;
				if (Config.virtualProps[p] != null)
				{
					propClass = Config.virtualProps[p];
				}
				else if (this.target[p] != null)
				{
					propClass = BaseProp;
				}
				if (propClass != null)
				{
					++this.children;
					prop = TweenMan.propertyPool.acquire(propClass);
					this.props[p] = prop;
					prop.id = p;
					prop.tween = this;
					prop.target = this.target;
					prop.value = this.vars[p];
					prop.init();
				}
				else
				{
					trace("TweenMan says: target [" + this.target + "] does not contain property [" + p + "]");
				}
			}
		}

		private function easeProxy (...$params:Array):Number
		{
			return this.vars.proxiedEase.apply(null, $params.concat(this.vars.easeParams));
		}
	}
}