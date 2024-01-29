package items
{
	import events.CardEvent;
	import events.KnotEvent;
	import events.MoveEvent;
	import events.SizeEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import supportClasses.Constants;
	import supportClasses.ISerializable;
	import supportClasses.Utils;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Card extends MovableObject implements ISerializable
	{
		public static function createCardFromObject(obj:Object):Card
		{
			var card:Card = new Card(obj.type);
			
			card.implementDeserializedProperties(obj);
			
			return card;
		}
		
		public var type:String;
		public var knots:Array = [];
		public var uniqueKey:String = "card-" + Utils.generateUniqueID();
		
		private var cardWidth:Number = Constants.CARD_DEFAULT_WIDTH;
		private var cardNameHeight:Number = Constants.CARD_DEFAULT_SECTION_HEIGHT;
		private var cardAttributesHeight:Number = Constants.CARD_DEFAULT_SECTION_HEIGHT;
		private var cardMethodsHeight:Number = Constants.CARD_DEFAULT_SECTION_HEIGHT;
		
		private var knotEditingMode:Boolean = false;
		
		private var nameField:AdvancedField = new AdvancedField();
		
		private var attributesList:FieldsList = new FieldsList();
		private var methodsList:FieldsList = new FieldsList();
		private var upperKnot:Knot;
		private var lowerKnot:Knot;
		private var leftKnot:Knot;
		private var rightUpperKnot:Knot;
		private var rightLowerKnot:Knot;
		
		public function Card(type:String)
		{
			this.type = type;
			createFields();
			createKnots();
			drawCard();
			addListeners();
		}
		
		private var _selected:Boolean = false;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			drawCard();
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			addEventListener(MoveEvent.MOVED, card_moveHandler);
			nameField.addEventListener(SizeEvent.SIZE_CHANGED, contentSizeChangedHandler);
			attributesList.addEventListener(SizeEvent.SIZE_CHANGED, attributesList_sizeChangedHandler);
			methodsList.addEventListener(SizeEvent.SIZE_CHANGED, methodsList_sizeChangedHandler);
		}
		
		private function removeListeners():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			removeEventListener(MoveEvent.MOVED, card_moveHandler);
			nameField.removeEventListener(SizeEvent.SIZE_CHANGED, contentSizeChangedHandler);
			attributesList.removeEventListener(SizeEvent.SIZE_CHANGED, attributesList_sizeChangedHandler);
			methodsList.removeEventListener(SizeEvent.SIZE_CHANGED, methodsList_sizeChangedHandler);
		}
		
		private function this_removedFromStageHandler(event:Event):void
		{
			deactivate();
		}
		
		private function deactivate():void
		{
			removeListeners();
			for each (var knot:Knot in knots)
			{
				removeListenersFromKnot(knot);
				for each (var thread:Thread in knot.threads.source)
					thread.disconnect();
			}
		}
		
		private function card_moveHandler(event:MoveEvent):void
		{
			notifyKnots();
		}
		
		public function notifyKnots():void
		{
			for each (var knot:Knot in knots)
				knot.dispatchEvent(new MoveEvent(MoveEvent.MOVED));
		}
		
		private function createKnots():void
		{
			upperKnot = new Knot(KnotType.POINT, KnotPosition.TOP);
			
			if (type == CardType.FILE || type == CardType.COMMENT || type == CardType.RECTANGLE || type == CardType.DIAMOND)
				lowerKnot = new Knot(KnotType.POINT, KnotPosition.BOTTOM);
			else
				lowerKnot = new Knot(KnotType.FILLED_ARROW, KnotPosition.BOTTOM, type);
			
			leftKnot = new Knot(KnotType.POINT, KnotPosition.LEFT);
			
			if (type == CardType.FILE || type == CardType.COMMENT || type == CardType.RECTANGLE || type == CardType.DIAMOND)
				rightUpperKnot = new Knot(KnotType.POINT, KnotPosition.RIGHT);
			else
				rightUpperKnot = new Knot(KnotType.DIAMOND, KnotPosition.RIGHT);
			
			rightLowerKnot = new Knot(KnotType.POINT, KnotPosition.RIGHT);
			
			initializeKnot(upperKnot);
			initializeKnot(lowerKnot);
			initializeKnot(leftKnot);
			initializeKnot(rightUpperKnot);
			initializeKnot(rightLowerKnot);
		}
		
		private function initializeKnot(knot:Knot):void
		{
			addListenersForKnot(knot);
			addChild(knot);
			knots.push(knot);
		}
		
		private function addListenersForKnot(knot:Knot):void
		{
			knot.addEventListener(KnotEvent.MOUSE_OVER_KNOT, knot_mouseOverHandler);
			knot.addEventListener(KnotEvent.MOUSE_OUT_KNOT, knot_mouseOutHandler);
			knot.addEventListener(KnotEvent.DRAWING_PSEUDO_CONNECTION, knot_drawingConnectionHandler);
			knot.addEventListener(KnotEvent.DRAWING_PSEUDO_CONNECTION_FINISHED, knot_drawingConnectionFinishedHandler);
			knot.addEventListener(KnotEvent.DISCONNECT, knot_disconnectHandler);
		}
		
		private function removeListenersFromKnot(knot:Knot):void
		{
			knot.removeEventListener(KnotEvent.MOUSE_OVER_KNOT, knot_mouseOverHandler);
			knot.removeEventListener(KnotEvent.MOUSE_OUT_KNOT, knot_mouseOutHandler);
			knot.removeEventListener(KnotEvent.DRAWING_PSEUDO_CONNECTION, knot_drawingConnectionHandler);
			knot.removeEventListener(KnotEvent.DRAWING_PSEUDO_CONNECTION_FINISHED, knot_drawingConnectionFinishedHandler);
			knot.removeEventListener(KnotEvent.DISCONNECT, knot_disconnectHandler);
		}
		
		private function knot_mouseOverHandler(event:KnotEvent):void
		{
			knotEditingMode = true;
			if (event.currentTarget is Knot)
				dispatchEvent(new CardEvent(CardEvent.KNOT_MOUSE_OVER, event.currentTarget as Knot));
		}
		
		private function knot_mouseOutHandler(event:KnotEvent):void
		{
			knotEditingMode = false;
		}
		
		private function knot_drawingConnectionHandler(event:KnotEvent):void
		{
			if (event.currentTarget is Knot)
				dispatchEvent(new CardEvent(CardEvent.KNOT_EDITING_STARTED, event.currentTarget as Knot));
		}
		
		private function knot_drawingConnectionFinishedHandler(event:KnotEvent):void
		{
			if (event.currentTarget is Knot)
				dispatchEvent(new CardEvent(CardEvent.KNOT_EDITING_FINISHED, event.currentTarget as Knot));
		}
		
		private function knot_disconnectHandler(event:KnotEvent):void
		{
			if (event.currentTarget is Knot)
				dispatchEvent(new CardEvent(CardEvent.DISCONNECT_KNOT, event.currentTarget as Knot));
		}
		
		private function createFields():void
		{
			if (type != CardType.COMMENT && type != CardType.RECTANGLE && type != CardType.DIAMOND)
			{
				nameField.text = "unnamed";
				
				if (type == CardType.ABSTRACT_CLASS)
					nameField.textItalicOn();
				
				nameField.textBoldOn();
				
				attributesList.textToAddForNewFields = "property";
				methodsList.textToAddForNewFields = "method";
				
				addChild(attributesList);
				addChild(methodsList);
			}
			else if (type == CardType.COMMENT)
				nameField.text = "comment";
			else
				nameField.text = "text";
			
			if (type == CardType.DIAMOND)
				nameField.alignCenterOn();
			
			addChild(nameField);
		}
		
		override protected function mouseDownHandler(event:MouseEvent):void
		{
			if (!knotEditingMode)
				super.mouseDownHandler(event);
		}
		
		private function contentSizeChangedHandler(event:SizeEvent):void
		{
			cardNameHeight = (event.height < Constants.CARD_DEFAULT_SECTION_HEIGHT) ? Constants.CARD_DEFAULT_SECTION_HEIGHT : event.height;
			
			setOptimalWidth();
			drawCard();
		}
		
		private function attributesList_sizeChangedHandler(event:SizeEvent):void
		{
			cardAttributesHeight = (event.height < Constants.CARD_DEFAULT_SECTION_HEIGHT) ? Constants.CARD_DEFAULT_SECTION_HEIGHT : (event.height + 10);
			
			setOptimalWidth();
			drawCard();
		}
		
		private function methodsList_sizeChangedHandler(event:SizeEvent):void
		{
			cardMethodsHeight = (event.height < Constants.CARD_DEFAULT_SECTION_HEIGHT) ? Constants.CARD_DEFAULT_SECTION_HEIGHT : (event.height + 10);
			
			setOptimalWidth();
			drawCard();
		}
		
		private function setOptimalWidth():void
		{
			cardWidth = Math.max(nameField.width, attributesList.width, methodsList.width);
			cardWidth = (cardWidth < Constants.CARD_DEFAULT_WIDTH) ? Constants.CARD_DEFAULT_WIDTH : cardWidth;
		}
		
		private function drawCard():void
		{
			graphics.clear();
			
			var lineColor:int = 0;
			var fillColor:int = 0;
			
			switch (type)
			{
				case CardType.CLASS: 
					lineColor = Constants.CLASS_LINE_COLOR;
					fillColor = Constants.CLASS_FILL_COLOR;
					break;
				
				case CardType.INTERFACE: 
					lineColor = Constants.INTERFACE_LINE_COLOR;
					fillColor = Constants.INTERFACE_FILL_COLOR;
					break;
				
				case CardType.ABSTRACT_CLASS: 
					lineColor = Constants.ACLASS_LINE_COLOR;
					fillColor = Constants.ACLASS_FILL_COLOR;
					break;
				
				case CardType.MXML_COMPONENT: 
					lineColor = Constants.MXML_CLASS_LINE_COLOR;
					fillColor = Constants.MXML_CLASS_FILL_COLOR;
					break;
				
				case CardType.SKIN_CLASS: 
					lineColor = Constants.SKIN_CLASS_LINE_COLOR;
					fillColor = Constants.SKIN_CLASS_FILL_COLOR;
					break;
				
				case CardType.FILE: 
					lineColor = Constants.FILE_LINE_COLOR;
					fillColor = Constants.FILE_FILL_COLOR;
					break;
				
				case CardType.COMMENT: 
					lineColor = Constants.COMMENT_LINE_COLOR;
					fillColor = Constants.COMMENT_FILL_COLOR;
					break;
				
				case CardType.RECTANGLE: 
					lineColor = Constants.RECT_LINE_COLOR;
					fillColor = Constants.RECT_FILL_COLOR;
					break;
				
				case CardType.DIAMOND: 
					lineColor = Constants.DIAMOND_LINE_COLOR;
					fillColor = Constants.DIAMOND_FILL_COLOR;
					break;
			}
			
			graphics.lineStyle(2, lineColor, 0.8);
			graphics.beginFill(fillColor, (type == CardType.DIAMOND ? 0.8 : 0.5));
			
			if (type != CardType.COMMENT && type != CardType.RECTANGLE && type != CardType.DIAMOND)
			{
				graphics.drawRect(0, 0, cardWidth, cardNameHeight);
				graphics.drawRect(0, cardNameHeight, cardWidth, cardAttributesHeight);
				graphics.drawRect(0, cardNameHeight + cardAttributesHeight, cardWidth, cardMethodsHeight);
				
				if (selected)
				{
					graphics.lineStyle(2, Constants.SELECTED_LINE_COLOR, 0.8);
					graphics.endFill();
					graphics.drawRect(-2, -2, cardWidth + 4, cardNameHeight + cardAttributesHeight + cardMethodsHeight + 4);
				}
				
				attributesList.y = cardNameHeight;
				methodsList.y = cardNameHeight + cardAttributesHeight;
			}
			else
			{
				if (type == CardType.COMMENT)
				{
					graphics.moveTo(cardWidth + 10, -10);
					graphics.lineTo(cardWidth + 10, cardNameHeight + 10);
					graphics.lineTo(-10, cardNameHeight + 10);
					graphics.lineTo(-10, 0);
					graphics.lineTo(0, -10);
					graphics.lineTo(cardWidth + 10, -10);
					graphics.moveTo(-10, 0);
					graphics.lineTo(0, 0);
					graphics.lineTo(0, -10);
					graphics.moveTo(0, 0);
					
					if (selected)
					{
						graphics.lineStyle(2, Constants.SELECTED_LINE_COLOR, 0.8);
						graphics.endFill();
						//graphics.drawRect(-12, -12, cardWidth + 24, cardNameHeight + 24);
						graphics.moveTo(cardWidth + 12, -12);
						graphics.lineTo(cardWidth + 12, cardNameHeight + 12);
						graphics.lineTo(-12, cardNameHeight + 12);
						graphics.lineTo(-12, 0);
						graphics.lineTo(0, -12);
						graphics.lineTo(cardWidth + 12, -12);
					}
				}
				
				if (type == CardType.RECTANGLE)
				{
					graphics.drawRect(0, 0, cardWidth, cardNameHeight);
					
					if (selected)
					{
						graphics.lineStyle(2, Constants.SELECTED_LINE_COLOR, 0.8);
						graphics.endFill();
						graphics.drawRect(-2, -2, cardWidth + 4, cardNameHeight + 4);
					}
				}
				
				if (type == CardType.DIAMOND)
				{
					graphics.moveTo(cardWidth / 2, 1.5 * cardNameHeight);
					graphics.lineTo(-20, cardNameHeight / 2);
					graphics.lineTo(cardWidth / 2, -0.5 * cardNameHeight);
					graphics.lineTo(cardWidth + 20, cardNameHeight / 2);
					graphics.lineTo(cardWidth / 2, 1.5 * cardNameHeight);
					
					if (selected)
					{
						graphics.lineStyle(2, Constants.SELECTED_LINE_COLOR, 0.8);
						graphics.endFill();
						graphics.moveTo(cardWidth / 2, 1.5 * cardNameHeight + 2);
						graphics.lineTo(-22, cardNameHeight / 2);
						graphics.lineTo(cardWidth / 2, -0.5 * cardNameHeight - 2);
						graphics.lineTo(cardWidth + 22, cardNameHeight / 2);
						graphics.lineTo(cardWidth / 2, 1.5 * cardNameHeight + 2);
					}
				}
				
			}
			
			updateKnotsPosition();
		}
		
		private function updateKnotsPosition():void
		{
			var cardHeight:Number = (type != CardType.COMMENT && type != CardType.RECTANGLE && type != CardType.DIAMOND) ? (cardNameHeight + cardAttributesHeight + cardMethodsHeight) : cardNameHeight;
			
			upperKnot.x = cardWidth / 2;
			upperKnot.y = ((type == CardType.COMMENT) ? -10 : 0) + ((type == CardType.DIAMOND) ? -10 : 0);
			lowerKnot.x = cardWidth / 2;
			lowerKnot.y = cardHeight + ((type == CardType.COMMENT) ? 10 : 0) + ((type == CardType.DIAMOND) ? 10 : 0);
			leftKnot.x = ((type == CardType.COMMENT) ? -10 : 0) + ((type == CardType.DIAMOND) ? -20 : 0);
			leftKnot.y = cardHeight / 2;
			rightUpperKnot.x = cardWidth + ((type == CardType.COMMENT) ? 10 : 0) + ((type == CardType.DIAMOND) ? 20 : 0);
			rightUpperKnot.y = cardHeight / 2 + ((type == CardType.COMMENT) ? 0 : -10) + ((type == CardType.DIAMOND) ? 10 : 0);
			rightLowerKnot.x = cardWidth + ((type == CardType.COMMENT) ? 10 : 0) + ((type == CardType.DIAMOND) ? 20 : 0);
			rightLowerKnot.y = cardHeight / 2 + ((type == CardType.COMMENT) ? 0 : 10) + ((type == CardType.DIAMOND) ? -10 : 0);
			
			notifyKnots();
		}
		
		public function serialize():Object
		{
			var obj:Object = new Object();
			
			obj.type = type;
			obj.x = x;
			obj.y = y;
			obj.name = nameField.textWithFormat;
			obj.attributes = attributesList.getFieldsArrayString();
			obj.methods = methodsList.getFieldsArrayString();
			obj.uniqueKey = uniqueKey;
			
			obj.leftKnotUniqueKey = leftKnot.uniqueKey;
			obj.rightUpperKnotUniqueKey = rightUpperKnot.uniqueKey;
			obj.rightLowerKnotUniqueKey = rightLowerKnot.uniqueKey;
			obj.upperKnotUniqueKey = upperKnot.uniqueKey;
			obj.lowerKnotUniqueKey = lowerKnot.uniqueKey;
			
			return obj;
		}
		
		public function implementDeserializedProperties(obj:Object):void
		{
			nameField.textWithFormat = obj.name ? obj.name : "unnamed";
			x = obj.x ? obj.x : 0;
			y = obj.y ? obj.y : 0;
			uniqueKey = obj.uniqueKey;
			
			leftKnot.uniqueKey = obj.leftKnotUniqueKey;
			rightUpperKnot.uniqueKey = obj.rightUpperKnotUniqueKey;
			rightLowerKnot.uniqueKey = obj.rightLowerKnotUniqueKey;
			upperKnot.uniqueKey = obj.upperKnotUniqueKey;
			lowerKnot.uniqueKey = obj.lowerKnotUniqueKey;
			
			var attributes:Array = obj.attributes;
			
			if (attributes)
				for each (var a:String in attributes)
					attributesList.addField(a);
			
			var methods:Array = obj.methods;
			
			if (methods)
				for each (var m:String in methods)
					methodsList.addField(m);
		}
		
		public function createCopy():Card
		{
			var card:Card = new Card(type);
			
			card.x = x;
			card.y = y;
			
			card.nameField.textWithFormat = nameField.textWithFormat;
			
			var attributes:Array = attributesList.getFieldsArrayString();
			
			for each (var a:String in attributes)
				card.attributesList.addField(a);
			
			var methods:Array = methodsList.getFieldsArrayString();
			
			for each (var m:String in methods)
				card.methodsList.addField(m);
			
			return card;
		}
	}

}