package light.game.view
{
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import light.game.core.GameSprite;
	import light.game.core.GameStage;
	
	import mx.effects.Tween;
	
	import spark.effects.animation.Animation;
	
	public class AttackPoint2 extends GameSprite
	{
		private var text:TextField = new TextField();
		private var tf:TextFormat = new TextFormat();
		public function AttackPoint2(num:Number, targetX:Number, targetY:Number)
		{
			super();
			tf.bold = true;
			tf.size = 40;
			tf.color = 0xf3f201;
			text.text = String(num);
			text.setTextFormat(tf);
			
			GameStage.Instance.gameScene.addDisplayObject(this);
			show(targetX, targetY);
		}
		
		public function show(targetX:Number, targetY:Number):void{
			x = targetX;
			y = targetY;
			var tw:Tween = new Tween(this, targetY, targetY-80, 600);
		}
		
		public function onTweenUpdate(value:Object):void
		{
			y = value as Number;
		}
		
		public function onTweenEnd(value:Object):void
		{
			GameStage.Instance.gameScene.removeDisplayObject(this);
		}
	}
}