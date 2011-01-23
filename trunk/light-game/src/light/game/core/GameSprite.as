package light.game.core
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import light.game.core.GameScene;
	import light.game.core.coord.Point3D;
	import light.game.core.coord.Translator;
	import light.game.core.timer.MutexTask;
	import light.game.core.timer.PersistentTimer;
	import light.game.sprite.Entity;
	import light.game.view.GameSpriteView;
	import light.util.ObjectUtil;

	public class GameSprite extends Entity
	{
		/**
		 *精灵中心位置X
		 */
		public var centerX:uint = 100;
		/**
		 *精灵中心位置Y 
		 */		
		public var centerY:uint = 165;
		
		public static var spriteAnimationTimer:PersistentTimer = PersistentTimer.getTimer(120);

		public var id:String;
		public var width:int = 200;
		public var height:int = 200;
		public var frameIndex:int = 0;
		public var viewClass:Class;// = GameSpriteView;
	
		public var resource:BitmapLoader;
		
		public function GameSprite(scene:GameScene)
		{
			super(scene);
		}
		
		/**
		 *初始化 
		 */		
		public function init():void{
			ObjectUtil.bindGamespriteView(this, new viewClass());
			view.init(function():void{
				viewInit();
				GameStage.Instance.gameScene.sceneView.addEventListener(Event.ENTER_FRAME, function(e:Event):void{
					view.update();
				});
			});
		}

		/**
		 *当视图初始化完成之后回调 
		 * 
		 */		
		protected function viewInit():void{
			
		}
		
		/**
		 *在3D世界中移动到目的地，可选择是否修正地图位置居中 
		 * @param target
		 * @param fixMapToCenter
		 * 
		 */			
		public function moveTo3D(target:Point3D, fixMapToCenter:Boolean=false):void
		{
			if(fixMapToCenter){
				var world2D:Point = Translator.world3DToWorld2D(target);
				scene.getMap().centerTo(world2D.x, world2D.y);
			}
			position.x = target.x;
			position.y = target.y;
			position.z = target.z;
		}

	}
}