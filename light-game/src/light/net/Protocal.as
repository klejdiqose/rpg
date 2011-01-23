package light.net
{
	public class Protocal
	{
		public function Protocal()
		{
		}
		
		public static const PacketHeader:int = 0x0;
		
		public static const CommandData:int = 0;
		public static const Command:int = 2;
		public static const Data:int = 4;
		public static const Request:int = 8;
		public static const Response:int = 16;

		private static var requestIdSequence:uint = 0;
		public static function genRequestId():uint{
			return requestIdSequence++;
		}
	}
}