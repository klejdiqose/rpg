package light.game.sprite
{
	import flash.geom.Point;
	
	import light.game.core.GameScene;
	import light.game.core.GameSprite;
	import light.game.core.coord.Point3D;
	import light.game.core.path.AStar;
	import light.game.core.path.Grid;
	import light.game.res.GameResource;
	import light.game.view.MapView;

	public class Map extends GameSprite
	{
		public function Map(scene:GameScene)
		{
			super(scene);
			viewClass = MapView;
		}
		
		private function initResource():void{
			//quickViewUrl = GameResource.ResMapImageRoot+mapId+"/RadarMap/0.jpg";
		}
		
		
		public var mapId:String;
		
		public var showGrid:Boolean = false;
		
		/**
		 *地图左上角原点在平面世界中的坐标偏移 
		 */		
		public var orgX:int;
		public var orgY:int;
		
		/**
		 *屏幕左上角原点在地图中的坐标偏移 
		 */		
		public var screenX:int = 0;
		public var screenY:int = 0;
		public var screenWidth:int;
		public var screenHeight:int;
		
		private var mapGrid:Grid;
		private const star:AStar = new AStar();
		
		/**
		 *网格信息 
		 */
		public var gridFromX:int = 0;
		public var gridFromY:int = 0;
		public var gridHeight:int = 30;
		public var gridWidth:int = 60;
		private var _gridSize:int = 30;
		private var gridSizeRate:Number;
		public var halfGridSize:Number;
		
		private var maxX:int;//可位移到的最宽距离
		private var maxY:int;
		
		//--资源信息--------------------------
		public var quickViewUrl:String;
		public var viewUrl:String;
		public var imageCellWidth:int = 400;
		public var imageCellHeight:int = 300;
		public var imageCellCountX:int = 6;
		public var imageCellCountY:int = 6;
		//-----------------------------
		
		
		public override function init():void{
			var halfSW:int = screenWidth>>1;
			var halfSH:int = screenHeight>>1;
			screenCenterX = (int(halfSW/gridWidth)+(halfSW%gridWidth>(gridWidth>>1)?1:0))*gridWidth;
			screenCenterY = (int(halfSH/gridHeight)+(halfSH%gridHeight>(gridHeight>>1)?1:0))*gridHeight;
			maxX = (width-screenWidth) - (width-screenWidth)%gridWidth;
			maxY = (height-screenHeight) - (height-screenHeight)/gridHeight;
			
			var size:int = Math.sqrt(height*height*5)/gridSize;
			mapGrid = new Grid(size, size);
			initResource();
			super.init();
		}
		
		protected override function viewInit():void{
			
		}
		
		public function get gridSize():int{
			return _gridSize;
		}
		public function set gridSize(size:int):void{
			_gridSize = size;
			gridSizeRate = 1/gridSize;
			halfGridSize = size*0.5;
		}
		
		public var screenCenterX:Number;
		public var screenCenterY:Number;
		/**
		 *调整地图位置，使之以目的坐标为中心（大约值） 
		 * @param x
		 * @param y
		 * 
		 */		
		public function centerTo(x:Number, y:Number):void{
			
			this.screenX = x-orgX-screenCenterX;
			this.screenY = y-orgY-screenCenterY;//screenHeight/2;
			if(this.screenX<0)
				this.screenX = 0;
			else if(this.screenX>maxX)
				this.screenX = maxX;
			if(this.screenY<0)
				this.screenY = 0;
			else if(this.screenY>maxY)
				this.screenY = maxY;
		}

		
		public function showAround(x:int, y:int):void{
			
		}
		
		private function getMapCoordCellAround(x:int, y:int):Vector.<Point>{
			var res:Vector.<Point> = new Vector.<Point>(4);
			return res;
		}
		
		/**
		 *寻路，返回路径的网格坐标 
		 * @param from
		 * @param target
		 * @return 
		 * 
		 */		
		public function findPath3D_Grid(from:Point3D, target:Point3D):Array{
			mapGrid.setStartNode(int(from.x*gridSizeRate), int(from.y*gridSizeRate));
			mapGrid.setEndNode(int(target.x*gridSizeRate), int(target.y*gridSizeRate));
			star.findPath(mapGrid);
			return star.path;
		}
		
		/**
		 * 寻路，返回路径的像素坐标 
		 * @param from
		 * @param target
		 * @return 
		 * 
		 */		
		public function findPath3D_Pixel(from:Point3D, target:Point3D):Array{
			var path:Array = findPath3D_Grid(from, target);
			var p:Array = new Array();
			for each(var pos:Object in path){
				p.push(new Point3D(pos.x*gridSize+halfGridSize, pos.y*gridSize+halfGridSize, 0));
			}
			return p;
		}

	}
}