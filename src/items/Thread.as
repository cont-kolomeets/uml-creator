package items
{
	import events.MoveEvent;
	import events.ThreadEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import supportClasses.Graph;
	import supportClasses.ISerializable;
	import supportClasses.SpriteUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Thread extends Sprite
	{
		public var start:Knot;
		public var end:Knot;
		public var type:String;
		
		private var descriptionField:AdvancedField = new AdvancedField();
		private var graph:Graph = new Graph();
		
		public function Thread(type:String, start:Knot, end:Knot)
		{
			super();
			
			graph.doubleClickEnabled = true;
			
			addChild(descriptionField);
			addChild(graph);
			
			doubleClickEnabled = true;
			
			this.start = start;
			this.end = end;
			this.type = type;
			
			start.addThread(this);
			end.addThread(this);
			
			drawThread();
			addListeners();
		}
		
		public function get description():String
		{
			return descriptionField.textWithFormat;
		}
		
		public function set description(value:String):void
		{
			descriptionField.textWithFormat = value;
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			start.addEventListener(MoveEvent.MOVED, redrawThread);
			end.addEventListener(MoveEvent.MOVED, redrawThread);
			addEventListener(MouseEvent.DOUBLE_CLICK, thread_doubleClickHandler);
			descriptionField.addEventListener(MouseEvent.MOUSE_OVER, descriptionField_mouseOverHandler);
			descriptionField.addEventListener(MouseEvent.MOUSE_OUT, descriptionField_mouseOutHandler);
		}
		
		private function deactivate():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			start.removeEventListener(MoveEvent.MOVED, redrawThread);
			end.removeEventListener(MoveEvent.MOVED, redrawThread);
			removeEventListener(MouseEvent.DOUBLE_CLICK, thread_doubleClickHandler);
			descriptionField.removeEventListener(MouseEvent.MOUSE_OVER, descriptionField_mouseOverHandler);
			descriptionField.removeEventListener(MouseEvent.MOUSE_OUT, descriptionField_mouseOutHandler);
		}
		
		private function this_removedFromStageHandler(event:Event):void
		{
			deactivate();
		}
		
		private var mouseOverDescription:Boolean = false;
		
		private function descriptionField_mouseOverHandler(event:MouseEvent):void
		{
			mouseOverDescription = true;
		}
		
		private function descriptionField_mouseOutHandler(event:MouseEvent):void
		{
			mouseOverDescription = false;
		}
		
		private var deactivated:Boolean = false;
		
		public function disconnect():void
		{
			if (deactivated)
				return;
			
			deactivated = true;
			
			dispatchEvent(new ThreadEvent(ThreadEvent.DISCONNECTED));
			deactivate();
			start.removeThread(this);
			end.removeThread(this);
			start = null;
			end = null;
		}
		
		private function thread_doubleClickHandler(event:MouseEvent):void
		{
			if (mouseOverDescription)
				return;
			
			dispatchEvent(new ThreadEvent(ThreadEvent.DISCONNECT));
		}
		
		private function redrawThread(event:MoveEvent):void
		{
			drawThread();
		}
		
		public function drawThread():void
		{
			updateOffsets();
			
			graphics.clear();
			graphics.lineStyle(2, 0x555555, 0.8);
			
			SpriteUtil.suspendZ(this);
			
			var point1:Point = start.localToGlobal(new Point(offsetX + start.lineOffsetX, offsetY + start.lineOffsetY));
			var point2:Point = end.localToGlobal(new Point(offsetX + end.lineOffsetX, offsetY + end.lineOffsetY));
			
			SpriteUtil.resumeZ();
			
			// draw curve
			var offset:Number = 100;
			
			var offsetXPoint1:Number = 0
			var offsetYPoint1:Number = 0;
			var offsetXPoint2:Number = 0;
			var offsetYPoint2:Number = 0;
			
			if (start.position == KnotPosition.TOP)
				offsetYPoint1 = -offset;
			
			if (start.position == KnotPosition.BOTTOM)
				offsetYPoint1 = offset;
			
			if (start.position == KnotPosition.LEFT)
				offsetXPoint1 = -offset;
			
			if (start.position == KnotPosition.RIGHT)
				offsetXPoint1 = offset;
			
			if (end.position == KnotPosition.TOP)
				offsetYPoint2 = -offset;
			
			if (end.position == KnotPosition.BOTTOM)
				offsetYPoint2 = offset;
			
			if (end.position == KnotPosition.LEFT)
				offsetXPoint2 = -offset;
			
			if (end.position == KnotPosition.RIGHT)
				offsetXPoint2 = offset;
				
			graph.lineColor = 0x555555;
			graph.lineWeight = 2;
			graph.lineAlpha = 0.8;
			graph.drawBezierCurve(point1.x, point1.y, point1.x + offsetXPoint1, point1.y + offsetYPoint1, point2.x + offsetXPoint2, point2.y + offsetYPoint2, point2.x, point2.y);
			
			//draw center
			
			graphics.beginFill(0x555555, 0.8);
			graphics.drawCircle(graph.center.x, graph.center.y, 4);
			
			descriptionField.x = graph.center.x;
			descriptionField.y = graph.center.y;
		}
		
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		private function updateOffsets():void
		{
			offsetX = 0;
			offsetY = 0;
			
			if (start.parent is Card)
				calcParentOffset(start.parent.parent);
			else
				calcParentOffset(start.parent);
		}
		
		private function calcParentOffset(container:DisplayObjectContainer):void
		{
			if (!container)
				return;
			
			offsetX -= container.x;
			offsetY -= container.y;
			
			calcParentOffset(container.parent);
		}
	
	}

}