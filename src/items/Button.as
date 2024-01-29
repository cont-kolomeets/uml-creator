package items
{
	import events.ButtonEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class Button extends Sprite
	{
		public var label:String;
		public var cornerRadius:Number = 0;
		public var id:String;
		private var textField:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		
		public function Button(label:String = "")
		{
			format.align = TextFormatAlign.CENTER;
			
			this.label = label;
			
			textField.defaultTextFormat = format;
			textField.text = label;
			textField.selectable = false;
			textField.textColor = 0;
			addChild(textField);
			
			addListeners();
			drawButtonUp();
		}
		
		private var _image:Sprite;
		
		public function set image(value:Sprite):void
		{
			if (_image)
				removeChild(_image);
			
			_image = value;
			_image.x = _imageOffsetX;
			_image.y = _imageOffsetY;
			addChild(_image);
		}
		
		public function set textOffsetX(value:Number):void
		{
			textField.x = value;
		}
		
		public function set textOffsetY(value:Number):void
		{
			textField.y = value;
		}
		
		private var _imageOffsetX:Number = 0;
		
		public function set imageOffsetX(value:Number):void
		{
			if (_image)
				_image.x = value;
			
			_imageOffsetX = value;
		}
		
		private var _imageOffsetY:Number = 0;
		
		public function set imageOffsetY(value:Number):void
		{
			if (_image)
				_image.y = value;
			
			_imageOffsetY = value;
		}
		
		public function set textColor(value:int):void
		{
			textField.textColor = value;
		}
		
		public function set textSize(value:int):void
		{
			format.size = value;
			textField.setTextFormat(format);
		}
		
		public function set font(value:String):void
		{
			format.font = value;
			textField.setTextFormat(format);
		}
		
		public function setBoldOn():void
		{
			format.bold = true;
			textField.setTextFormat(format);
		}
		
		public function setBoldOff():void
		{
			format.bold = false;
			textField.setTextFormat(format);
		}
		
		private var _buttonWidth:Number = 100;
		
		public function get buttonWidth():Number
		{
			return _buttonWidth;
		}
		
		public function set buttonWidth(value:Number):void
		{
			_buttonWidth = value;
			textField.width = value;
			drawButtonUp();
		}
		
		private var _buttonHeight:Number = 20;
		
		public function get buttonHeight():Number
		{
			return _buttonHeight;
		}
		
		public function set buttonHeight(value:Number):void
		{
			_buttonHeight = value;
			textField.height = (value < 20) ? 20 : value;
			drawButtonUp();
		}
		
		private var _buttonStrokeColor:int = 0x555555;
		
		public function set buttonStrokeColor(value:int):void
		{
			_buttonStrokeColor = value;
			drawButtonUp();
		}
		
		private var _buttonStrokeWeight:int = 1;
		
		public function set buttonStrokeWeight(value:int):void
		{
			_buttonStrokeWeight = value;
			drawButtonUp();
		}
		
		private var _buttonColor:int = 0x00FF00;
		
		public function set buttonColor(value:int):void
		{
			_buttonColor = value;
			drawButtonUp();
		}
		
		private var _buttonAlphaUp:Number = 0.5;
		
		public function set buttonAlphaUp(value:Number):void
		{
			_buttonAlphaUp = value;
			drawButtonUp();
		}
		
		private var _buttonAlphaDown:Number = 0.7;
		
		public function set buttonAlphaDown(value:Number):void
		{
			_buttonAlphaDown = value;
			drawButtonUp();
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, button_removedFromStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler);
		}
		
		private function button_removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, button_removedFromStageHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler);
		}
		
		private function mouseDown_Handler(event:MouseEvent):void
		{
			drawButtonDown();
			this.dispatchEvent(new ButtonEvent(ButtonEvent.BUTTON_CLICK));
		}
		
		private function mouseUp_Handler(event:MouseEvent):void
		{
			drawButtonUp();
		}
		
		private function drawButtonUp():void
		{
			graphics.clear();
			graphics.lineStyle(_buttonStrokeWeight, _buttonStrokeColor);
			graphics.beginFill(_buttonColor, _buttonAlphaUp);
			graphics.drawRoundRect(0, 0, _buttonWidth, _buttonHeight, cornerRadius, cornerRadius);
		}
		
		private function drawButtonDown():void
		{
			graphics.clear();
			graphics.lineStyle(_buttonStrokeWeight, _buttonStrokeColor);
			graphics.beginFill(_buttonColor, _buttonAlphaDown);
			graphics.drawRoundRect(0, 0, _buttonWidth, _buttonHeight, cornerRadius, cornerRadius);
		}
	
	}

}