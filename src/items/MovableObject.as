package items
{
	import events.MoveEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import supportClasses.SpriteUtil;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class MovableObject extends Sprite
	{
		private var mouseDown:Boolean = false;
		
		public function MovableObject()
		{
		}
		
		public function addMouseSensitivity():void
		{
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
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		public function removeMouseSensitivity():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function this_removedFromStageHandler(event:Event):void
		{
			removeMouseSensitivity();
		}
		
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			mouseDown = true;
			
			//SpriteUtil.suspendZ(this);
			var locPoint:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
			//SpriteUtil.resumeZ();
			offsetX = -locPoint.x;
			offsetY = -locPoint.y;
			
			calcParentOffset(parent);
			
			this.x = event.stageX + offsetX;
			this.y = event.stageY + offsetY;
		}
		
		private function calcParentOffset(container:DisplayObjectContainer):void
		{
			if (!container)
				return;
			
			offsetX -= container.x;
			offsetY -= container.y;
			
			calcParentOffset(container.parent);
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			mouseDown = false;
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			if (mouseDown)
			{
				var oldX:Number = this.x;
				var oldY:Number = this.y;
				this.x = event.stageX + offsetX;
				this.y = event.stageY + offsetY;
				this.dispatchEvent(new MoveEvent(MoveEvent.MOVED, this.x, this.y, oldX, oldY));
			}
		}
	
	}

}