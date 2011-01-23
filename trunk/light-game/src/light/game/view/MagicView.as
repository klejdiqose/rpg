package light.game.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import light.game.core.coord.Translator;
	import light.game.sprite.Magic;
	import light.game.vo.MagicVO;
	import light.net.LoaderPool;

	public class MagicView extends GameSpriteView
	{
		private var magic:Magic;
		public function MagicView()
		{
			super();
		}
		
		//private var frames:Array = new Array();
		private var viewFrames:BitmapData;
		
		public override function init(finishHandler:Function=null):void{
			magic = gameSprite as Magic;
			var loader:Loader = LoaderPool.getLoader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
				function(e:Event):void{
					viewFrames = (loader.content as Bitmap).bitmapData;
					if(finishHandler!=null)
						finishHandler();
				});
			loader.load(new URLRequest(magic.vo.framesUrl));
		}
		
		public override function update():void{
			viewMatrix.tx = -gameSprite.frameIndex*gameSprite.width;
			updateViewPosition();
			if(viewFrames!=null)
			{
				graphics.clear();
				graphics.beginBitmapFill(viewFrames, viewMatrix);
				graphics.drawRect(0, 0, gameSprite.width, gameSprite.height);
				graphics.endFill();
			}
		}
	}
}