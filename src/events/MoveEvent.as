package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MoveEvent extends Event 
	{
		public static const MOVED:String = "moved";
		public static const PARENT_MOVED:String = "parentMoved";
		
		public var oldX:Number;
		public var oldY:Number;
		public var newX:Number;
		public var newY:Number;
		
		public function MoveEvent(type:String, newX:Number = NaN, newY:Number = NaN, oldX:Number = NaN, oldY:Number = NaN) 
		{
			super(type);
			this.newX = newX;
			this.newY = newY;
			this.oldX = oldX;
			this.oldY = oldY;
		}
		
	}

}