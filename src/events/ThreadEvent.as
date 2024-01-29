package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ThreadEvent extends Event 
	{
		public static const DISCONNECT:String = "disconnect";
		public static const DISCONNECTED:String = "disconnected";
		
		public function ThreadEvent(type:String) 
		{
			super(type);
		}
		
	}

}