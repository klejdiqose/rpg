package light.game.view
{
	import flash.display.Bitmap;

	public class SimpleAnimationView extends GameSpriteView
	{
		[Embed("res/image/item/1.png")]
		private static var TargetImageClass:Class;
		private var static var walkTargetData:Bitmap = new TargetImageClass();
		
		public function SimpleAnimationView()
		{
			super();
		}
		
		public override function init(finishHandler:Function=null):void{
					
		}
	}
}