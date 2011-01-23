package light.game.res
{
	import com.adobe.serialization.json.JSON;
	
	import entity.Entity;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import light.game.view.RoleView;
	import light.util.Bind;
	
	import mx.controls.Alert;

	public class GameResource
	{
		public static const ResRoleImageRoot:String = "res/image/role/";
		public static const ResMapImageRoot:String = "res/image/map/";
		
		public function GameResource()
		{
		}
		
		public static const Instance:GameResource = new GameResource();
		
		//private var commonResLoader:Loader = new Loader();
		private var commonFileLoader:URLLoader = new URLLoader();
		
				  
		
		
		public function loadMapCell(url:String, x:int, y:int, success:Function, fail:Function=null):void{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				trace("success", x, y);
				success(loader.content, x, y);
			});
			loader.load(new URLRequest(url));
		}
		
		/**
		 *读取角色配置信息 
		 * @param roleId
		 * @param success
		 * @param fail
		 * 
		 */		
		public function loadRoleConfig(roleId:String, success:Function=null, fail:Function=null):void
		{
			commonFileLoader.addEventListener(Event.COMPLETE, function(e:Event):void{
				if(success!=null)
					success(Entity.decode(commonFileLoader.data as String));
			});
			commonFileLoader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:IOErrorEvent):void{
				if(fail!=null)
					fail(ev.toString());
			});
			commonFileLoader.load(new URLRequest(ResRoleImageRoot+roleId+"/config.ini"));
		}
		
		/**
		 * 加载角色身体图片资源
		 */
		public function loadRoleWalkBodyImage(roleId:String, direction:uint, success:Function=null, fail:Function=null):void
		{
			var url:String = ResRoleImageRoot+roleId+"/walkFrames.png";
			loadResource(url, success, fail);
		}
		
		/**
		 * 加载角色身体图片资源
		 */
		public function loadRoleStaticBodyImage(roleId:String, direction:uint, success:Function=null, fail:Function=null):void
		{
			var url:String = ResRoleImageRoot+roleId+"/staticFrames.png";
			loadResource(url, success, fail);
		}
		
		/**
		 * 低级资源加载接口
		 */
		public function loadResource(url:String, success:Function=null, fail:Function=null, attachment:Object=null):void
		{
			trace("load res: "+url);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				if(success!=null)
				{
					if(attachment!=null)
						success(loader.content, attachment);
					else
						success(loader.content);
				}
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(ev:IOErrorEvent):void{
				if(fail!=null)
				{
					if(attachment!=null)
						fail(ev.toString(), attachment);
					else
						fail(ev.toString());
				}
			});
			loader.load(new URLRequest(url));
		}
	}
}