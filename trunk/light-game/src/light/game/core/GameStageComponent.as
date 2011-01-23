package light.game.core
{
	import mx.core.UIComponent;

	public interface GameStageComponent
	{
		function bindView(view:UIComponent):void;
		
		function loadFromXML(config:XML):void;
	}
}