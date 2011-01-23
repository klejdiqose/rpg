package light.util
{
	public class Bind
	{
		public function Bind()
		{
		}
		
		/**
		 * 通用函数代理
		 * @param obj
		 * @param func
		 * @param arg
		 * @return 
		 * 
		 */		 
		public static function bind(obj : *, func : Function, ...arg) : Function{  
			return function(...a) : * {  
				return func.apply(obj, arg);  
			};    
		}
	}
}