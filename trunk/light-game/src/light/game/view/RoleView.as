package light.game.view
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import light.game.core.BitmapLoader;
	import light.game.core.GameSprite;
	import light.game.core.GameStage;
	import light.game.core.coord.Translator;
	import light.game.core.timer.MutexTask;
	import light.game.core.timer.PersistentTimer;
	import light.game.res.GameResource;
	import light.game.res.ResEvent;
	import light.game.sprite.Entity;
	import light.game.sprite.Magic;
	import light.game.sprite.Role;
	import light.game.sprite.face.IRoleView;
	import light.net.LoaderPool;
	import light.util.ObjectUtil;
	import light.util.StringUtil;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.controls.Image;
	
	import spark.primitives.Rect;
	
	public class RoleView extends GameSpriteView implements IRoleView
	{	
		//--------------
		public static const Up:uint = 0x0;
		public static const UpRight:uint = 0x1;
		public static const Right:uint = 0x2;
		public static const DownRight:uint = 0x3;
		public static const Down:uint = 0x4;
		public static const DownLeft:uint = 0x5;
		public static const Left:uint = 0x6;
		public static const UpLeft:uint = 0x7;
		////////////////
		
		
		
		[Embed("res/image/role/0/0-0.png")]
		private static var ImageX:Class;
		private static var defaultBodyImage:BitmapData = (new ImageX() as Bitmap).bitmapData;
		
		private var role:Role;
		protected var currentDirectionFrames:Array;
		/**
		 *记录上一帧角色的方向，当方向和目前方向不同时，需要更新currentDirectionFrames的内容 
		 */		
		protected var lastDirection:int = -1;

		/**
		 *角色状态显示 
		 */		
		private var roleStatus:TextField;
		
		public function RoleView()
		{
			super();
			addEventListener(MouseEvent.CLICK, function(e:Event):void{
				var m:Magic = new Magic(gameSprite.getScene(), GameStage.Instance.gameScene.toolbar.rightHandMagic);
				m.target = role;
				gameSprite.getScene().addGameSprite(m);
				var at:AttackPoint = new AttackPoint(1000, role);
			});
		}
		
		public override function init(finishHandler:Function=null):void{
			super.init(finishHandler);
			showStatus()
			var isInit:Boolean = false;
			
			var staticFramesImage:BitmapLoader = new BitmapLoader(role.staticFramesUrl);
			staticFramesImage.frameHeight = role.height;
			staticFramesImage.frameWidth = role.width;
			staticFramesImage.frameCountX = role.staticFramesCount;
			staticFramesImage.frameCountY = 8;
			staticFramesImage.start();
			
			var loader:Loader = LoaderPool.getLoader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				var staticBodyFrames:BitmapData = (loader.content as Bitmap).bitmapData;
				var screate:Boolean = false;
				for(var sy:int=0;sy<8;sy++){
					var datas:Array = frames[sy];
					if(datas==null){
						datas = new Array();
						screate = true;
					}
					var sm:Matrix = new Matrix();
					for(var sx:int=0;sx<role.staticFramesCount;sx++){
						var sd:BitmapData = new BitmapData(role.width, role.height, true, 0);
						sm.tx = -sx*role.width;
						sm.ty = -sy*role.height;
						sd.draw(staticBodyFrames, sm);
						datas[role.staticFrameStartIndex+sx] = sd;
					}
					frames[sy] = datas;
				}
				if(isInit)
				{
					if(finishHandler!=null)
						finishHandler();
				}
				else
					isInit = true;
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				Alert.show('加载角色静态资源失败'+e);
			});
			loader.load(new URLRequest(role.staticFramesUrl));
			
			var wloader:Loader = LoaderPool.getLoader();
			wloader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				var walkingBodyFrames:BitmapData = (wloader.content as Bitmap).bitmapData;
				var wcreate:Boolean = false;
				for(var wy:int=0;wy<8;wy++){
					var wdatas:Array = frames[wy];
					if(wdatas==null){
						wdatas = new Array();
						wcreate = true;
					}
					var wm:Matrix = new Matrix();
					for(var wx:int=0;wx<role.walkFramesCount;wx++){
						var wd:BitmapData = new BitmapData(role.width, role.height, true, 0);
						wm.tx = -wx*role.width;
						wm.ty = -wy*role.height;
						wd.draw(walkingBodyFrames, wm);
						wdatas[role.walkFrameStartIndex+wx] = wd;
					}
					if(wcreate)
						frames[wy] = wdatas;
				}
				if(isInit)
				{
					if(finishHandler!=null)
						finishHandler();
				}
				else
					isInit = true;
			});
			wloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				Alert.show('加载角色行走资源失败'+e);
			});
			wloader.load(new URLRequest(role.walkFramesUrl));
			
		}

		
		public override function update():void{
			updateViewPosition();
			if(currentDirectionFrames==null){
				currentDirectionFrames = frames[role.direction];
				lastDirection = role.direction;
			}
			else{
				if(lastDirection!=role.direction){
					currentDirectionFrames = frames[role.direction];
					lastDirection = role.direction;
				}
			}
			if(currentDirectionFrames!=null)
				image.bitmapData = currentDirectionFrames[role.frameIndex];
		}
		
		public override function bindGameSprite(en:GameSprite):void{
			super.bindGameSprite(en);
			role = en as Role;
		}
		
		public function showStatus():void{
			roleStatus = new TextField();
			roleStatus.selectable = false;
			var tf:TextFormat = new TextFormat();
			tf.leading = 3;
			tf.align = TextFormatAlign.CENTER;
			var text:String = '';
			if(!StringUtil.isEmpty(role.factionName))
				text += role.factionName;
			if(!StringUtil.isEmpty(role.groupName))
				text += '\n[帮会]'+role.groupName;
			
			roleStatus.text = text+'\n'+role.name;
			tf.bold = true;
			tf.color = 0xffa500;
			var currentIndex:int = 0;
			if(!StringUtil.isEmpty(role.factionName)){
				currentIndex = role.factionName.length;
				roleStatus.setTextFormat(tf, 0, currentIndex);
			}
			
			if(!StringUtil.isEmpty(role.groupName)){
				tf.color = 0x60f388;
				roleStatus.setTextFormat(tf, currentIndex+1, (currentIndex = currentIndex+4+role.groupName.length+1, currentIndex));
			}
			
			tf.color = 0x0000ff;
			roleStatus.setTextFormat(tf, currentIndex+1, (currentIndex = currentIndex+role.name.length+1, currentIndex));
			
			addChild(roleStatus);
			roleStatus.x = role.centerX-roleStatus.width/2;
			roleStatus.y = role.centerY-role.bodyHeight-roleStatus.textHeight-5;
		}

		public function hideStatus():void{
			removeChild(roleStatus);
			roleStatus = null;
		}
	}
	
}
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import light.game.sprite.Role;

import mx.controls.Image;

class RoleStatusPanel extends Sprite{
	//public var playerName:TextField;
	//public var health:Shape;
	
	public function RoleStatusPanel(role:Role){

		var name:TextField = new TextField();
		name.selectable = false;
		var tf:TextFormat = new TextFormat();
		tf.align = TextFormatAlign.CENTER;
		name.text = role.factionName+'\n[帮会]'+role.groupName+'\n'+role.name;
		tf.bold = true;
		tf.color = 0x123;
		name.setTextFormat(tf, 0, 3);
		
		tf.color = 0x123;
		tf.color = 0x0000ff;
		name.setTextFormat(tf, 3, name.length);

		addChild(name);
		
	}
	
	public function init():void{
		
	}
}