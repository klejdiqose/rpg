package light.game.core.coord
{
	import flash.geom.Point;

	public class Point3D
	{
		public function Point3D(x:Number=0, y:Number=0, z:Number=0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function clone():Point3D{
			return new Point3D(x, y, z);
		}
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function moveTo(x:Number=0, y:Number=0, z:Number=0):Point3D{
			this.x = x;
			this.y = y;
			this.z = z;
			return this;
		}
		public function moveToPosition(pos:Point3D):Point3D{
			this.x = pos.x;
			this.y = pos.y;
			this.z = pos.z;
			return this;
		}
		
		public function cloneIncreBy(x:Number=0, y:Number=0, z:Number=0):Point3D{
			return new Point3D(this.x+x, this.y+y, this.z+z);
		}
		
		public function increBy(x:Number=0, y:Number=0, z:Number=0):Point3D{
			this.x += x;
			this.y += y;
			this.z += z;
			return this;
		}
		
		public function equals(tar:Point3D):Boolean{
			if(tar==null)
				return false;
			return x==tar.x && y==tar.y && z==tar.z;
		}
	}
}