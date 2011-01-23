package light.net
{
	import entity.Entity;
	
	import flash.utils.ByteArray;

	public class Packet
	{
		private var prop:Object = null;
		private var data:ByteArray = null;
		
		public static function NewCommandPacket():Packet
		{
			return new Packet(new Object(), new ByteArray());
		}
		public static function NewDataPacket():Packet{
			return new Packet(null, new ByteArray());
		}
		public static function NewCommandDataPacket():Packet{
			return new Packet(new Object(), new ByteArray());
		}
		
		public function Packet(prop:Object=null, data:ByteArray=null)
		{
			this.prop = prop;
			this.data = new ByteArray();
		}
		
		public function get Command():String{
			return Entity.encode(prop);
		}
		
		public function get Data():ByteArray{
			return data;
		}
		
		public function hasCommand():Boolean{
			return prop!=null;
		}
		
		public function hasData():Boolean{
			return data!=null;
		}
		
		public function get(propName:String):Object{
			return prop[propName];
		}
		public function set(propName:String, value:Object):void{
			prop[propName] = value;
		}
		public function remove(propName:String):void
		{
			delete prop[propName];
		}
	}
}