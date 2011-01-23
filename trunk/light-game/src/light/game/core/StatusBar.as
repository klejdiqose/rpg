package light.game.core
{
	import light.game.view.StatusBarView;
	
	import mx.core.UIComponent;

	public class StatusBar implements GameStageComponent
	{
		
		public var view:StatusBarView;
		
		/**
		 *经验值 
		 */		
		public var expPoint:Number;
		public var maxExpPoint:Number;
		
		/**
		 *魔法值 
		 */		
		public var magicPoint:Number;
		public var maxMagicPoint:Number;
		
		/**
		 *生命值 
		 */		
		public var healthPoint:Number;
		public var maxHealthPoint:Number;
		
		public function StatusBar()
		{
		}
		
		public function loadFromXML(config:XML):void{
			
		}
		
		public function bindView(view:UIComponent):void{
			this.view = view as StatusBarView;
		}
	}
}