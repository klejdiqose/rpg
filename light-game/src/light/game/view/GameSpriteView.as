package light.game.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import light.game.core.GameSprite;
	import light.game.core.GameStage;
	import light.game.core.coord.Translator;
	import light.game.sprite.Entity;

	/**
	 *游戏精灵的视图类 
	 * @author pig
	 * 
	 */	
	public class GameSpriteView extends Sprite
	{
		/**
		 *精灵的各帧位图 
		 * 二维数组，第一维决定精灵的方向
		 */		
		protected var frames:Array = new Array();
		protected var image:Bitmap;
		
		public function GameSpriteView(){
			image = new Bitmap();
			addChild(image);
		}

		
		/**
		 *坐标转换工具 
		 */		
		protected var coordTranslator:Translator = GameStage.Instance.gameScene.coordTranslator;
		protected var gameSprite:GameSprite;
		
		/**
		 *绑定本视图关联的游戏精灵 
		 * @param en
		 * 
		 */		
		public function bindGameSprite(en:GameSprite):void{
			gameSprite = en;
		}
		
		/**
		 *获取本视图关联的游戏精灵 
		 * @return 
		 * 
		 */		
		public function getGameSprite():GameSprite{
			return gameSprite;
		}

		/**
		 *更新视图的位置 
		 * 将3D世界的坐标转换成2D世界的坐标，并赋给视图
		 */		
		protected function updateViewPosition():void{
			var world2DPos:Point = Translator.world3DToWorld2D(gameSprite.position);
			var p:Point = gameSprite.getScene().world2DToScreen(world2DPos.x, world2DPos.y);
			x = p.x-gameSprite.centerX;
			y = p.y-gameSprite.centerY;
		}

		/**
		 *视图偏移量 
		 */		
		protected var viewMatrix:Matrix = new Matrix();
		
		public function getCoordTranslator():Translator{
			return coordTranslator;
		}
		

		/**
		 *更新视图 
		 * 游戏精灵进行逻辑运算之后，会调用该方法更新视图，子类应覆盖该方法，实现更新逻辑
		 * 
		 */
		public function update():void{
			updateViewPosition();
			image.bitmapData = frames[gameSprite.frameIndex];
		}
		
		/**
		 *初始化角色对象，在视图加入场景时自动被实行
		 * 该函数应由子类覆盖，实现初始化逻辑
		 * @param role
		 * @param finishHandler 初始化完成时回调，无参数
		 * 
		 */		
		public function init(finishHandler:Function=null):void{
		}
	}
}