package items
{
	import events.ButtonEvent;
	import events.ListEvent;
	import events.SizeEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import supportClasses.ArrayList;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class FieldsList extends Sprite
	{
		public static function createFieldsListFromObject(obj:Object):FieldsList
		{
			var list:FieldsList = new FieldsList();
			list.x = obj.x ? obj.x : 0;
			list.y = obj.y ? obj.y : 0;
			list.textToAddForNewFields = obj.textToAddForNewFields;
			
			var fields:Array = obj.fields;
			
			if (fields)
				for each (var s:String in fields)
					list.addField(s);
			
			return list;
		}
		
		public var paddingLeft:Number = 1;
		public var horizontalGap:Number = 10;
		public var verticalGap:Number = 20;
		public var buttonSize:Number = 12;
		public var textToAddForNewFields:String = "unnamed";
		public var addIndexesToNames:Boolean = true;
		
		private var newNameIndexCount:int = 0;
		private var fields:ArrayList = new ArrayList();
		private var buttons:ArrayList = new ArrayList();
		private var addButton:Button = new Button("+");
		private var collapseButton:ToggleButton = new ToggleButton("+", "-");
		
		private var ghostLabel:Sprite = new Sprite();
		private var ghostTextField:AdvancedField = new AdvancedField();
		private var isDragging:Boolean = false;
		
		public function FieldsList()
		{
			super();
			addEmptyField();
			if (stage)
				addListeners();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		private function addedToStageListener(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			addListeners();
		}
		
		override public function get width():Number
		{
			return calcMaxWidth();
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function get height():Number
		{
			return calcTotalHeight();
		}
		
		override public function set height(value:Number):void
		{
		}
		
		public function get length():int
		{
			return buttons.length;
		}
		
		private function setAddButtonAppearance(button:Button):void
		{
			button.buttonHeight = buttonSize;
			button.buttonWidth = buttonSize;
			button.buttonColor = 0x00FF00;
			button.buttonStrokeColor = 0xBBBBBB;
			button.buttonAlphaUp = 0.8;
			button.buttonAlphaDown = 1;
			button.textSize = 12;
			button.setBoldOn();
			button.textColor = 0xFFFFFF;
			button.textOffsetX = 1;
			button.textOffsetY = -3;
		}
		
		private function setRemoveButtonAppearance(button:Button):void
		{
			button.buttonHeight = buttonSize;
			button.buttonWidth = buttonSize;
			button.buttonColor = 0xFF0000;
			button.buttonStrokeColor = 0xBBBBBB;
			button.buttonAlphaUp = 0.8;
			button.buttonAlphaDown = 1;
			button.textSize = 12;
			button.setBoldOn();
			button.textColor = 0xFFFFFF;
			button.textOffsetX = 1;
			button.textOffsetY = -5;
		}
		
		private function setCollapseButtonAppearance(button:ToggleButton):void
		{
			button.buttonHeight = buttonSize;
			button.buttonWidth = buttonSize;
			button.buttonColor = 0xAAAAAA;
			button.buttonStrokeColor = 0xBBBBBB;
			button.buttonAlphaUp = 0.8;
			button.buttonAlphaDown = 1;
			
			var upImage:Sprite = new Sprite();
			upImage.graphics.lineStyle(1, 0x555555);
			upImage.graphics.beginFill(0x555555, 1);
			upImage.graphics.moveTo(0, 0);
			upImage.graphics.lineTo(5, 5);
			upImage.graphics.lineTo(10, 0);
			upImage.graphics.lineTo(0, 0);
			
			button.upImage = upImage;
			
			var downImage:Sprite = new Sprite();
			downImage.graphics.lineStyle(1, 0x555555);
			downImage.graphics.beginFill(0x555555, 1);
			downImage.graphics.moveTo(0, 5);
			downImage.graphics.lineTo(5, 0);
			downImage.graphics.lineTo(10, 5);
			downImage.graphics.lineTo(0, 5);
			
			button.downImage = downImage;
			
			button.imageOffsetX = 1;
			button.imageOffsetY = 3;
			
			button.setDown();
		}
		
		private function addEmptyField():void
		{
			setAddButtonAppearance(addButton);
			addButton.x = paddingLeft;
			addButton.y = 3;
			addChild(addButton);
			
			setCollapseButtonAppearance(collapseButton);
			collapseButton.x = paddingLeft + 3 + addButton.width;
			collapseButton.y = 3;
			addChild(collapseButton);
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			addButton.addEventListener(ButtonEvent.BUTTON_CLICK, addButton_clickHandler);
			collapseButton.addEventListener(ButtonEvent.BUTTON_CLICK, collapseButton_clickHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, fieldsList_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		private function deactivate():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			addButton.removeEventListener(ButtonEvent.BUTTON_CLICK, addButton_clickHandler);
			collapseButton.removeEventListener(ButtonEvent.BUTTON_CLICK, collapseButton_clickHandler);
			removeEventListener(MouseEvent.MOUSE_MOVE, fieldsList_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			removeAllFields();
		}
		
		private function this_removedFromStageHandler(event:Event):void
		{
			deactivate();
		}
		
		private function addButton_clickHandler(event:ButtonEvent):void
		{
			var newName:String = (addIndexesToNames) ? (textToAddForNewFields + ++newNameIndexCount) : textToAddForNewFields;
			addField(newName);
		}
		
		private var memorizedArray:Array = [];
		
		private function collapseButton_clickHandler(event:ButtonEvent):void
		{
			if (length == 0 && memorizedArray.length == 0)
			{
				collapseButton.setDown();
				return;
			}
			
			if (collapseButton.isUpState())
			{
				memorizedArray = getFieldsArrayString();
				removeAllFields();
			}
			else
				addFieldsFromArray(memorizedArray);
		}
		
		private function addFieldsFromArray(array:Array):void
		{
			for each (var s:String in array)
				addField(s);
		}
		
		public function addField(label:String = ""):void
		{
			var removeButton:Button = new Button("-");
			setRemoveButtonAppearance(removeButton);
			removeButton.x = paddingLeft;
			removeButton.y = calcPropertiesListHeight() + 5;
			removeButton.addEventListener(ButtonEvent.BUTTON_CLICK, removeButton_clickHandler);
			addChild(removeButton);
			buttons.addItem(removeButton);
			removeButton.id = "" + (length - 1);
			
			var field:AdvancedField = new AdvancedField();
			field.id = "" + (length - 1);
			field.textWithFormat = label;
			addListenersForField(field);
			addChild(field);
			field.x = paddingLeft + buttonSize + horizontalGap;
			field.y = calcPropertiesListHeight();
			fields.addItem(field);
			
			addButton.y = calcPropertiesListHeight() + 5;
			collapseButton.y = calcPropertiesListHeight() + 5;
			this.dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, 0, calcTotalHeight()));
		}
		
		public function addFieldAt(label:String, index:int):void
		{
			var removeButton:Button = new Button("-");
			setRemoveButtonAppearance(removeButton);
			removeButton.x = paddingLeft;
			removeButton.y = index * verticalGap + 5;
			removeButton.addEventListener(ButtonEvent.BUTTON_CLICK, removeButton_clickHandler);
			addChild(removeButton);
			buttons.addItemAt(removeButton, index);
			
			var field:AdvancedField = new AdvancedField();
			field.textWithFormat = label;
			addListenersForField(field);
			addChild(field);
			field.x = paddingLeft + buttonSize + horizontalGap;
			field.y = index * verticalGap;
			fields.addItemAt(field, index);
			
			moveElementsDownStartingFromIndex(index + 1);
			apdateIDS();
			
			this.dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, 0, calcTotalHeight()));
		}
		
		private function addListenersForField(field:AdvancedField):void
		{
			field.addEventListener(SizeEvent.SIZE_CHANGED, fieldSizeChangedHandler);
			field.addEventListener(MouseEvent.MOUSE_DOWN, field_mouseDownHandler);
			field.addEventListener(MouseEvent.MOUSE_OUT, field_mouseOutHandler);
			field.addEventListener(MouseEvent.MOUSE_UP, field_mouseUpHandler);
			field.addEventListener(MouseEvent.MOUSE_OVER, field_mouseOverHandler);
		}
		
		private function removeListenersFromField(field:AdvancedField):void
		{
			field.removeEventListener(SizeEvent.SIZE_CHANGED, fieldSizeChangedHandler);
			field.removeEventListener(MouseEvent.MOUSE_DOWN, field_mouseDownHandler);
			field.removeEventListener(MouseEvent.MOUSE_OUT, field_mouseOutHandler);
			field.removeEventListener(MouseEvent.MOUSE_UP, field_mouseUpHandler);
			field.removeEventListener(MouseEvent.MOUSE_OVER, field_mouseOverHandler);
		}
		
		///// Drag and drop
		
		private var dragging:Boolean = false;
		private var draggedID:String = "-1";
		private var mouseDown:Boolean = false;
		
		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			if (dragging)
				dispatchEvent(new ListEvent(ListEvent.DROP));
			
			draggedID = "-1";
			dragging = false;
			ghostLabel.graphics.clear();
			ghostTextField.visible = false;
			mouseDown = false;
		}
		
		private function fieldsList_mouseMoveHandler(event:MouseEvent):void
		{
			if (dragging)
			{
				var locPoint:Point = globalToLocal(new Point(event.stageX, event.stageY));
				
				ghostLabel.graphics.clear();
				ghostLabel.graphics.lineStyle(1, 0x5F5F5F);
				ghostLabel.graphics.beginFill(0x5F5F5F, 0.5);
				ghostLabel.graphics.drawRect(0, 0, calcMaxWidth(), 20);
				ghostLabel.addChild(ghostTextField);
				ghostTextField.visible = true;
				ghostTextField.textWithFormat = fields.getItemAt(int(draggedID)).textWithFormat;
				addChild(ghostLabel);
				ghostLabel.x = locPoint.x + 5;
				ghostLabel.y = locPoint.y - 10;
			}
		}
		
		private function field_mouseDownHandler(event:MouseEvent):void
		{
			var field:AdvancedField = event.currentTarget as AdvancedField;
			
			graphics.clear();
			graphics.lineStyle(2, 0x44C4FB);
			graphics.drawRect(field.x, field.y, field.width, field.height);
			
			mouseDown = true;
			dispatchEvent(new ListEvent(ListEvent.DRAG));
		}
		
		private function field_mouseOutHandler(event:MouseEvent):void
		{
			var field:AdvancedField = event.currentTarget as AdvancedField;
			
			if (mouseDown)
			{
				graphics.clear();
				draggedID = field.id;
				
				//drag
				dragging = true;
				mouseDown = false;
			}
		}
		
		private function field_mouseOverHandler(event:MouseEvent):void
		{
			var field:AdvancedField = event.currentTarget as AdvancedField;
			
			if (dragging)
			{
				graphics.clear();
				graphics.lineStyle(2, 0x44C4FB);
				graphics.drawRect(field.x, field.y, field.width, field.height);
			}
		}
		
		private function field_mouseUpHandler(event:MouseEvent):void
		{
			graphics.clear();
			
			if (dragging)
			{
				var text:String = AdvancedField(fields.getItemAt(int(draggedID))).textWithFormat;
				removeFieldAt(int(draggedID));
				
				var dropID:int = (int(AdvancedField(event.currentTarget).id) >= int(draggedID)) ? (int(AdvancedField(event.currentTarget).id) + 1) : int(AdvancedField(event.currentTarget).id);
				if (dropID > fields.length)
					dropID = fields.length;
				
				addFieldAt(text, dropID);
			}
			
			dragging = false;
			ghostLabel.graphics.clear();
			ghostTextField.visible = false;
			
			mouseDown = false;
			
			dispatchEvent(new ListEvent(ListEvent.DROP));
		}
		
		private function removeButton_clickHandler(event:ButtonEvent):void
		{
			var button:Button = event.currentTarget as Button;
			
			if (!button)
				return;
			
			removeFieldAt(int(button.id));
		}
		
		public function removeFieldAt(index:int):void
		{
			var button:Button = Button(buttons.getItemAt(index));
			button.removeEventListener(ButtonEvent.BUTTON_CLICK, removeButton_clickHandler);
			removeListenersFromField(AdvancedField(fields.getItemAt(index)));
			
			removeChild(button);
			removeChild(AdvancedField(fields.getItemAt(index)));
			
			buttons.removeItemAt(index);
			fields.removeItemAt(index);
			apdateIDS();
			
			moveElementsUpStartingFromIndex(index);
			
			this.dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, 0, calcTotalHeight()));
		}
		
		public function removeAllFields():void
		{
			var len:int = length;
			
			for (var i:int = 0; i < len; i++)
				removeFieldAt(0);
		}
		
		private function moveElementsUpStartingFromIndex(index:int):void
		{
			for (var i:int = index; i < length; i++)
			{
				Button(buttons.getItemAt(i)).y -= verticalGap;
				AdvancedField(fields.getItemAt(i)).y -= verticalGap;
			}
			
			addButton.y -= verticalGap;
			collapseButton.y -= verticalGap;
		}
		
		private function moveElementsDownStartingFromIndex(index:int):void
		{
			for (var i:int = index; i < length; i++)
			{
				Button(buttons.getItemAt(i)).y += verticalGap;
				AdvancedField(fields.getItemAt(i)).y += verticalGap;
			}
			
			addButton.y += verticalGap;
			collapseButton.y += verticalGap;
		}
		
		private function apdateIDS():void
		{
			for (var i:int = 0; i < length; i++)
			{
				Button(buttons.getItemAt(i)).id = "" + i;
				AdvancedField(fields.getItemAt(i)).id = "" + i;
			}
		}
		
		private function calcPropertiesListHeight():Number
		{
			return fields.length * verticalGap;
		}
		
		private function calcTotalHeight():Number
		{
			return calcPropertiesListHeight() + addButton.buttonHeight;
		}
		
		private function calcMaxWidth():Number
		{
			var mWidth:Number = 0;
			
			for each (var f:AdvancedField in fields.source)
				if (f.width > mWidth)
					mWidth = f.width;
			
			return (mWidth + buttonSize + horizontalGap);
		}
		
		private function fieldSizeChangedHandler(event:SizeEvent):void
		{
			this.dispatchEvent(new SizeEvent(SizeEvent.SIZE_CHANGED, calcMaxWidth(), calcTotalHeight()));
		}
		
		public function getFieldsArrayString():Array
		{
			var result:Array = [];
			
			for each (var f:AdvancedField in fields.source)
				result.push(f.textWithFormat);
			
			return result;
		}
	
	}

}