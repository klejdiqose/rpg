package light.game.res
{
	public class ResEvent
	{
		public var success:Boolean;
		public var data:Object;
		public var error:Error;
		
		public function ResEvent(isSuccess:Boolean, info:Object)
		{
			success = isSuccess;
			if(success)
				data = info;
			else
				error = info as Error;
		}
	}
}