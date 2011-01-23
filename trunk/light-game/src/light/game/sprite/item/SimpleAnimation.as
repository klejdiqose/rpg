package light.game.sprite.item
{
	import light.game.core.GameScene;
	import light.game.core.GameSprite;
	
	public class SimpleAnimation extends GameSprite
	{
		public var itemId:String;
		
		public function SimpleAnimation(scene:GameScene, itemId:String)
		{
			super(scene);
		}
	}
}