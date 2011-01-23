package light.game.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flexunit.framework.Assert;
	
	public class LightTimerTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testExecute():void
		{
			for(var i=0;i<1;i++){
				var t:Timer = new Timer(100, 200);
				t.addEventListener(TimerEvent.TIMER, function():void{
					trace("haha");
				});
				t.start();
			}
		}
	}
}