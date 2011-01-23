package light.game.core
{
	import light.game.view.ToolbarView;
	import light.game.vo.MagicVO;
	import light.game.vo.SingleTargetMagicVO;
	
	import mx.controls.Button;
	import mx.core.UIComponent;

	public class Toolbar implements GameStageComponent
	{
		public const magicTitles:Vector.<MagicVO> = new Vector.<MagicVO>();
		public var leftHandMagic:MagicVO;
		public var rightHandMagic:MagicVO;
		
		public var view:ToolbarView;
		
		public function Toolbar()
		{
		}
		
		public function loadFromXML(config:XML):void{
			var magicConfig:XMLList = config.magic;
			var leftId:String = (config.leftHandMagic as XMLList).attribute("magicId");
			var rightId:String = (config.rightHandMagic as XMLList).attribute("magicId");
			for each(var m:XML in magicConfig){
				var vo:MagicVO = new SingleTargetMagicVO();
				vo.id = m.attribute("id");
				vo.centerX = m.attribute("centerX");
				vo.centerY = m.attribute("centerY");
				vo.frameCount = m.attribute("frameCount");
				vo.titleUrl = m.attribute("titleUrl");
				vo.width = m.attribute("width");
				vo.height = m.attribute("height");
				vo.name = m.attribute("name");
				var animation:XMLList = m.animation;
				vo.framesUrl = animation.attribute("framesUrl");
				vo.resType = animation.attribute("type");
				magicTitles.push(vo);
				if(vo.id == leftId)
					setLeftHandMagic(vo);
				if(vo.id == rightId)
					setRightHandMagic(vo);
			}
		}
		
		public function bindView(view:UIComponent):void{
			this.view = view as ToolbarView;
			if(leftHandMagic)
				this.view.setLeftMagic(leftHandMagic);
			if(rightHandMagic)
				this.view.setRightMagic(rightHandMagic);
		}
		
		/**
		 * 设置左右魔法
		 */
		public function setLeftHandMagic(m:MagicVO):void{
			leftHandMagic = m;
			if(view!=null){
				view.setLeftMagic(m);
			}
		}
		
		/**
		 * 设置右手魔法
		 */
		public function setRightHandMagic(m:MagicVO):void{
			rightHandMagic = m;
			if(view!=null){
				view.setRightMagic(m);
			}
		}
	}
}