package light.game.view
{
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import light.game.core.GameStage;
	import light.game.sprite.Role;
	
	import mx.effects.Tween;
	
	import spark.effects.animation.Animation;
	
	public class AttackPoint extends TextField
	{
		private var tf:TextFormat = new TextFormat();
		private var distance:Number;
		private var target:Role;
		public function AttackPoint(num:Number, role:Role)
		{
			super();
			target = role;
			tf.bold = true;
			tf.size = 40;
			tf.color = 0xf3f201;
			text = String(num);
			setTextFormat(tf);
			GameStage.Instance.gameScene.addDisplayObject(this);
			distance = role.centerX-textWidth*0.5;
			show();
		}
		
		public function show():void{
			x = target.view.x+distance;
			y = target.view.y-30;
			var tw:Tween = new Tween(this, y, y-60, 500);
		}
		
		public function onTweenUpdate(value:Object):void
		{
			x = target.view.x+distance;
			y = value as Number;
		}
		
		public function onTweenEnd(value:Object):void
		{
			GameStage.Instance.gameScene.removeDisplayObject(this);
		}
	}
}