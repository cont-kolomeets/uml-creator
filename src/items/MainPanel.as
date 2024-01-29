package items
{
	import events.MoveEvent;
	import events.TextFieldEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import supportClasses.Constants;
	import supportClasses.ISerializable;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class MainPanel extends Sprite implements ISerializable
	{
		private var mainContainer:Sprite;
		private var mouseDown:Boolean = false;
		private var isInTextEditingMode:Boolean = false;
		
		public function MainPanel(mainContainer:Sprite)
		{
			super();
			this.mainContainer = mainContainer;
			addMouseSensitivity();
			addTextEditingListeners();
		}
		
		private function addTextEditingListeners():void
		{
			addEventListener(TextFieldEvent.ENTERED_EDITING_MODE, enteredTextEditingModeHandler, true);
			addEventListener(TextFieldEvent.LEFT_EDITING_MODE, leftTextEditingModeHandler, true);
		}
		
		private function enteredTextEditingModeHandler(event:TextFieldEvent):void
		{
			isInTextEditingMode = true;
		}
		
		private function leftTextEditingModeHandler(event:TextFieldEvent):void
		{
			isInTextEditingMode = false;
		}
		
		public function resetPanel():void
		{
			this.x = 0;
			this.y = 0;
		}
		
		private function addMouseSensitivity():void
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
			mainContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			mainContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler);
			mainContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, true);
			mainContainer.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove_Handler);
			mainContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown_Handler);
		}
		
		public function deactivate():void
		{
			mainContainer.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			mainContainer.removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler);
			mainContainer.removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, true);
			mainContainer.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove_Handler);
			mainContainer.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown_Handler);
		}
		
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		private var initialX:Number = 0;
		private var initialY:Number = 0;
		
		private function mouseDown_Handler(event:MouseEvent):void
		{
			if (!(event.target == mainContainer))
				return;
			mouseDown = true;
			
			var locPoint:Point = this.globalToLocal(new Point(event.stageX, event.stageY))
			offsetX = -locPoint.x;
			offsetY = -locPoint.y;
			
			initialX = event.stageX + offsetX;
			initialY = event.stageY + offsetY;
		}
		
		private function mouseUp_Handler(event:MouseEvent):void
		{
			mouseDown = false;
		}
		
		private function mouseMove_Handler(event:MouseEvent):void
		{
			if (mouseDown)
			{
				moveAllChildrenBy(-initialX + (event.stageX + offsetX), -initialY + (event.stageY + offsetY));
				initialX = event.stageX + offsetX;
				initialY = event.stageY + offsetY;
				this.dispatchEvent(new MoveEvent(MoveEvent.MOVED, initialX, initialY));
			}
		}
		
		private function keyDown_Handler(event:KeyboardEvent):void
		{
			if (isInTextEditingMode)
				return;
				
			if (event.keyCode == Keyboard.NUMPAD_ADD)
				moveAllChildrenBy(0, 0, -Constants.VIEW_ARROW_STEP);
			if (event.keyCode == Keyboard.NUMPAD_SUBTRACT)
				moveAllChildrenBy(0, 0, Constants.VIEW_ARROW_STEP);
			
			if (event.keyCode == Keyboard.UP)
				moveAllChildrenBy(0, Constants.VIEW_ARROW_STEP);
			if (event.keyCode == Keyboard.DOWN)
				moveAllChildrenBy(0, -Constants.VIEW_ARROW_STEP);
			if (event.keyCode == Keyboard.LEFT)
				moveAllChildrenBy(Constants.VIEW_ARROW_STEP, 0);
			if (event.keyCode == Keyboard.RIGHT)
				moveAllChildrenBy(-Constants.VIEW_ARROW_STEP, 0);
			if (event.keyCode == Keyboard.NUMPAD_DECIMAL)
				resetZForAllChildren();
			//if (event.keyCode == Keyboard.NUMPAD_DECIMAL)
			//	changeZToFitContent();
		}
		
		private var currentZ:Number = 0;
		
		private function moveAllChildrenBy(dx:Number, dy:Number, dz:Number = 0):void
		{
			this.x += dx;
			this.y += dy;
			if (dz != 0)
				this.z += dz;
		/*for (var i:int = 0; i < numChildren; i++)
		   {
		   var child:DisplayObject = getChildAt(i);
		   child.x += dx;
		   child.y += dy;
		
		   if (dz != 0)
		   child.z += dz;
		
		   currentZ += dz;
		
		   //this.scaleX = calcScaleFromZ(currentZ);
		   //this.scaleY = calcScaleFromZ(currentZ);
		 }*/
		}
		
		private function resetZForAllChildren():void
		{
			var memX:Number = this.x;
			var memY:Number = this.y;
			
			this.transform.matrix3D = null;
			
			this.x = memX;
			this.y = memY;
		}
		
		private function calcScaleFromZ(z:Number):Number
		{
			return 1 / (1 + z * 0.001); //100 - 99 * Math.exp( -0.004 * z);
		}
		
		override public function addChild(child:DisplayObject):flash.display.DisplayObject
		{
			//child.z = currentZ;
			return super.addChild(child);
		}
		
		public function serialize():Object
		{
			var obj:Object = new Object();
			
			obj.x = x;
			obj.y = y;
			
			return obj;
		}
		
		public function implementDeserializedProperties(obj:Object):void
		{
			this.x = obj.x;
			this.y = obj.y;
		}
	
	/*private function calcZFromRatio(ratio:Number):Number
	   {
	   return Math.log(ratio / 100 * 99) / 0.004;
	   }
	
	   private function changeZToFitContent():void
	   {
	   resetZForAllChildren();
	   var sideToFit:Number = (width < height) ? height : width;
	   var ratio:Number = sideToFit / Constants.VIEW_SIZE_TO_FIT_CONTENT;
	
	   if (ratio < 1)
	   return;
	
	   var dz:Number = calcZFromRatio(ratio);
	   moveAllChildrenBy(0, 0, dz);
	 }*/
	}

}