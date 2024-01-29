package events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class ButtonEvent extends Event
	{
		public static const BUTTON_CLICK:String = "buttonClick";
		
		public function ButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			super(type, bubbles, cancelable);
		}
	
	}

}