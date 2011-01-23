package light.game.res
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	
	import light.game.sprite.Map;

	public class MapLoader
	{
		public function MapLoader(map:Map)
		{
			this.map = map;
		}
		
		private var map:Map;
		
		private var quickView:Bitmap;
		
		public function loadQuickView(handler:Function):void{
			var quickImagePath:String = GameResource.ResMapImageRoot+map.mapId+"/RadarMap/0.jpg";
			var loader:Loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
		}
	}
}