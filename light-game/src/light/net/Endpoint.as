package light.net
{
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class Endpoint
	{
		public function Endpoint()
		{
			socket = new Socket();
		}
		
		
		private var socket:Socket;
		private var remoteHost:String;
		private var remotePort:String;
		
		public function connect(host:String, port:int):void{
			socket.addEventListener(Event.CONNECT, _onSocketConnect);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, _onSocketRecv);
			socket.addEventListener(IOErrorEvent.IO_ERROR, function(e:ErrorEvent):void{
				trace(e);
			});
			socket.connect(host, port);
			socket.writeMultiByte("haha", "utf-8");
			
		}
		
		public function send(data:Packet):void
		{
			socket.writeBytes(data.Bytes);
		}
		
		private function _onSocketConnect(e:Event):void
		{
			onConnection();
		}
		
		private var recvStatus:int = 0;
		private var lackBytes:int = 0;
		private var lastPacket:Packet = null;
		private function _onSocketRecv(e:ProgressEvent):void
		{
			if(lackBytes==0)
			{
				if(socket.bytesAvailable>=4)
				{
					if(socket.readInt()==Protocal.PacketHeader)
					{
						//读取包长度
						if(socket.bytesAvailable>=2)
						{
							var packetLen:int = socket.readShort();//trace("ge len "+packetLen);
							if(packetLen<0)
								return;
							else
							{
								var p:Packet = Packet.newSizePacket(packetLen);
								if(socket.bytesAvailable>=packetLen)
								{
									socket.readBytes(p.Bytes, 0, packetLen);
									onData(p);
									lackBytes = 0;
								}
								else if(socket.bytesAvailable<packetLen)
								{
									lackBytes = packetLen - socket.bytesAvailable;
									socket.readBytes(p.Bytes, 0, socket.bytesAvailable);
									lastPacket = p;
								}
							}
						}
					}
				}
			}
			else
			{
				//本次数据足够填充上一个 Packet
				//trace("re get "+socket.bytesAvailable+","+lackBytes);
				if(socket.bytesAvailable>=lackBytes)
				{
					var bytes:ByteArray = lastPacket.Bytes;
					socket.readBytes(bytes, bytes.length, lackBytes);
					onData(lastPacket);
					lastPacket = null;
					lackBytes = 0;
				}
			}
		}
		
		public var connectinoHandler:Function = onConnection;
		public var dataHandler:Function = onData;
		
		public function onConnection():void
		{
			trace("connected to "+remoteHost+":"+remotePort);
		}
		public function onData(data:Packet):void
		{
			trace("recv: "+data.Bytes.length);
		}
	}
}