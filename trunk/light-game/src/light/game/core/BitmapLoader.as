package light.game.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	import light.net.LoaderPool;

	/**
	 *图片资源loader 
	 * @author pigs
	 * 
	 */	
	public class BitmapLoader extends Loader
	{
		public static const SingleFrame:int = 0;
		public static const Sequence:int = 1;
		
		public var type:int = Sequence;
		//public var loader:Loader = LoaderPool.getLoader();
		public var url:String;
		
		//如果是图片序列，则需要用以下属性
		public var frameCountX:int = 1;
		public var frameCountY:int = 1;
		private var seqs:Vector.<Vector.<BitmapData>>;
		public var frameWidth:int = 80;
		public var frameHeight:int = 80;
		
		public function BitmapLoader(url:String, type:int=Sequence)
		{
			super();
			this.url = url;
			this.type = type;
		}
		
		public function start():void{
			contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			load(new URLRequest(url));
		}
		
		
		/**
		 *返回改图片资源 
		 * @return 
		 * 
		 */		
		public function getBitmapData(x:int=1, y:int=1):BitmapData{
			if(type==SingleFrame){
				if(content!=null)
					return (content as Bitmap).bitmapData;
				else
					return null;
			}
			else{// if(type==Sequence)
				return seqs[x][y];
			}
		}
	
		private function onComplete(e:Event):void{
			if(type==SingleFrame){
				
			}
			else if(type==Sequence){
				seqs = new Vector.<Vector.<BitmapData>>();
				var cd:BitmapData = (content as Bitmap).bitmapData;
				for(var sy:int=0;sy<frameCountY;sy++){
					var datas:Vector.<BitmapData> = seqs[sy];
					if(datas==null){
						datas = new Vector.<BitmapData>();
					}
					var sm:Matrix = new Matrix();
					for(var sx:int=0;sx<frameCountX;sx++){
						var sd:BitmapData = new BitmapData(frameWidth, frameHeight, true, 0);
						sm.tx = -sx*frameWidth;
						sm.ty = -sy*frameHeight;
						sd.draw(cd, sm);
						//datas[sx] = sd;
						datas.push(sd);
					}
					seqs.push(datas);//seqs[sy] = datas;
				}
			}
		}
		
		private function onError(e:IOErrorEvent):void{
			trace(e);
		}
	}
}