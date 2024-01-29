package items
{
	import events.SizeEvent;
	import events.TextFieldEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import supportClasses.ArrayList;
	import supportClasses.IUndoable;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class AdvancedField extends Sprite implements IUndoable
	{
		private static const formatKey:String = "28357793f";
		
		public var label:String;
		public var id:String = "";
		
		private var textField:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		private var textStack:ArrayList = new ArrayList();
		
		public function AdvancedField()
		{
			this.label = label;
			configureTextField();
			addListeners();
		}
		
		//-----------------------------------------------
		//
		// getters/setters
		//
		//-----------------------------------------------
		
		override public function get width():Number
		{
			return textField.width;
		}
		
		override public function set width(value:Number):void
		{
			textField.width = value;
			dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, textField.width, textField.height));
		}
		
		override public function get height():Number
		{
			return textField.height;
		}
		
		override public function set height(value:Number):void
		{
			textField.height = value;
			dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, textField.width, textField.height));
		}
		
		public function set textColor(value:int):void
		{
			textField.textColor = value;
		}
		
		public function set textSize(value:int):void
		{
			format.size = value;
			updateFormat();
			dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, textField.width, textField.height));
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function set text(value:String):void
		{
			textField.text = value;
			dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, textField.width, textField.height));
		}
		
		public function get textWithFormat():String
		{
			var boldSign:String = (format.bold == true) ? "1" : "0";
			var italicSign:String = (format.italic == true) ? "1" : "0";
			var underlineSign:String = (format.underline == true) ? "1" : "0";
			
			return textField.text + formatKey + boldSign + italicSign + underlineSign;
		}
		
		public function set textWithFormat(value:String):void
		{
			var s:String = value.substring(value.length - (3 + formatKey.length), value.length - 3);
			
			if (value.length >= (3 + formatKey.length) && s == formatKey)
			{
				var boldSign:String = value.charAt(value.length - 3);
				var italicSign:String = value.charAt(value.length - 2);
				var underlineSign:String = value.charAt(value.length - 1);
				
				format.bold = (boldSign == "1") ? true : false;
				format.italic = (italicSign == "1") ? true : false;
				format.underline = (underlineSign == "1") ? true : false;
				
				textField.text = value.substring(0, value.length - (3 + formatKey.length));
			}
			else
				textField.text = value;
			
			updateFormat();
			dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, textField.width, textField.height));
		}
		
		private var _editable:Boolean = true;
		
		public function set editable(value:Boolean):void
		{
			if (value == _editable)
				return;
			else if (value)
				addListeners();
		}
		
		//-----------------------------------------------
		//
		// format changing
		//
		//-----------------------------------------------
		
		public function textBoldOn(onlySelected:Boolean = false):void
		{
			format.bold = true;
			updateFormat(onlySelected);
		}
		
		public function textBoldOff(onlySelected:Boolean = false):void
		{
			format.bold = false;
			updateFormat(onlySelected);
		}
		
		public function textBoldToggle(onlySelected:Boolean = false):void
		{
			format.bold = !Boolean(format.bold);
			updateFormat(onlySelected);
		}
		
		public function textUnderlineOn(onlySelected:Boolean = false):void
		{
			format.underline = true;
			updateFormat(onlySelected);
		}
		
		public function textUnderlineOff(onlySelected:Boolean = false):void
		{
			format.underline = false;
			updateFormat(onlySelected);
		}
		
		public function textUnderlineToggle(onlySelected:Boolean = false):void
		{
			format.underline = !Boolean(format.underline);
			updateFormat(onlySelected);
		}
		
		public function textItalicOn(onlySelected:Boolean = false):void
		{
			format.italic = true;
			updateFormat(onlySelected);
		}
		
		public function textItalicOff(onlySelected:Boolean = false):void
		{
			format.italic = false;
			updateFormat(onlySelected);
		}
		
		public function textItalicToggle(onlySelected:Boolean = false):void
		{
			format.italic = !Boolean(format.italic);
			updateFormat(onlySelected);
		}
		
		public function alignCenterOn():void
		{
			format.align = TextFormatAlign.CENTER;
			updateFormat();
		}
		
		public function alignCenterOff():void
		{
			format.align = TextFormatAlign.LEFT;
			updateFormat();
		}
		
		//-----------------------------------------------
		//
		// default settings for the textfield
		//
		//-----------------------------------------------
		
		private function configureTextField():void
		{
			format.align = TextFormatAlign.LEFT;
			format.size = 12;
			
			textField.defaultTextFormat = format;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.alwaysShowSelection = false;
			textField.doubleClickEnabled = true;
			textField.textColor = 0;
			addChild(textField);
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			textField.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick_Handler);
			textField.addEventListener(KeyboardEvent.KEY_DOWN, textField_keyDownHandler);
			textField.addEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
			textField.addEventListener(TextEvent.TEXT_INPUT, textField_textInputHandler);
		}
		
		private function this_removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			textField.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClick_Handler);
			textField.removeEventListener(KeyboardEvent.KEY_DOWN, textField_keyDownHandler);
			textField.removeEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
			textField.removeEventListener(TextEvent.TEXT_INPUT, textField_textInputHandler);
		}
		
		private function textField_textInputHandler(event:TextEvent):void
		{
			textStack.addItemAt(textWithFormat, 0);
		}
		
		private function updateFormat(onlySelected:Boolean = false):void
		{
			if (onlySelected)
				textField.setTextFormat(format, textField.selectionBeginIndex - 1, textField.selectionEndIndex - 1)
			else
				textField.setTextFormat(format);
			
			textField.defaultTextFormat = format;
		}
		
		//--------------------------------------------------
		//
		// entering the text editing mode on double click
		//
		//--------------------------------------------------
		
		private function doubleClick_Handler(event:MouseEvent):void
		{
			textField.selectable = true;
			textField.type = TextFieldType.INPUT;
			textField.setSelection(0, textField.text.length);
			
			dispatchEvent(new TextFieldEvent(TextFieldEvent.ENTERED_EDITING_MODE));
		}
		
		private function textField_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.DELETE && textField.selectable)
			{
				event.stopImmediatePropagation();
				return;
			}
			
			if (event.keyCode == Keyboard.ENTER && event.shiftKey)
			{
				nextLine();
				return;
			}
			
			if (event.keyCode == Keyboard.I && event.ctrlKey)
			{
				textItalicToggle(false);
				return;
			}
			
			if (event.keyCode == Keyboard.M && event.ctrlKey)
			{
				textUnderlineToggle(false);
				return;
			}
			
			if (event.keyCode == Keyboard.Z && event.ctrlKey)
			{
				undo();
			}
			
			if (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.ESCAPE)
				disableTyping();
		}
		
		private function nextLine():void
		{
			textField.appendText("\n");
			textField.appendText("");
			textField.setSelection(textField.length, textField.length);
			this.dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, textField.width, textField.height));
		}
		
		//--------------------------------------------------------------------------------
		//
		// leaving the text editing mode on focus losing or pressing the "Enter" button
		//
		//---------------------------------------------------------------------------------
		
		private function textField_focusOutHandler(event:FocusEvent):void
		{
			disableTyping();
		}
		
		private function disableTyping():void
		{
			textField.type = TextFieldType.DYNAMIC;
			textField.selectable = false;
			textField.setTextFormat(textField.defaultTextFormat);
			this.dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, textField.width, textField.height));
			dispatchEvent(new TextFieldEvent(TextFieldEvent.LEFT_EDITING_MODE));
			
			if (textField.text == "")
				textField.text = "  ";
		}
		
		public function undo():void
		{
			if (textStack.length == 0 || textField.type != TextFieldType.INPUT)
				return;
			
			textWithFormat = String(textStack.getItemAt(0));
			textStack.removeItemAt(0);
		}
		
		public function redo():void
		{
		
		}
	
	}

}