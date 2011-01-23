package light.game.core.timer
{
	public interface ITask
	{
		function nextStep():void;
		
		function get alive():Boolean;
	}
}