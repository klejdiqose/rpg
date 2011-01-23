package light.util
{
	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		public static function isEmpty(s:String):Boolean{
			return s==null || s.length==0;
		}
	}
}