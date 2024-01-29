package events
{
	import flash.events.Event;
	import items.Knot;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class CardEvent extends Event
	{
		public static const KNOT_EDITING_STARTED:String = "knotEditingStarted";
		public static const KNOT_EDITING_FINISHED:String = "knotEditingFinished";
		public static const DISCONNECT_KNOT:String = "disconnectKnot";
		public static const KNOT_MOUSE_OVER:String = "knotMouseOver";
		
		public var knot:Knot;
		
		public function CardEvent(type:String, knot:Knot = null)
		{
			super(type);
			
			this.knot = knot;
		}
	
	}

}