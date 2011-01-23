package light.game.net
{
	import light.net.Packet;
	import light.net.TcpClient;

	public class GameClient
	{
		private var endpoint:TcpClient = new TcpClient();
		private var reqBuffer:Array = new Array();
		
		public function GameClient()
		{
			endpoint.connect("localhost", 60606);
			endpoint.recvHandler = function(data:Packet):void{
				trace(data);
				
			}
		}
		
		public function request(data:Packet, handler:Function):void{
			endpoint.request(data, handler);
		}
		
	}
}