package light.game.core.timer
{
	/**
	 *持久任务 
	 * @author pigs
	 * 
	 */	
	public class Task implements ITask
	{
		protected var activeTask:Function;
		protected var _alive:Boolean = true;
		
		public function Task(task:Function=null)
		{
			activeTask = task;
		}
		
		public function nextStep():void{
			activeTask();
		}
		
		/**
		 *暂停任务 
		 * 
		 */		
		public function suspend():void{
			//TODO
		}
		
		/**
		 *结束任务 
		 * 
		 */		
		public function kill():void{
			_alive = false;
		}
		
		public function set alive(a:Boolean):void{
			_alive = a;
		}
		public function get alive():Boolean{
			return _alive;
		}
	}
}