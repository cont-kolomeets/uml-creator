package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class PanelEvent extends Event 
	{
		public static const FADING_IN_FINISHED:String = "fadingInFinished";
		public static const FADING_OUT_FINISHED:String = "fadingOutFinished";
		
		public function PanelEvent(type:String) 
		{
			super(type);
		}
		
	}

}