package light.game.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import light.game.core.coord.Point3D;
	import light.game.core.coord.Translator;
	import light.game.core.path.Node;
	import light.game.res.GameResource;
	import light.game.sprite.Hero;
	import light.game.sprite.Magic;
	import light.game.sprite.Map;
	import light.game.sprite.NPC;
	import light.game.sprite.Role;
	import light.game.view.StatusBarView;
	import light.game.view.MapView;
	import light.game.view.RoleView;
	import light.game.view.SceneView;
	import light.util.ObjectUtil;
	import light.util.SceneLoaderUtil;
	
	import mx.controls.Button;

	public class GameScene
	{
		public var sprites:Vector.<GameSprite> = new Vector.<GameSprite>(false);
		
		public var hero:Hero;
		public var map:Map;
		
		public var screenWidth:int;
		public var screenHeight:int;
		
		public var toolbar:Toolbar = new Toolbar();
		public var headerBar:light.game.core.StatusBar = new light.game.core.StatusBar();
		
		public const sceneView:Sprite = new Sprite();
		public var coordTranslator:Translator;
		
		public function GameScene()
		{
		}
		
		public function loadFromXML(config:XML):void{
			map = new Map(this);
			//加载临时数据
			toolbar.loadFromXML(config);
			var screen:XMLList = config.screen;
			screenWidth = Number(screen.attribute("width"));
			screenHeight = Number(screen.attribute("height"));
			map.screenX = screen.attribute("x");
			map.screenY = screen.attribute("y");
			
			var mapXML:XMLList = config.map;
			map.mapId = mapXML.attribute("id");
			map.orgX = mapXML.attribute("orgX");
			map.orgY = mapXML.attribute("orgY");
			map.width = Number(mapXML.attribute("width"));
			map.height = Number(mapXML.attribute("height"));
			map.quickViewUrl = mapXML.qiuckViewUrl;
			map.viewUrl = mapXML.viewUrl.toString();
			map.screenWidth = screenWidth;
			map.screenHeight = screenHeight;
			map.imageCellCountX = mapXML.attribute("cellCountX");
			map.imageCellCountY = mapXML.attribute("cellCountY");
			map.imageCellWidth = mapXML.attribute("cellWidth");
			map.imageCellHeight = mapXML.attribute("cellHeight");
			map.gridSize = mapXML.attribute("gridSize");
			
			var rXML:XMLList = config.hero;
			hero = new Hero(this);
			//角色基础信息
			SceneLoaderUtil.loadSpriteInfo(hero, rXML);
			
			//读取精灵列表
			var spritesConfig:XMLList = config.sprites.npc;
			for each(var s:XML in spritesConfig){
				var n:NPC = new NPC(this);
				SceneLoaderUtil.loadSpriteInfo(n, s);
				sprites.push(n);
			}
		}
		
		public function init():void{
			
			sceneView.addEventListener(MouseEvent.CLICK, onMouseClicked);
			
			addGameSprite(map);
			addGameSprite(hero);
			hero.moveTo3D(hero.position, true);
			for each(var s:GameSprite in sprites){
				addGameSprite(s);
			}
		}
		
		/**
		 *添加游戏精灵 
		 * @param sprite
		 * 
		 */		
		public function addGameSprite(sprite:GameSprite):void{
			sprite.init();
			sceneView.addChild(sprite.getView());
		}
		public function removeGameSprite(sprite:GameSprite):void{
			sceneView.removeChild(sprite.getView());
		}
		
		/**
		 *添加可视对象 
		 * @param obj
		 * 
		 */		
		public function addDisplayObject(obj:DisplayObject):void{
			sceneView.addChild(obj);
		}
		
		public function removeDisplayObject(obj:DisplayObject):void{
			sceneView.removeChild(obj);
		}
		
		private function onMouseClicked(e:Event):void{
			
			var globalDimentionPos:Point = screenToWorld2D(sceneView.mouseX, sceneView.mouseY);
			var targetPos:Point3D = Translator.world2DToWorld3D(globalDimentionPos);
			hero.walkTo3D(targetPos);
		}
		
		public function getMap():Map{
			return map;
		}
		
		public function getHero():Role{
			return hero;
		}
		
		/**
		 *平面世界坐标转换成屏幕坐标
		 * （先转换成全局地图坐标，然后将全局地图坐标转换成屏幕坐标） 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */				
		public function world2DToScreen(x:Number, y:Number):Point{
			return Translator.world2DToScreen(map, x, y);
		}
		
		/**
		 *屏幕坐标转换成平面世界坐标
		 * （先转换成全局地图坐标，然后将全局地图坐标转换成世界坐标）
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public function screenToWorld2D(x:Number, y:Number):Point{
			return Translator.screenToWorld2D(map, x, y);
		}
		
	}
}