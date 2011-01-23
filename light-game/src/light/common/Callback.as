package light.common
{
	public class Callback
	{
		public function Callback(issuccess:Boolean=false, content:Object=null)
		{
			this.success = issuccess;
			if(issuccess)
				this.content = content;
			else
				this.errorInfo = content;
		}
		
		public var success:Boolean;
		public var content:Object;
		public var errorInfo:Object;
	}
}