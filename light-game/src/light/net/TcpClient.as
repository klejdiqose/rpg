package light.net
{
	
	import entity.Entity;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class TcpClient
	{
		public function TcpClient()
		{
			socket = new Socket();
		}
		
		
		private var socket:Socket;
		private var remoteHost:String;
		private var remotePort:String;
		
		private var reqBuffer:Array = new Array();
		
		public function connect(host:String, port:int):void{
			socket.addEventListener(Event.CONNECT, _onSocketConnect);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, _onSocketRecv);
			socket.addEventListener(IOErrorEvent.IO_ERROR, function(e:ErrorEvent):void{
				trace("error: "+e);
			});
			socket.connect(host, port);
			socket.writeMultiByte("haha", "utf-8");
			
		}
		
		public function send(packet:Packet):void
		{
			socket.writeBytes(writeInfoAndGetCmdBytes(packet));
			if(packet.hasData())
				socket.writeBytes(packet.Data);
		}

		public function sendInDirect(data:ByteArray):void
		{
			socket.writeBytes(data);
		}
		public function request(data:Packet, handler:Function):void
		{
			var id:uint = Protocal.genRequestId();
			socket.writeByte(id);
			socket.writeBytes(writeInfoAndGetCmdBytes(data, id));
			if(data.hasData())
				socket.writeBytes(data.Data);
			reqBuffer[id] = handler;
		}
		
		private function writeInfoAndGetCmdBytes(packet:Packet, reqId:uint=0):ByteArray
		{
			var cmdBytes:ByteArray = new ByteArray();
			cmdBytes.writeUTF(packet.Command);
			
			socket.writeInt(Protocal.PacketHeader);//header
			socket.writeShort(cmdBytes.length+packet.hasData()?packet.Data.length:0);//packet length
			//packet type
			if(reqId>0)
				socket.writeByte(Protocal.Request);
			else
			{
				if(packet.hasData())
					socket.writeByte(Protocal.CommandData);
				else
					socket.writeByte(Protocal.Command);
			}
			return cmdBytes;
		}
		
		private function _onSocketConnect(e:Event):void
		{
			connectinoHandler();
		}
		
		//private var lackBytes:int = 0;
		//private var lastPacket:ByteArray = null;
		private var lastPacketLen:int = 0;
		//private var respPacketLength:int = 0;
		private function _onSocketRecv(e:ProgressEvent):void
		{
			if(lastPacketLen==0)
			{
				if(socket.bytesAvailable>=(4+2+1))
					_onSocketRecvNew(e);
			}
			else
			{
				if(socket.bytesAvailable>=lastPacketLen)
					_recvCompletePacket(e);
				//else
				//如果没有接收到一个完整的包，则忽略这次事件
			}
		}
		private function _onSocketRectResp(e:ProgressEvent):void{
			if(socket.bytesAvailable<(4))
				return;
			var reqId:int = socket.readInt();
			var ptype:int = socket.readByte();
			var handler:Function = reqBuffer[reqId];
			if(ptype==Protocal.Command)
			{
				var cmdstr:String = socket.readUTFBytes(lastPacketLen);
				var cmd:Object = Entity.decodeJSON(cmdstr);
				if(handler!=null)
					handler(new Packet(cmd));
			}
			else if(ptype==Protocal.Data)
			{
				var recvData:ByteArray = new ByteArray();
				socket.readBytes(recvData, 0, lastPacketLen);
				if(handler!=null)
					handler(new Packet(recvData));
			}
			else if(ptype==Protocal.CommandData)
			{
				var cmdLen:uint = socket.readShort();
				var cmdstr:String = socket.readUTFBytes(cmdLen);
				var cmd:Object = Entity.decodeJSON(cmdstr);
				var recvData:ByteArray = new ByteArray();
				socket.readBytes(recvData, 0, lastPacketLen-cmdLen);
				if(handler!=null)
					handler(new Packet(cmd, recvData));
			}
		}
		
		private function _onSocketRecvNew(e:ProgressEvent):void{
			if(socket.readInt()==Protocal.PacketHeader)
			{
				//var packetLen:int = socket.readShort();//trace("ge len "+packetLen);
				lastPacketLen = socket.readShort();
				if(lastPacketLen<0)
				{
					lastPacketLen = 0;
					return;
				}
				else
				{
					_recvCompletePacket(e);
				}
			}
		}
		
		/**
		 * 当接收到一个完整的包
		 */
		private function _recvCompletePacket(e:ProgressEvent){
			var p:ByteArray = new ByteArray();
			//接收到一个完整的数据包，开始分析数据包类型
			var ptype:int = socket.readByte();
			switch(ptype)
			{
				case Protocal.Command://Command包
					var cmdstr:String = socket.readUTFBytes(lastPacketLen);
					var cmd:Object = Entity.decodeJSON(cmdstr);
					recvHandler(new Packet(cmd));
					break;
				case Protocal.CommandData://命令和数据包
					var cmdLen:uint = socket.readShort();
					var cmdstr:String = socket.readUTFBytes(cmdLen);
					var cmd:Object = Entity.decodeJSON(cmdstr);
					var recvData:ByteArray = new ByteArray();
					socket.readBytes(recvData, 0, lastPacketLen-cmdLen);
					recvHandler(new Packet(cmd, recvData));
					break;
				case Protocal.Response://response包
					_onSocketRectResp(e);
					break;
			}
			lastPacketLen = 0;
		}
//		private function _onSocketRecvLast(e:ProgressEvent):void{
//			//本次数据足够填充上一个 Packet
//			//trace("re get "+socket.bytesAvailable+","+lackBytes);
//			if(socket.bytesAvailable>=lackBytes)
//			{
//				//var bytes:ByteArray = lastPacket.Bytes;
//				socket.readBytes(lastPacket, lastPacket.length, lackBytes);
//				onData(lastPacket);
//				lastPacket = null;
//				lackBytes = 0;
//			}
//		}
		//hX3wY4BH3qK2
		public var connectinoHandler:Function = onConnection;
		public var recvHandler:Function = onReceive;
		
		private function onReceive(cmd:Packet):void{
			
		}
		private function onConnection():void
		{
			trace("connected to "+remoteHost+":"+remotePort);
		}
	}
}