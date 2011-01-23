package light.game.core
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import light.common.Callback;
	import light.net.LoaderPool;
	
	import mx.controls.Alert;

	public class GameStage
	{
		public const gameScene:GameScene = new GameScene();
		public function get flexStage():Stage{
			if(gameScene.sceneView==null)
				return null;
			return gameScene.sceneView.stage;
		}
		public static const Instance:GameStage = new GameStage();
		
		public function GameStage()
		{
			loadCurrentScene(onSceneLoad);
		}
		
		public var onLoad:Function;
		
		/**
		 *加载初始场景 
		 * @param handler
		 * @param attachment
		 * 
		 */		
		public function loadCurrentScene(handler:Function, attachment:Object=null):void
		{
			var loader:URLLoader = LoaderPool.getUrlLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event):void{
				handler(new Callback(true, loader.data));
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				handler(new Callback(false, e));
			});
			loader.load(new URLRequest('res/config/scene/entry-scene.xml'));
		}
		
		private var spritesMap:Dictionary = new Dictionary(true);
		private function onSceneLoad(e:Callback):void{
			if(e.success){
				
				var s:XML = new XML(e.content as String);
				var rolesList:XMLList = s.roles.role;
				
				//简历角色id映射
				for each(var r:XML in rolesList){
					spritesMap[r.attribute("id").toString()] = r;
				}
				
//以下操作本应在服务端进行，为了方便测试，暂放在此--------------------------------------
				//构造完整的hero配置------------
				var hero:XMLList = s.hero;
				var rConfig:XML = spritesMap[hero.attribute("roleId").toString()];
				if(rConfig!=null)
					hero.appendChild(rConfig);
				else
					Alert.show("找不到该角色ID："+hero.attribute("roleId").toString());
				
				//构造完整的npc配置------------------------
				var sprites:XMLList = s.sprites.npc;
				for each(var n:XML in sprites){
					var nConfig:XML = spritesMap[n.attribute("roleId").toString()];
					if(nConfig)
						n.appendChild(nConfig);
				}
//--------------------------------------------------------------------------------------
				
				
				gameScene.loadFromXML(s);
				gameScene.init();
				if(onLoad!=null)
					onLoad();
			}
			else{
				Alert.show(e.errorInfo.toString());
			}
		}
	}
}