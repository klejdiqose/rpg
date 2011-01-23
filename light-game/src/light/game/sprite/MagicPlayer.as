package light.game.sprite
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import light.game.core.GameStage;
	import light.game.core.timer.PersistentTimer;
	import light.game.core.timer.Task;
	import light.game.vo.MagicVO;
	import light.game.vo.SingleTargetMagicVO;

	public class MagicPlayer
	{
		public function MagicPlayer()
		{
			GameStage.Instance.gameScene.sceneView.addChild(magicView);
		}
		
		public static var timer:PersistentTimer = PersistentTimer.getTimer(90);
		
		private var magicPlayTask:Task = new Task(nextStep);
		private var magicFrames:Array = new Array();
		private var magicView:Sprite = new Sprite();
		private var magic:MagicVO;
		private var index:int;
		
		public function play(m:MagicVO, handler:Function):void{
			magic = m;
			magicFrames = m.frames;
			index = 0;
		}
		
		private function nextStep():void{
			if(magicFrames==null)
				return;
			var f:BitmapData = magicFrames[index++];
			if(f==null)
				return;
			var g:Graphics = magicView.graphics;
			if(magic is SingleTargetMagicVO){
				g.clear();
				g.beginBitmapFill(f);
				g.drawRect(0, 0, f.width, f.height);
				g.endFill();
			}
			(magic as SingleTargetMagicVO).target
		}
	}
}