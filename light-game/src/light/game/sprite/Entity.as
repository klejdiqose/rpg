package light.game.sprite
{
	import light.game.core.GameScene;
	import light.game.core.coord.Point3D;
	import light.game.view.GameSpriteView;

	public class Entity
	{
		public function Entity(scene:GameScene)
		{
			this.scene = scene;
		}
		
		public const position:Point3D = new Point3D();
		
		public var scene:GameScene;
		public var view:GameSpriteView;
		
		public function bindView(v:GameSpriteView):void{
			view = v;
		}
		
		/**
		 *获取实体的视图 
		 * @return 
		 * 
		 */		
		public function getView():GameSpriteView{
			return view;
		}
		
		/**
		 *获取当前所在的场景 
		 * @return 
		 * 
		 */		
		public function getScene():GameScene{
			return scene;
		}
	}
}