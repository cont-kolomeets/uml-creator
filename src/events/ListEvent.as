package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ListEvent extends Event
	{
		public static const DRAG:String = "drag";
		public static const DROP:String = "drop";
		
		public function ListEvent(type:String) 
		{
			super(type);
		}
		
	}

}