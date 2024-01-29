package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import managers.Controller;
	import supportClasses.Prisoners;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Main extends Sprite
	{
		private var background:Sprite = new Sprite();
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addWhiteCanvas();
			
			var controller:Controller = new Controller(background);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		private function addWhiteCanvas():void
		{
			background.graphics.clear();
			background.graphics.beginFill(0xEEEEEE);
			background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			addChild(background);
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			addWhiteCanvas();
		}
	
	}

}