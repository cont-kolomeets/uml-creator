package panels
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import items.MovableObject;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class HelpPanelInterface extends MovableObject
	{
		public function HelpPanelInterface()
		{
			super();
			
			drawPanel();
			constructText();
		}
		
		private function drawPanel():void
		{
			graphics.clear();
			
			graphics.lineStyle(2, 0x555555);
			graphics.beginFill(0xAAAAAA);
			graphics.drawRect(0, 0, 330, 25);
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(0, 20, 330, 290);
			
			var format:TextFormat = new TextFormat();
			format.size = 13;
			format.font = "Comic Sans MS";
			format.bold = true;
			
			var textField:TextField = new TextField();
			textField.defaultTextFormat = format;
			textField.selectable = false;
			textField.text = "Help";
			addChild(textField);
		
		}
		
		private function constructText():void
		{
			var format:TextFormat = new TextFormat();
			format.size = 13;
			format.font = "Comic Sans MS";
			
			var textField:TextField = new TextField();
			textField.defaultTextFormat = format;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = "";
			textField.appendText("F1				- help.\n");
			textField.appendText("Ctrl + L			- open file with UML diagram.\n");
			textField.appendText("Ctrl + S			- save current UML diagram.\n");
			textField.appendText("Ctrl + Shift + N	- clear everything.\n");
			textField.appendText("*					- menu to add new classes.\n");
			textField.appendText("del				- delete selected class.\n");
			textField.appendText("Ctrl + Number(1-9)- adding corresponding elements.\n");
			textField.appendText("Ctrl + D			- duplicate selected class.\n");
			textField.appendText("+					- zoom in.\n");
			textField.appendText("-					- zoom out.\n");
			textField.appendText(".					- clear zoom.\n");
			textField.appendText("arrows 			- pan view.\n");
			textField.appendText("Ctrl + I			- make text italic.\n");
			textField.appendText("Ctrl + M			- make text underlined.\n");
			textField.appendText("Shift + Enter		- start a new line.\n");
			
			textField.x = 10;
			textField.y = 30;
			
			addChild(textField);
		}
	
	}

}