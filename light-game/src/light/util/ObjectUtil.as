package light.util
{
	import light.game.core.GameSprite;
	import light.game.sprite.Entity;
	import light.game.view.GameSpriteView;

	public class ObjectUtil
	{
		public function ObjectUtil()
		{
		}
		
		public static function merge(target:Object, src:Object):void
		{
			for(var prop:String in src)
			{
				target[prop] = src[prop];
			}
		}
		
		public static function bindGamespriteView(entity:GameSprite, view:GameSpriteView):void{
			view.bindGameSprite(entity);
			entity.bindView(view);
		}
	}
}