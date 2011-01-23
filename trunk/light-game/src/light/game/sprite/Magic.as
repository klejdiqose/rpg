package light.game.sprite
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import light.game.core.GameScene;
	import light.game.core.GameSprite;
	import light.game.view.MagicView;
	import light.game.vo.MagicVO;
	import light.net.LoaderPool;

	public class Magic extends GameSprite
	{
		public var target:GameSprite;
		public var source:GameSprite;
		public var vo:MagicVO;
		
		public function Magic(scene:GameScene, vo:MagicVO)
		{
			super(scene);
			viewClass = MagicView;
			this.vo = vo;
			this.centerX = vo.centerX;
			this.centerY = vo.centerY;
			this.width = vo.width;
			this.height = vo.height;
		}
		
		protected override function viewInit():void{
			view.init(play);
		}
		
		public function play(handler:Function=null):void{
			var t:Timer = new Timer(80);
			t.addEventListener(TimerEvent.TIMER, function(e:Event):void{
				position.moveToPosition(target.position);
				frameIndex++;
				//trace(frameIndex);
				view.update();
				if(frameIndex==vo.frameCount){
					view.visible = false;
					t.stop();
				}
			});
			t.start();
		}
	}
}