package panels
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import items.Button;
	import items.MovableObject;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class AddPanelInterface extends MovableObject
	{
		public var btnAddClass:Button = new Button("Class");
		public var btnAddInterface:Button = new Button("Interface");
		public var btnAddAClass:Button = new Button("Abstract Class");
		public var btnAddMXML:Button = new Button("MXML Component");
		public var btnAddSkin:Button = new Button("Skin");
		public var btnAddFile:Button = new Button("File");
		public var btnAddComment:Button = new Button("Comment");
		public var btnAddRect:Button = new Button();
		public var btnAddDiamond:Button = new Button();
		
		public function AddPanelInterface()
		{
			super();
			
			drawPanel();
			constructButtons();
		}
		
		private function drawPanel():void
		{
			graphics.clear();
			
			graphics.lineStyle(2, 0x555555);
			graphics.beginFill(0xAAAAAA);
			graphics.drawRect(0, 0, 120, 20);
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(0, 20, 120, 250);
			
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.font = "Comic Sans MS";
			format.bold = true;
			
			var textField:TextField = new TextField();
			textField.defaultTextFormat = format;
			textField.selectable = false;
			textField.text = "Adding";
			addChild(textField);
		
		}
		
		private function constructButtons():void
		{
			btnAddClass.cornerRadius = 30;
			btnAddClass.buttonColor = 0x00FF00;
			btnAddClass.buttonAlphaUp = 1;
			btnAddClass.buttonStrokeWeight = 2;
			btnAddClass.x = 10;
			btnAddClass.y = 30;
			btnAddClass.font = "Comic Sans MS";
			btnAddClass.setBoldOff();
			
			btnAddInterface.cornerRadius = 30;
			btnAddInterface.buttonColor = 0xA05CF3;
			btnAddInterface.buttonAlphaUp = 1;
			btnAddInterface.buttonStrokeWeight = 2;
			btnAddInterface.x = 10;
			btnAddInterface.y = 60;
			btnAddInterface.font = "Comic Sans MS";
			btnAddInterface.setBoldOff();
			
			btnAddAClass.cornerRadius = 30;
			btnAddAClass.buttonColor = 0xEF5F21;
			btnAddAClass.buttonAlphaUp = 1;
			btnAddAClass.buttonStrokeWeight = 2;
			btnAddAClass.x = 10;
			btnAddAClass.y = 90;
			btnAddAClass.font = "Comic Sans MS";
			btnAddAClass.setBoldOff();
			
			btnAddMXML.cornerRadius = 30;
			btnAddMXML.buttonColor = 0x888888;
			btnAddMXML.buttonAlphaUp = 1;
			btnAddMXML.buttonStrokeWeight = 2;
			btnAddMXML.x = 10;
			btnAddMXML.y = 120;
			btnAddMXML.font = "Comic Sans MS";
			btnAddMXML.setBoldOff();
			
			btnAddSkin.cornerRadius = 30;
			btnAddSkin.buttonColor = 0x115FFF;
			btnAddSkin.buttonAlphaUp = 1;
			btnAddSkin.buttonStrokeWeight = 2;
			btnAddSkin.x = 10;
			btnAddSkin.y = 150;
			btnAddSkin.font = "Comic Sans MS";
			btnAddSkin.setBoldOff();
			
			btnAddFile.cornerRadius = 30;
			btnAddFile.buttonColor = 0xFF48CD;
			btnAddFile.buttonAlphaUp = 1;
			btnAddFile.buttonStrokeWeight = 2;
			btnAddFile.x = 10;
			btnAddFile.y = 180;
			btnAddFile.font = "Comic Sans MS";
			btnAddFile.setBoldOff();
			
			btnAddComment.cornerRadius = 30;
			btnAddComment.buttonColor = 0xFFFF80;
			btnAddComment.buttonAlphaUp = 1;
			btnAddComment.buttonStrokeWeight = 2;
			btnAddComment.x = 10;
			btnAddComment.y = 210;
			btnAddComment.font = "Comic Sans MS";
			btnAddComment.setBoldOff();
			
			var rect:Sprite = new Sprite();
			rect.graphics.lineStyle(2, 0);
			rect.graphics.drawRect(0, 0, 60, 10);
			
			btnAddRect.cornerRadius = 30;
			btnAddRect.buttonColor = 0x81FEE1;
			btnAddRect.buttonAlphaUp = 1;
			btnAddRect.buttonStrokeWeight = 2;
			btnAddRect.width = 45;
			btnAddRect.x = 10;
			btnAddRect.y = 240;
			btnAddRect.image = rect;
			btnAddRect.imageOffsetX = 20;
			btnAddRect.imageOffsetY = 5;
			
			var diamond:Sprite = new Sprite();
			diamond.graphics.lineStyle(2, 0);
			diamond.graphics.moveTo(30, 7);
			diamond.graphics.lineTo(60, 0);
			diamond.graphics.lineTo(30, -7);
			diamond.graphics.lineTo(0, 0);
			diamond.graphics.lineTo(30, 7);
			
			btnAddDiamond.cornerRadius = 30;
			btnAddDiamond.buttonColor = 0xF2393E;
			btnAddDiamond.buttonAlphaUp = 1;
			btnAddDiamond.buttonStrokeWeight = 2;
			btnAddDiamond.width = 45;
			btnAddDiamond.x = 60;
			btnAddDiamond.y = 240;
			btnAddDiamond.image = diamond;
			btnAddDiamond.imageOffsetX = 20;
			btnAddDiamond.imageOffsetY = 10;
			
			addChild(btnAddClass);
			addChild(btnAddInterface);
			addChild(btnAddAClass);
			addChild(btnAddMXML);
			addChild(btnAddSkin);
			addChild(btnAddFile);
			addChild(btnAddComment);
			addChild(btnAddRect);
			addChild(btnAddDiamond);
		}
	
	}

}