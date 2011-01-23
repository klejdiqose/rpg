package light.game.core.coord
{
	import flash.geom.Point;
	
	import light.game.sprite.Map;

	public class Translator
	{
		//private var map:Map;
		public function Translator()
		{
			//this.map = map;
		}
		
		public static const Y_Correct:Number = Math.cos(-Math.PI/6)*Math.SQRT2
		
		/**
		 *平面世界坐标转换成屏幕坐标
		 * （先转换成全局地图坐标，然后将全局地图坐标转换成屏幕坐标）
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */			
		public static function world2DToScreen(map:Map, x:Number, y:Number):Point{
			return new Point(x-map.screenX-map.orgX, y-map.screenY-map.orgY);
		}
		
		/**
		 *屏幕坐标转换成平面世界坐标
		 * （先转换成全局地图坐标，然后将全局地图坐标转换成世界坐标）
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function screenToWorld2D(map:Map, x:Number, y:Number):Point{
			return new Point(x+map.screenX+map.orgX, y+map.screenY+map.orgY);
		}
		
		/**
		 *3D世界坐标转换为平面屏幕坐标 
		 * @param pos
		 * @return 
		 * 
		 */		
		public static function world3DToWorld2D(pos:Point3D):Point{
			return new Point(pos.x-pos.y, pos.z*Y_Correct+(pos.x+pos.y)*0.5);
		}
		
		/**
		 *平面屏幕坐标转换为3D世界坐标 
		 * @param pos
		 * @return 
		 * 
		 */		
		public static function world2DToWorld3D(pos:Point):Point3D{
			return new Point3D(pos.y+pos.x*0.5, pos.y-pos.x*0.5, 0);
		}
		
		/**
		 *平面屏幕坐标转换为3D世界坐标 
		 * @param pos
		 * @return 
		 * 
		 */		
		public static function world2DToWorld3D_(x:Number, y:Number):Point3D{
			return new Point3D(y+x*0.5, y-x*0.5, 0);
		}
	}
}