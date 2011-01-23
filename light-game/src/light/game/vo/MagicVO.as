package light.game.vo
{
	import light.game.sprite.Entity;

	public class MagicVO
	{		
		public var id:String;
		public var name:String;
		public var titleUrl:String;
		public var frameCount:int;
		public var centerX:Number;
		public var centerY:Number;
		public var width:int;
		public var height:int;
		
		/**
		 *动画资源类型：split分散多张图片；one整合一张图片 
		 */		
		public var resType:String;
		/**
		 *图片资源路径 
		 */		
		public var framesUrl:String;
		
	}
}