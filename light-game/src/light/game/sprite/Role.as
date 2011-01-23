package light.game.sprite
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import light.game.core.GameScene;
	import light.game.core.GameSprite;
	import light.game.core.coord.Point3D;
	import light.game.core.coord.Translator;
	import light.game.core.timer.MutexTask;
	import light.game.core.timer.PersistentTimer;
	import light.game.view.RoleView;
	import light.util.ObjectUtil;

	public class Role extends GameSprite
	{
		//--------------
		public static const Up:int = 0x0;
		public static const UpRight:int = 0x1;
		public static const Right:int = 0x2;
		public static const DownRight:int = 0x3;
		public static const Down:int = 0x4;
		public static const DownLeft:int = 0x5;
		public static const Left:int = 0x6;
		public static const UpLeft:int = 0x7;
		
		public static const Walking:int = 1;
		public static const Standing:int = 0;
		public static const Riding:int = 2;
		////////////////
		
		//--------------
		public var staticFramesCount:int;
		public var staticFramesUrl:String;
		public var staticFrameStartIndex:int;
		public var staticFrameEndIndex:int;
		
		public var walkFramesCount:int;
		public var walkFramesUrl:String;
		public var walkFrameStartIndex:int;
		public var walkFrameEndIndex:int;
				
		public var upIndex:int = 0
		public var upRightIndex:int = 1
		public var rightIndex:int = 2
		public var downRightIndex:int = 3
		public var downIndex:int = 4
		public var downLeftIndex:int = 5
		public var leftIndex:int = 6
		public var upLeftIndex:int = 7
		//---------------
		
		public static var walkTimer:PersistentTimer = PersistentTimer.getTimer(30);
		protected var animationTask:MutexTask;
		protected var walkTask:RoleWalkTask;
		
		/**
		 *direction属性的值为角色方向常数（在Role类中定义） 
		 */		
		public var direction:int;
		public var status:int = Standing;
		public var bodyHeight:int;
		
		/**
		 *姓名 
		 */		
		public var name:String;
		/**
		 *帮会 
		 */		
		public var groupName:String;
		/**
		 *门派 
		 */		
		public var factionName:String;
		
		public var faceUrl:String;
		public var level:int;
	
		
		public function Role(scene:GameScene)
		{
			super(scene);
			viewClass = RoleView;
		}
		
		/**
		 *初始化 
		 */
		protected override function viewInit():void{
			animationTask = new MutexTask();
			animationTask.addMutexFunction("walk", playWalkAction);
			animationTask.addMutexFunction("static", playStaticAction);
			animationTask.activate("static");
			spriteAnimationTimer.addTask(animationTask);
			
			walkTask = new RoleWalkTask(this);
			walkTimer.addTask(walkTask);
		}
		
		/**
		 *根据位移的值计算位移方向，返回角色方向常熟（在Role类中定义） 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public function detectDirection(x:int, y:int):int{
			if(y>0){
				if(x==0)
					return 5;
				else if(x>0)
					return 4;
				else
					return 6;
			}
			if(y<0){
				if(x==0)
					return 1;
				else if(x>0)
					return 2;
				else
					return 0
			}
			if(y==0){
				return x>0?3:7;
			}
			return 0;
		}


		/**
		 *在3D世界中行走到目的地 
		 * (自动计算平滑路径)
		 * @param target
		 * 
		 */	
		public function walkTo3D(target:Point3D):void
		{
			walkTask.walk(scene.getMap().findPath3D_Pixel(position, target));
		}
		
		
		private function playStaticAction():void
		{
			frameIndex++;
			if(frameIndex<staticFrameStartIndex || frameIndex>staticFrameEndIndex)
				frameIndex = staticFrameStartIndex;
		}

		private function playWalkAction(e:Event=null):void
		{
			frameIndex++;
			if(frameIndex<walkFrameStartIndex || frameIndex>(walkFrameEndIndex))
				frameIndex = walkFrameStartIndex;
		}
		
		/**
		 *切换到静止状态 
		 * 
		 */		
		public function switchToStaticStatus():void{
			status = Standing;
			animationTask.activate("static");
		}
		
		/**
		 *切换到行走状态 
		 * 
		 */		
		public function switchToWalkStatus():void{
			status = Walking;
			animationTask.activate("walk");
		}
	}
}