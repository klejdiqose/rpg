package light.net
{
	
	import entity.Entity;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class PacketedEndpoint
	{
		public function PacketedEndpoint()
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
			writePacketInfo(data);
			socket.writeBytes(data);
		}

		public function _send(data:ByteArray):void
		{
			socket.writeBytes(data);
		}
		public function request(data:Packet, handler:Function):void
		{
			writePacketInfo(data);
			socket.writeByte(Protocal.Request);
			var id:uint = Protocal.genRequestId();
			socket.writeByte(id);
			socket.writeBytes(data);
			reqBuffer[id] = handler;
		}
		
		private function writePacketInfo(packet:Packet):void
		{
			socket.writeInt(Protocal.PacketHeader);//header
			var cmdBytes:ByteArray = new ByteArray();
			cmdBytes.writeUTF(packet.Command);
			socket.writeInt(packet.Command);//packet length
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
//		public var cmdHandler:Function = onCommand;
//		public var respHandler:Function = onResponse;
		
		private function onReceive(cmd:Packet):void{
			
		}
//		private function onResponse(resp:Object):void{
//			
//		}
		private function onConnection():void
		{
			trace("connected to "+remoteHost+":"+remotePort);
		}
//		private function onData(data:ByteArray):void
//		{
//			trace("recv: "+data.readUTFBytes(data.length));
//		}
	}
}