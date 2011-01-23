package light.game.sprite.face
{
	import light.game.vo.MagicVO;

	public interface IToolbarView
	{
		function setLeftMagic(magic:MagicVO):void;
		
		function setRightMagic(magic:MagicVO):void;
	}
}