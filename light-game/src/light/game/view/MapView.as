package light.game.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import light.game.core.GameScene;
	import light.game.core.GameSprite;
	import light.game.core.coord.Translator;
	import light.game.core.path.AStar;
	import light.game.core.path.Grid;
	import light.game.core.path.Node;
	import light.game.res.GameResource;
	import light.game.sprite.Entity;
	import light.game.sprite.Map;
	import light.game.sprite.face.IMapView;
	import light.net.LoaderPool;
	
	import mx.controls.Button;
	import mx.rpc.events.FaultEvent;
	import mx.utils.LoaderUtil;

	public class MapView extends GameSpriteView implements IMapView
	{
		//internal var backBuffer:BitmapData;
		/**
		 *精灵视图源
		 * 通过视图源的位移，实现界面的动态 
		 */		
		protected var view:Shape;
		protected var viewMask:Shape;
		
		public function MapView(){
			view = new Shape();
			addChild(view);
			viewMask = new Shape();
			view.mask = viewMask;
		}
		
		private var map:Map;
		
		public override function init(finishHandler:Function=null):void{
			//backBuffer = new BitmapData(map.imageCellCountX*map.imageCellWidth, map.imageCellCountY*map.imageCellHeight);
			super.init(finishHandler);
			viewMask.graphics.beginFill(0, 1);
			viewMask.graphics.drawRect(0, 0, map.screenWidth, map.screenHeight);
			viewMask.graphics.endFill();
			loadMap(
				function(bit:Bitmap, x:int, y:int):void{
//					var data:ByteArray = bit.bitmapData.getPixels(bit.bitmapData.rect);
//					data.position = 0;
//					backBuffer.setPixels(new Rectangle(400*x, 300*y, 400, 300), data);
					view.graphics.beginBitmapFill(bit.bitmapData);
					view.graphics.drawRect(map.imageCellWidth*x, map.imageCellHeight*y, bit.bitmapData.width, bit.bitmapData.height);
					view.graphics.endFill();
					if(finishHandler!=null)
						finishHandler();
				},
				function(msg:Object):void{
					trace("初始化地图资源时出错:"+msg);
			});
		}
		
		
		/**
		 *分块加载地图 
		 * @param mapId
		 * @param success
		 * @param fail
		 * 
		 */		
		public function loadMap(success:Function=null, fail:Function=null):void
		{
			var base:String = map.viewUrl;
			var index:int = 0;
			var t:Timer = new Timer(10, 36);
			t.addEventListener(TimerEvent.TIMER, function(e:Event):void{
				var i:int=index/6;
				var j:int=index%6;
				var url:String = base+i+"_"+j+".jpg";
				loadMapCell(url, i, j, success, fail);
				index++;
			});
			t.start();
		}
		
		public function loadMapCell(url:String, x:int, y:int, success:Function, fail:Function=null):void{
			var loader:Loader = LoaderPool.getLoader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				success(loader.content, x, y);
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				trace("加载地图失败"+e);
			});
			loader.load(new URLRequest(url));
		}
		
		[Embed("res/image/map/0/quickView.jpg")]
		private var back:Class;
		

		public override function update():void{
			view.x = -map.screenX;
			view.y = -map.screenY;
			if(map.showGrid){
				showGridLine();
			}
			else{
				if(gridView!=null)
					removeChild(gridView);
			}
		}

		public override function bindGameSprite(en:GameSprite):void{
			super.bindGameSprite(en);
			map = en as Map;
		}

		
		public function hideGridLine():void{
			if(gridView!=null)
				removeChild(gridView);
		}

		
		private var f:Shape;
		private var gridView:Sprite;
		/**
		 *显示地图栅格 
		 * 
		 */		
		public function showGridLine():void{
			if(gridView==null)
			{
				gridView = new Sprite();
				gridView.cacheAsBitmap;
				
				var sceneHeight:int = map.screenHeight;
				var sceneWidth:int = map.screenWidth;
				var gridHeight:int = map.gridHeight;
				var gridWidth:int = map.gridWidth;
				var rate:Number = gridWidth/gridHeight;
				var graphics:Graphics = gridView.graphics;
				
				graphics.lineStyle(1, 0x0055ff);
				graphics.moveTo(0, 0);
				graphics.lineTo(sceneWidth, sceneWidth/rate);
				graphics.moveTo(0, gridHeight);
				graphics.lineTo(gridWidth, 0);
				
				var star_commands:Vector.<int> = new Vector.<int>();
				var star_coord:Vector.<Number> = new Vector.<Number>();
				graphics.lineStyle(0.5, 0xdddddd);
				var cmdIndex:int = 0;
				var cooIndex:int = 0;
				var yy:Number = 0;
				for(var j:int=gridHeight;j<sceneHeight;j+=gridHeight)
				{
					star_commands.push(1);
					star_commands.push(2);
					star_commands.push(1);
					star_commands.push(2);
					star_coord.push(0);
					star_coord.push(j);
					var xx:Number = j*rate;
					if(xx>sceneWidth){
						xx -= sceneWidth;
						yy = xx/rate;
						xx = sceneWidth;
					}
					star_coord.push(xx);
					star_coord.push(yy);
					star_coord.push(0);
					star_coord.push(j);
					star_coord.push(sceneWidth);
					star_coord.push(sceneWidth/rate+j);
				}
				for(var i:int=gridWidth;i<sceneWidth;i+=gridWidth)
				{
					star_commands.push(1);
					star_commands.push(2);
					star_coord.push(i);
					star_coord.push(0);
					star_coord.push(sceneWidth);
					star_coord.push((sceneWidth-i)/rate);
				}	
				addChild(gridView);
				graphics.drawPath(star_commands, star_coord);
			}
		}
	}
}