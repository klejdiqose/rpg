package light.game.core.timer
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 *持久任务定时器 
	 * @author pigs
	 * 
	 */	
	public class PersistentTimer
	{
		private var persistentTimer:Timer;
		public function PersistentTimer(delay:int)
		{
			persistentTimer = new Timer(delay, 0);
			persistentTimer.addEventListener(TimerEvent.TIMER, doTask);
		}
		
		private static const instances:Dictionary = new Dictionary();
		public static function getTimer(delay:int):PersistentTimer{
			var ins:PersistentTimer = instances[String(delay)];
			if(ins==null)
			{
				//trace('no: '+String(delay));
				ins = new PersistentTimer(delay);
				instances[String(delay)] = ins;
			}
			return ins;
		};
		
		private var tasks:Vector.<ITask> = new Vector.<ITask>();
		
		/**
		 *添加任务 
		 * @param task
		 * 
		 */		
		public function addTask(task:ITask):void{
			tasks.push(task);
			if(!persistentTimer.running)
				persistentTimer.start();
		}
		
		/**
		 *暂停定时器 
		 * 
		 */		
		public function stop():void{
			persistentTimer.stop();
		}
		
		private function doTask(e:Event):void{
			for each(var task:ITask in tasks){
				task.nextStep();
				//trace('execute: '+persistentTimer.delay);
//				if(!task.alive){
//					tasks.slice(tasks.indexOf(task), 0);
//				}
			}
			//trace('finish a task....');
		}
		
	}
}