package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class KnotEvent extends Event 
	{
		public static const MOUSE_OVER_KNOT:String = "mouseOverKnot";
		public static const MOUSE_OUT_KNOT:String = "mouseOutKnot";
		public static const MOUSE_UP_KNOT:String = "mouseUpKnot";
		public static const DISCONNECT:String = "disconnect";
		public static const DRAWING_PSEUDO_CONNECTION:String = "drawingPseudoConnection";
		public static const DRAWING_PSEUDO_CONNECTION_FINISHED:String = "drawingPseudoConnectionFinished";
		
		public function KnotEvent(type:String) 
		{
			super(type);
		}
		
	}

}