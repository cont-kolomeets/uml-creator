package items
{
	import events.KnotEvent;
	import events.ThreadEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import supportClasses.ArrayList;
	import supportClasses.Constants;
	import supportClasses.Utils;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Knot extends Sprite
	{
		public var type:String;
		public var state:String = KnotState.DISCONNECTED;
		public var position:String = KnotPosition.NONE;
		public var uniqueKey:String = "knot-" + Utils.generateUniqueID();
		public var threads:ArrayList = new ArrayList();
		public var lineOffsetX:Number = 0;
		public var lineOffsetY:Number = 0;
		public var hidden:Boolean = true;
		public var showArrow:Boolean = false;
		
		private var knotSkin:KnotSkin = new KnotSkin();
		
		public function Knot(type:String, position:String)
		{
			this.type = type;
			this.position = position;
			doubleClickEnabled = true;
			knotSkin.doubleClickEnabled = true;
			knotSkin.hostComponent = this;
			
			addChild(knotSkin);
			drawKnot();
			
			if (stage)
				addListeners();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		public function isConnectedToThread(thread:Thread):Boolean
		{
			return threads.contains(thread);
		}
		
		public function addThread(thread:Thread):void
		{
			if (isConnectedToThread(thread))
				return;
			
			threads.addItem(thread);
			
			state = threads.length > 0 ? KnotState.CONNECTED : KnotState.DISCONNECTED;
			drawKnot();
		}
		
		public function removeThread(thread:Thread):void
		{
			threads.removeItem(thread);
			
			state = threads.length > 0 ? KnotState.CONNECTED : KnotState.DISCONNECTED;
			
			if (state == KnotState.DISCONNECTED)
				showArrow = false;
				
			drawKnot();
		}
		
		public function isConnectedToKnot(knot:Knot):Boolean
		{
			for each (var hisThread:Thread in knot.threads.source)
				for each (var myThread:Thread in threads.source)
					if (hisThread == myThread)
						return true;
			
			return false;
		}
		
		private function addedToStageListener(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			addListeners();
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandlerSpecific);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function removeListeners():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			removeEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandlerSpecific);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function this_removedFromStageHandler(event:Event):void
		{
			removeListeners();
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			hidden = false;
			drawKnot();
			if (state == KnotState.CONNECTED)
				knotSkin.drawOverRect();
			dispatchEvent(new KnotEvent(KnotEvent.MOUSE_OVER_KNOT));
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			hidden = true;
			drawKnot();
			knotSkin.clearOverRect();
			dispatchEvent(new KnotEvent(KnotEvent.MOUSE_OUT_KNOT));
		}
		
		private function mouseDoubleClickHandler(event:MouseEvent):void
		{
			trace("here");
			dispatchEvent(new KnotEvent(KnotEvent.DISCONNECT));
		}
		
		private var mouseDown:Boolean = false;
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			mouseDown = true;
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			mouseDown = false;
			knotSkin.clearPseudoLine();
			
			dispatchEvent(new KnotEvent(KnotEvent.DRAWING_PSEUDO_CONNECTION_FINISHED));
		}
		
		private function mouseUpHandlerSpecific(event:MouseEvent):void
		{
			dispatchEvent(new KnotEvent(KnotEvent.MOUSE_UP_KNOT));
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			if (mouseDown)
			{
				var locPoint:Point = this.globalToLocal(new Point(event.stageX, event.stageY))
				
				knotSkin.drawPseudoLineTo(locPoint.x, locPoint.y);
				
				dispatchEvent(new KnotEvent(KnotEvent.DRAWING_PSEUDO_CONNECTION));
			}
		}
		
		private function drawKnot():void
		{
			knotSkin.drawKnot();
			lineOffsetX = knotSkin.lineOffsetX;
			lineOffsetY = knotSkin.lineOffsetY;
		}
	
	}

}