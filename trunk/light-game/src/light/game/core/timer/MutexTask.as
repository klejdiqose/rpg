package light.game.core.timer
{
	/**
	 *互斥的多个持久任务 
	 * @author pigs
	 * 
	 */	
	public class MutexTask extends Task
	{
		public function MutexTask()
		{
			super();
		}
		
		public override function nextStep():void{
			activeTask();
		}
		
		private var taskStore:Object = new Object();
		private var name:String;
		
		public function addMutexFunction(name:String, task:Function):void{
			taskStore[name] = task;
			if(activeTask==null)
				activeTask = task;
		}
		
		public function removeTask(name:String):void{
			taskStore[name] = null;
			delete taskStore[name];
		}
		
		public function activate(name:String):void{
			this.name = name;
			activeTask = taskStore[name];
		}
	}
}