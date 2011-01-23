package light.util
{
	import light.game.sprite.Role;

	public class SceneLoaderUtil
	{
		public function SceneLoaderUtil()
		{
		}
		
		/**
		 *读取角色配置信息 
		 * @param hero
		 * @param rXML
		 * 
		 */		
		public static function loadSpriteInfo(role:Role, roleConfig:Object):void{
			var heroRole:XMLList = roleConfig.role;
			loadAttributes(role, XMLList(roleConfig));
//			role.id = roleConfig.attribute("id");
//			role.name = roleConfig.attribute("name");
			role.position.moveTo(roleConfig.attribute("x"), roleConfig.attribute("y"), roleConfig.attribute("z"));
			//角色基础信息
			loadAttributes(role, heroRole);
//			role.width = heroRole.attribute("width");
//			role.height = heroRole.attribute("height");
//			role.centerX = heroRole.attribute("centerX");
//			role.centerY = heroRole.attribute("centerY");
			role.staticFramesCount = heroRole.staticFrames.attribute("count");
			role.staticFramesUrl = heroRole.staticFrames.url.toString();
			role.staticFrameStartIndex = heroRole.staticFrames.attribute("start");
			role.staticFrameEndIndex = heroRole.staticFrames.attribute("end");
			
			role.walkFramesCount = heroRole.walkFrames.attribute("count");
			role.walkFramesUrl = heroRole.walkFrames.url.toString();
			role.walkFrameStartIndex = heroRole.walkFrames.attribute("start");
			role.walkFrameEndIndex = heroRole.walkFrames.attribute("end");
			
			role.bodyHeight = heroRole.attribute("bodyHeight");
		}
		
		public static function loadAttributes(target:Object, src:XMLList):void{
			for each(var node:XML in src.attributes()){
				var prop:String = node.name();
				if(target.hasOwnProperty(prop))
					target[prop] = node;
			}
		}
	}
}