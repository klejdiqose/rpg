package light.game.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Scene;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import light.game.core.path.Pathfinding;
	import light.game.net.GameClient;
	import light.game.net.NetworkDispatcher;
	import light.game.res.GameResource;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	
	import spark.primitives.Graphic;
	
	public class SceneView extends GameSpriteView
	{	
		private var _hero:RoleView = new RoleView();
		public function get hero():RoleView{return _hero;}
		
		
		private var gridHeight:int = 15;
		private var gridWidth:int = gridHeight*2;
		
		public var centerGridPosition:Point;
		
		//private var map:MapView;
		
		public function SceneView()
		{
			//var map:MapView = new MapView(this);
//			map.showGridLine();
//			map.load();
			centerGridPosition = countGridPosition(width/2, height/2);
				
			addChild(_hero);
			//hero.walkTo(width/2, height/2);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
			//addChild(new Pathfinding());
		}

		private function onMouseClick(e:MouseEvent):void{
			var target:Point = countGridPosition(mouseX, mouseY);
			//trace("init", hero.centerX, hero.centerY, mouseX, mouseY);
			//map.run(hero);
			
		}
		
		/**
		 *计算最接近的栅格中心点 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public function countGridPosition(x:Number, y:Number):Point{
			return new Point(int(x/gridWidth)*gridWidth+gridWidth/2, int(y/gridHeight)*gridHeight+gridHeight/2);
		}
		
//		public function setMap(map:MapView):void {
//			this.map = map;
//			addChild(map);
//		}
		
		//public function 
	}
}