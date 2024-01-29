package managers
{
	import events.CardEvent;
	import events.ListEvent;
	import events.MoveEvent;
	import events.TextFieldEvent;
	import events.ThreadEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import items.Card;
	import items.Knot;
	import items.Thread;
	import items.ThreadType;
	import supportClasses.ArrayList;
	import supportClasses.Filter;
	import supportClasses.GlobalKeyboardInfo;
	import supportClasses.ISerializable;
	import supportClasses.IUndoable;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class CardManager implements IUndoable
	{
		private var container:DisplayObjectContainer;
		private var knotEditingMode:Boolean = false;
		private var activeKnot:Knot;
		private var cards:ArrayList = new ArrayList();
		private var activeCards:ArrayList = new ArrayList();
		private var threads:ArrayList = new ArrayList();
		private var isInTextEditingMode:Boolean = false;
		private var removedStack:ArrayList = new ArrayList();
		private var undoDepth:int = 0;
		
		public function CardManager(container:DisplayObjectContainer)
		{
			this.container = container;
			addTextEditingListeners();
		}
		
		//-----------------------------------------------
		//
		// text editing modes
		//
		//-----------------------------------------------
		
		private function addTextEditingListeners():void
		{
			container.addEventListener(TextFieldEvent.ENTERED_EDITING_MODE, enteredTextEditingModeHandler, true);
			container.addEventListener(TextFieldEvent.LEFT_EDITING_MODE, leftTextEditingModeHandler, true);
		}
		
		private function enteredTextEditingModeHandler(event:TextFieldEvent):void
		{
			isInTextEditingMode = true;
		}
		
		private function leftTextEditingModeHandler(event:TextFieldEvent):void
		{
			isInTextEditingMode = false;
		}
		
		//-----------------------------------------------
		//
		// working with cards
		//
		//-----------------------------------------------
		
		//-----------------------------------------------
		//
		// adding cards
		//
		//-----------------------------------------------
		public function addCardAt(card:Card, x:Number, y:Number):void
		{
			card.addMouseSensitivity();
			card.x = x - container.x;
			card.y = y - container.y;
			container.addChild(card);
			addListenersForCard(card);
			cards.addItem(card);
			
			deselectAllCards();
			selectCard(card);
		}
		
		//-----------------------------------------------
		//
		// selecting/deselecting cards
		//
		//-----------------------------------------------
		
		public function deselectAllCards():void
		{
			for each (var card:Card in activeCards.source)
				deselectCard(card);
		}
		
		private function deselectCard(card:Card):void
		{
			card.selected = false;
			activeCards.removeItem(card);
		}
		
		private function selectCard(card:Card):void
		{
			card.selected = true;
			activeCards.addItem(card);
		}
		
		//-----------------------------------------------
		//
		// removing cards
		//
		//-----------------------------------------------
		
		public function removeActiveCards():void
		{
			if (isInTextEditingMode)
				return;
			
			for each (var card:Card in activeCards.source)
				removeCard(card);
		}
		
		public function removeCard(card:Card):void
		{
			removedStack.addItemAt(card.createCopy(), 0);
			deselectCard(card);
			container.removeChild(card);
			removeListenersForCard(card);
			cards.removeItem(card);
		}
		
		public function removeAllCards():void
		{
			for each (var card:Card in cards.source)
				removeCard(card);
		}
		
		//-----------------------------------------------
		//
		// duplicating cards
		//
		//-----------------------------------------------
		
		private var map:Array = [];
		
		public function duplicateActiveCards():void
		{
			var duplicatedCards:Array = [];
			
			for each (var card:Card in activeCards.source)
			{
				var newCard:Card = card.createCopy();
				duplicatedCards.push(newCard);
				addCardAt(newCard, card.x + 20 + container.x, card.y + 20 + container.y);
				
					//for each (var knot:Knot in card.knots)
					//	map.push([knot]);
			}
			
			for each (var dCard:Card in duplicatedCards)
				selectCard(dCard);
		
			//duplicateConnections(duplicatedCards);
		}
		
		private function getKnotByIndex(index:int):Knot
		{
			return map[index][0];
		}
		
		private function duplicateConnections(cards:Array):void
		{
			for each (var card1:Card in cards)
				for each (var card2:Card in cards)
					if (card1 != card2)
					{
						var connections:Array = getConnectedKnots(card1, card2);
						for each (var pair:Array in connections)
							createThread(pair[0] as Knot, pair[1] as Knot);
					}
		}
		
		private function getConnectedKnots(card1:Card, card2:Card):Array
		{
			var result:Array = [];
			
			for each (var knot1:Knot in card1.knots)
				for each (var knot2:Knot in card2.knots)
					if (knot1.isConnectedToKnot(knot2))
						result.push([knot1, knot2]);
			
			return result;
		}
		
		//-----------------------------------------------
		//
		// cards handlers
		//
		//-----------------------------------------------
		
		private function addListenersForCard(card:Card):void
		{
			card.addEventListener(CardEvent.KNOT_EDITING_STARTED, card_knotEditingStartedHandler);
			card.addEventListener(CardEvent.KNOT_EDITING_FINISHED, card_knotEditingFinishedHandler);
			card.addEventListener(CardEvent.KNOT_MOUSE_OVER, card_knotMouseOverHandler);
			card.addEventListener(CardEvent.DISCONNECT_KNOT, card_knotDisconnectHandler);
			card.addEventListener(MouseEvent.MOUSE_DOWN, card_mouseDownHandler);
			card.addEventListener(MouseEvent.MOUSE_UP, card_mouseUpHandler);
			card.addEventListener(MoveEvent.MOVED, card_moveHandler);
			card.addEventListener(ListEvent.DRAG, card_dragHandler, true);
			card.addEventListener(ListEvent.DROP, card_dropHandler, true);
		}
		
		private function removeListenersForCard(card:Card):void
		{
			card.removeEventListener(CardEvent.KNOT_EDITING_STARTED, card_knotEditingStartedHandler);
			card.removeEventListener(CardEvent.KNOT_EDITING_FINISHED, card_knotEditingFinishedHandler);
			card.removeEventListener(CardEvent.KNOT_MOUSE_OVER, card_knotMouseOverHandler);
			card.removeEventListener(CardEvent.DISCONNECT_KNOT, card_knotDisconnectHandler);
			card.removeEventListener(MouseEvent.MOUSE_DOWN, card_mouseDownHandler);
			card.removeEventListener(MouseEvent.MOUSE_UP, card_mouseUpHandler);
			card.removeEventListener(MoveEvent.MOVED, card_moveHandler);
			card.removeEventListener(ListEvent.DRAG, card_dragHandler, true);
			card.removeEventListener(ListEvent.DROP, card_dropHandler, true);
		}
		
		//-----------------------------------------------
		//
		// drag and drop modes
		//
		//-----------------------------------------------
		
		private function card_dragHandler(event:ListEvent):void
		{
			Card(event.currentTarget).removeMouseSensitivity();
		}
		
		private function card_dropHandler(event:ListEvent):void
		{
			Card(event.currentTarget).addMouseSensitivity();
		}
		
		//-----------------------------------------------
		//
		// selection/deselection of cards
		//
		//-----------------------------------------------
		
		private var draggingOccurred:Boolean = false;
		
		private function card_mouseDownHandler(event:MouseEvent):void
		{
			if (!activeCards.contains(event.currentTarget) && !GlobalKeyboardInfo.ctrlKeyIsPressed)
				deselectAllCards();
			
			selectCard(event.currentTarget as Card);
			draggingOccurred = false;
		}
		
		private function card_mouseUpHandler(event:MouseEvent):void
		{
			if (!GlobalKeyboardInfo.ctrlKeyIsPressed && !draggingOccurred)
			{
				deselectAllCards();
				selectCard(event.currentTarget as Card);
			}
		}
		
		private function card_moveHandler(event:MoveEvent):void
		{
			for each (var card:Card in activeCards.source)
				if (card != event.currentTarget)
				{
					card.x += (event.newX - event.oldX);
					card.y += (event.newY - event.oldY);
					card.notifyKnots();
				}
			
			draggingOccurred = true;
		}
		
		//-----------------------------------------------
		//
		// knot editing mode
		//
		//-----------------------------------------------
		
		private function card_knotEditingStartedHandler(event:CardEvent):void
		{
			knotEditingMode = true;
			activeKnot = event.knot;
		}
		
		private function card_knotEditingFinishedHandler(event:CardEvent):void
		{
			knotEditingMode = false;
			activeKnot = null;
		}
		
		private function card_knotMouseOverHandler(event:CardEvent):void
		{
			if (event.knot == activeKnot)
				return;
			
			if (knotEditingMode && activeKnot && event.knot)
			{
				createThread(activeKnot, event.knot);
			}
		}
		
		//-----------------------------------------------
		//
		// working with threads
		//
		//-----------------------------------------------
		
		private function createThread(knot1:Knot, knot2:Knot, description:String = "..."):void
		{
			if (knot1.isConnectedToKnot(knot2))
				return;
			
			knot2.showArrow = true;
			
			var thread:Thread = new Thread(ThreadType.SOLID, knot1, knot2);
			thread.description = description;
			thread.addEventListener(ThreadEvent.DISCONNECT, thread_disconnectHandler);
			thread.addEventListener(ThreadEvent.DISCONNECTED, thread_disconnectedHandler);
			container.addChild(thread);
			threads.addItem(thread);
		}
		
		private function removeThread(thread:Thread):void
		{
			thread.removeEventListener(ThreadEvent.DISCONNECT, thread_disconnectHandler);
			thread.removeEventListener(ThreadEvent.DISCONNECTED, thread_disconnectedHandler);
			thread.disconnect();
			container.removeChild(thread);
			threads.removeItem(thread);
		}
		
		private function card_knotDisconnectHandler(event:CardEvent):void
		{
			for each (var thread:Thread in event.knot.threads.source)
				removeThread(thread);
		}
		
		private function thread_disconnectHandler(event:ThreadEvent):void
		{
			var thread:Thread = event.currentTarget as Thread;
			
			if (!thread)
				return;
			
			removeThread(thread);
		}
		
		private function thread_disconnectedHandler(event:ThreadEvent):void
		{
			var thread:Thread = event.currentTarget as Thread;
			
			if (!thread)
				return;
			
			removeThread(thread);
		}
		
		//-----------------------------------------------------------------
		//
		// serialization/deserialization of cards and thier connections
		//
		//-----------------------------------------------------------------
		
		public function serializeContent():Object
		{
			var obj:Object = new Object();
			var components:Array = [];
			var connections:Array = [];
			
			for each (var card:Card in cards.source)
				components.push(card.serialize());
			
			for each (var thread:Thread in threads.source)
				connections.push(serializeConnection(thread));
			
			obj.components = components;
			obj.connections = connections;
			obj.container = ISerializable(container).serialize();
			
			return obj;
		}
		
		private function serializeConnection(thread:Thread):Object
		{
			var obj:Object = new Object();
			obj.startKnotUniqueKey = thread.start.uniqueKey;
			obj.endKnotUniqueKey = thread.end.uniqueKey;
			
			obj.description = thread.description;
			
			return obj;
		}
		
		private function createThreadFromSerializedConnection(obj:Object):void
		{
			var start:Knot = getKnotByUniqueId(obj.startKnotUniqueKey);
			var end:Knot = getKnotByUniqueId(obj.endKnotUniqueKey)
			
			trace(start);
			trace(end);
			
			if (start && end)
				createThread(start, end, obj.description);
		}
		
		private function getKnotByUniqueId(id:String):Knot
		{
			for each (var card:Card in cards.source)
				for each (var knot:Knot in card.knots)
					if (knot.uniqueKey == id)
						return knot;
			
			return null;
		}
		
		public function deserializeContent(obj:Object, removePreviousContent:Boolean = true):void
		{
			if (removePreviousContent)
				removeAllCards();
			
			if (obj.components)
				for each (var item:Object in obj.components as Array)
				{
					var card:Card = Card.createCardFromObject(item);
					addCardAt(card, card.x, card.y);
				}
			
			deselectAllCards();
			
			if (obj.connections)
				for each (var connection:Object in obj.connections as Array)
					createThreadFromSerializedConnection(connection);
			
			ISerializable(container).implementDeserializedProperties(obj.container);
		}
		
		//-----------------------------------------------
		//
		// undoing deleting operations
		//
		//-----------------------------------------------
		
		public function undo():void
		{
			if (isInTextEditingMode)
				return;
			
			var card:Card = removedStack.getItemAt(0) as Card;
			if (card)
			{
				addCardAt(card, card.x + container.x, card.y + container.y);
				removedStack.removeItemAt(0);
			}
		}
		
		public function redo():void
		{
		
		}
	
	}

}