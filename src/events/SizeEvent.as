package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class SizeEvent extends Event 
	{
		public static const SIZE_CHANGED:String = "sizeChanged";
				
		public var width:Number = 0;
		
		public var height:Number = 0;
		
		public function SizeEvent(type:String, width:Number, height:Number, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			this.width = width;
			this.height = height;
			
			super(type, bubbles, cancelable);
		}
		
	}

}