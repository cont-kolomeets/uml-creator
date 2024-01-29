package panels
{
	import events.PanelEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class IntroPanel extends Sprite
	{
		public var title:TextField = new TextField();
		public var hint:TextField = new TextField();
		
		public function IntroPanel()
		{
			super();
			
			if (stage)
				constructIntroText();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			
			addEventListener(Event.REMOVED, removedHandler);
		}
		
		private function addedToStageListener(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			constructIntroText();
		}
		
		private function removedHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED, removedHandler);
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			removeChild(title);
			removeChild(hint);
			constructIntroText();
		}
		
		private function constructIntroText():void
		{
			var shadow:DropShadowFilter = new DropShadowFilter();
			var glow:GlowFilter = new GlowFilter(0x37C6F4);
			var bevel:BevelFilter = new BevelFilter();
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.font = "Comic Sans MS";
			titleFormat.size = 80;
			titleFormat.align = TextFormatAlign.CENTER;
			
			title.defaultTextFormat = titleFormat;
			title.text = "UML Creator";
			title.selectable = false;
			title.width = stage.stageWidth;
			title.y = 150;
			title.textColor = 0xC2EEFC;
			title.filters = [shadow, bevel, glow]
			
			//////////////
			
			var hintFormat:TextFormat = new TextFormat();
			hintFormat.font = "Comic Sans MS";
			hintFormat.size = 40;
			hintFormat.align = TextFormatAlign.CENTER;
			
			hint.defaultTextFormat = hintFormat;
			hint.text = "Press F1 for help";
			hint.selectable = false;
			hint.width = stage.stageWidth;
			hint.y = 300;
			hint.textColor = 0xC2EEFC;
			hint.filters = [shadow, bevel, glow];
			
			addChild(title);
			addChild(hint);
		}
		
		private var deltaFade:Number = 0;
		private var fadingOut:Boolean = false;
		private var delayCount:int = 0;
		private var delay:int = 0;
		
		public function fadeOut(frames:int, delay:int = 0):void
		{
			deltaFade = 1 / frames;
			fadingOut = true;
			this.delay = delay;
			delayCount = 0;
			addEventListener(Event.ENTER_FRAME, frameListener);
		}
		
		public function fadeIn(frames:int, delay:int = 0):void
		{
			deltaFade = -1 / frames;
			fadingOut = false;
			this.delay = delay;
			delayCount = 0;
			addEventListener(Event.ENTER_FRAME, frameListener);
		}
		
		private function frameListener(event:Event):void
		{
			if (delay > delayCount++)
				return;
			
			if (delay == delayCount++)
				if (fadingOut)
					alpha = 1;
				else
					alpha = 0;
			
			this.alpha -= deltaFade;
			
			if (this.alpha <= 0 && fadingOut)
			{
				removeEventListener(Event.ENTER_FRAME, frameListener);
				dispatchEvent(new PanelEvent(PanelEvent.FADING_OUT_FINISHED));
			}
			
			if (this.alpha >= 1 && !fadingOut)
			{
				removeEventListener(Event.ENTER_FRAME, frameListener);
				dispatchEvent(new PanelEvent(PanelEvent.FADING_IN_FINISHED));
			}
		}
	
	}

}