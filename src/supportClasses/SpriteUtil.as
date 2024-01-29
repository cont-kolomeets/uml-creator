package supportClasses
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class SpriteUtil
	{
		private static var zMemo: Number = 0;
		private static var zMemoNode: DisplayObject;
		
		public static function suspendZ(node:DisplayObject):void
		{
			var originalNode:DisplayObject = node;
			while (node){
				if (node.z != 0){
					zMemoNode = node;
					break;
				}
				node = node.parent;
			}
			if(!zMemoNode)
				zMemoNode = originalNode;
			
			zMemo = zMemoNode.z;
			zMemoNode.z = 0;
		}
		
		public static function resumeZ():void
		{
			zMemoNode.z = zMemo;
		}
	}

}