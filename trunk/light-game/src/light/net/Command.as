package light.net
{
	import entity.Entity;
	
	import flash.utils.ByteArray;

	public class Command
	{
		private var prop:Object = null;
		private var data:ByteArray = null;
		
		public function Command(prop:Object=null, data:ByteArray=null)
		{
			if(prop==null)
				this.prop = new Object();
			else
				this.prop = prop;
			if(data!=null)
				this.data = data;
			else
				this.data = new ByteArray();
		}
		
		public function get CmdString():String{
			return Entity.encode(prop);
		}
		
		public function get Data():ByteArray{
			return data;
		}
		public function get(propName:String):Object{
			return prop[propName];
		}
		public function set(propName:String, value:Object):void{
			prop[propName] = value;
		}
	}
}