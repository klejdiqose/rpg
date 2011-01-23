package light.net
{
	import flash.display.Loader;
	import flash.net.URLLoader;

	/**
	 *“资源加载器”池 
	 * @author pigs
	 * 
	 */	
	public class LoaderPool
	{
		public function LoaderPool()
		{
		}
		
		public static function getLoader():Loader{
			return new Loader();
		}
		
		public static function getUrlLoader():URLLoader{
			return new URLLoader();
		}
	}
}