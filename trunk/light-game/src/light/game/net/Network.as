package light.game.net
{
	import light.net.Endpoint;
	import light.net.Packet;

	public class Network
	{
		private var endpoint:Endpoint = new Endpoint();
		public function Network()
		{
			endpoint.connect("localhost", 60606);
			endpoint.dataHandler = function(data:Packet):void{
				trace(data.Bytes.position);
			}
		}
		
	}
}