package items
{
	import events.ButtonEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ToggleButton extends Button
	{
		public var upLabel:String = "";
		public var downLabel:String = "";
		
		private var isUp:Boolean = true;
		
		public function ToggleButton(upLabel:String = "", downLabel:String = "")
		{
			super();
			
			this.upLabel = upLabel;
			this.downLabel = downLabel;
			
			updateState();
			
			addListeners();
		}
		
		private var _upImage:Sprite;
		
		public function set upImage(value:Sprite):void
		{
			_upImage = value;
			updateState();
		}
		
		private var _downImage:Sprite;
		
		public function set downImage(value:Sprite):void
		{
			_downImage = value;
			updateState();
		}
		
		public function isUpState():Boolean
		{
			return isUp;
		}
		
		public function setUp():void
		{
			isUp = true;
			updateState();
		}
		
		public function setDown():void
		{
			isUp = false;
			updateState();
		}
		
		public function toggle():void
		{
			isUp = !isUp;
			updateState();
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			addEventListener(ButtonEvent.BUTTON_CLICK, button_clickHandler);
		}
		
		private function this_removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			removeEventListener(ButtonEvent.BUTTON_CLICK, button_clickHandler);
		}
		
		private function button_clickHandler(event:ButtonEvent):void
		{
			toggle();
		}
		
		private function updateState():void
		{
			label = isUp ? upLabel : downLabel;
			
			if (isUp && _upImage)
				image = _upImage;
			
			if (!isUp && _downImage)
				image = _downImage;
		}
	
	}

}