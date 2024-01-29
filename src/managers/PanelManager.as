package managers
{
	import events.PanelEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import panels.AddPanelInterface;
	import panels.HelpPanelInterface;
	import items.MainPanel;
	import panels.IntroPanel;
	import supportClasses.Filter;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class PanelManager
	{
		public var mainContainer:Sprite;
		public var addPanel:AddPanelInterface = new AddPanelInterface();
		public var mainPanel:MainPanel;
		public var helpPanel:HelpPanelInterface = new HelpPanelInterface();
		public var introPanel:IntroPanel = new IntroPanel();
		public var addPanelVisible:Boolean = false;
		
		private var helpPanelVisible:Boolean = false;
		private var mouseX:Number = 200;
		private var mouseY:Number = 150;
		
		public function PanelManager(mainContainer:Sprite)
		{
			this.mainContainer = mainContainer;
			mainPanel = new MainPanel(mainContainer);
			
			Filter.applyFilter(addPanel, true, true);
			Filter.applyFilter(helpPanel, true, true);
			addPanel.addMouseSensitivity();
			
			mainContainer.addChild(mainPanel);
			mainContainer.addChild(introPanel);
			
			addListeners();
			animateIntroPanel();
		}
		
		//-----------------------------------------------
		//
		// getters and setters
		//
		//-----------------------------------------------
		
		public function get activeMouseX():Number
		{
			return Math.max(mouseX, 200);
		}
		
		public function get activeMouseY():Number
		{
			return Math.max(mouseY, 150);
		}
		
		//-----------------------------------------------
		//
		// intro panel animation
		//
		//-----------------------------------------------
		
		private function animateIntroPanel():void
		{
			introPanel.addEventListener(PanelEvent.FADING_IN_FINISHED, introPanel_fadeInHandler);
			introPanel.addEventListener(PanelEvent.FADING_OUT_FINISHED, introPanel_fadeOutHandler);
			introPanel.alpha = 0;
			introPanel.fadeIn(10, 0);
		}
		
		private function introPanel_fadeInHandler(event:PanelEvent):void
		{
			introPanel.removeEventListener(PanelEvent.FADING_IN_FINISHED, introPanel_fadeInHandler);
			introPanel.fadeOut(30, 10);
		}
		
		private function introPanel_fadeOutHandler(event:PanelEvent):void
		{
			introPanel.removeEventListener(PanelEvent.FADING_OUT_FINISHED, introPanel_fadeOutHandler);
			mainContainer.removeChild(introPanel);
		}
		
		//-----------------------------------------------
		//
		// mouse handlers
		//
		//-----------------------------------------------
		
		private function addListeners():void
		{
			mainContainer.stage.addEventListener(MouseEvent.MOUSE_MOVE, mainContainer_mouseMoveHandler);
			mainContainer.stage.addEventListener(MouseEvent.MOUSE_OUT, mainContainer_mouseOutHandler);
		}
		
		private function mainContainer_mouseMoveHandler(event:MouseEvent):void
		{
			mouseX = event.stageX;
			mouseY = event.stageY;
		}
		
		private function mainContainer_mouseOutHandler(event:MouseEvent):void
		{
			mouseX = 0;
			mouseY = 0;
		}
		
		//-----------------------------------------------
		//
		// add panel
		//
		//-----------------------------------------------
		
		public function showAddPanel():void
		{
			addPanel.x = Math.max(mouseX, 200);
			addPanel.y = Math.max(mouseY, 150);
			mainContainer.addChild(addPanel);
			addPanel.visible = true;
			addPanelVisible = true;
		}
		
		public function closeAddPanel():void
		{
			if (!addPanelVisible)
				return;
			
			addPanel.visible = false;
			addPanelVisible = false;
		}
		
		public function toggleAddPanel():void
		{
			addPanelVisible ? closeAddPanel() : showAddPanel();
		}
		
		//-----------------------------------------------
		//
		// help panel
		//
		//-----------------------------------------------
		
		public function showHelpPanel():void
		{
			helpPanel.x = 200;
			helpPanel.y = 100;
			mainContainer.addChild(helpPanel);
			helpPanelVisible = true;
		}
		
		public function closeHelpPanel():void
		{
			if (!helpPanelVisible)
				return;
			
			mainContainer.removeChild(helpPanel);
			helpPanelVisible = false;
		}
	
	}

}