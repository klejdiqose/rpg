package light.game.user
{
	public class Session
	{
		public function Session()
		{
		}
		
		private static var session:Session;
		
		public static function getSession():Session{
			if(session==null){
				session = new Session();
			}
			return session;
		}
		
		public var userId:String;
	}
}