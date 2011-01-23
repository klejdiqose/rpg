package light.game.sprite
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import light.game.core.coord.Point3D;
	import light.game.core.timer.Task;

	public class RoleWalkTask extends Task
	{
		public function RoleWalkTask(r:Role)
		{
			this.role = r;
			map = r.getScene().getMap();
		}
		
		private var role:Role;
		private var map:Map;
		private var path:Array;
		private var smoothPath:Vector.<Point3D> = new Vector.<Point3D>();;
		private var lastPos:Point3D;
		private var smoothly:Boolean = false;
		
		
		public function walk(newPath:Array):void{
			newPath.shift();
			this.path = newPath;
			role.switchToWalkStatus();
			smoothPath.slice(0, -1);
		}

		
		private const walkSmoothPartition:int = 8;
		private const walkSmoothPartitionRate:Number = 1/walkSmoothPartition;
		public override function nextStep():void{
			if(path==null){
				return;
			}
			var pos:Point3D = smoothPath.shift();
			while(pos!=null && pos.equals(lastPos)){
				pos = smoothPath.shift();
			}
			if(pos==null){
				if(buildSmoothPath()){
					pos = smoothPath.shift();
				}
				else
					return;
			}
			lastPos = pos;
			role.moveTo3D(pos, true);
		}
		
		private function buildSmoothPath():Boolean{
			var position:Point3D = role.position;
			var target:Point3D = path.shift();
			while(target!=null && target.equals(position)){
				target = path.shift();
			}
			if(target==null){
				role.switchToStaticStatus();
				path=null;
				return false;
			}
			var ofx:Number = (target.x-position.x)*walkSmoothPartitionRate;
			var ofy:Number = (target.y-position.y)*walkSmoothPartitionRate;
			var ofz:Number = (target.z-position.z)*walkSmoothPartitionRate;
			
			var dir:int = role.detectDirection(ofx, ofy);
			role.direction = dir;
			var t:Point3D = role.position;
			smoothPath.splice(0, -1);
			for(var i:int=0;i<walkSmoothPartition-1;i++){
				t = t.cloneIncreBy(ofx, ofy, ofz);
				smoothPath.push(t);
			}
			smoothPath.push(target);
			return true;
		}
	}
}