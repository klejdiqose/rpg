package light.game.net
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import light.game.view.SceneView;

	public class NetworkDispatcher
	{
		private static var instance:NetworkDispatcher = new NetworkDispatcher();
		public static function get Instance():NetworkDispatcher{
			return instance;
		}
		public function NetworkDispatcher()
		{
		}
		
		private var scene:SceneView;
		public function setScene(scene:SceneView):void{
			this.scene = scene;
		}
		public function startup():void
		{
			var t:Timer = new Timer(200, 10);
			//Math.random();
			t.addEventListener(TimerEvent.TIMER, function():void{
				scene.hero.walkBy(20, 20);
			});
			t.start();
		}
	}
}