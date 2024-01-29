package managers
{
	import events.ButtonEvent;
	import events.TextFieldEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import items.Card;
	import items.CardType;
	import items.FieldsList;
	import supportClasses.FileHelper;
	import supportClasses.GlobalKeyboardInfo;
	import supportClasses.Utils;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Controller
	{
		private var mainContainer:Sprite;
		private var cardManager:CardManager;
		private var fileHelper:FileHelper = new FileHelper();
		private var panelManager:PanelManager;
		
		public function Controller(mainContainer:Sprite)
		{
			this.mainContainer = mainContainer;
			
			panelManager = new PanelManager(mainContainer);
			cardManager = new CardManager(panelManager.mainPanel);
			
			addListeners();
		}
		
		private function addListeners():void
		{
			mainContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN, mainContainer_keyDownHandler);
			mainContainer.stage.addEventListener(KeyboardEvent.KEY_UP, mainContainer_keyUpHandler);
			mainContainer.addEventListener(MouseEvent.MOUSE_DOWN, mainContainer_mouseDownHandler);
		}
		
		//-----------------------------------------------
		//
		// listening to keys
		//
		//-----------------------------------------------
		
		private function mainContainer_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.CONTROL || event.ctrlKey)
				GlobalKeyboardInfo.ctrlKeyIsPressed = true;
			else
				GlobalKeyboardInfo.ctrlKeyIsPressed = false;
			
			if (event.keyCode == Keyboard.ESCAPE)
				closeAddPanel();
			
			if (event.keyCode == Keyboard.NUMPAD_MULTIPLY)
				toggleAddPanel();
			
			if (event.keyCode == Keyboard.DELETE)
			{
				cardManager.removeActiveCards();
				mainContainer.stage.focus = mainContainer.stage;
			}
			
			if (event.keyCode == Keyboard.S && event.ctrlKey)
			{
				GlobalKeyboardInfo.ctrlKeyIsPressed = false;
				saveToFile();
			}
			
			if (event.keyCode == Keyboard.L && event.ctrlKey)
			{
				GlobalKeyboardInfo.ctrlKeyIsPressed = false;
				openFromFile();
			}
			
			if (event.keyCode == Keyboard.D && event.ctrlKey)
				cardManager.duplicateActiveCards();
			
			if (event.keyCode == Keyboard.Z && event.ctrlKey)
				cardManager.undo();
			
			if (event.keyCode == Keyboard.N && event.ctrlKey && event.shiftKey)
			{
				cardManager.removeAllCards();
				panelManager.mainPanel.resetPanel();
			}
			
			if (event.keyCode == Keyboard.F1)
				panelManager.showHelpPanel();
			
			if (event.keyCode == Keyboard.NUMBER_1 && event.ctrlKey)
				btnAddClass_clickHandler(null);
			
			if (event.keyCode == Keyboard.NUMBER_2 && event.ctrlKey)
				btnAddInterface_clickHandler(null);
			
			if (event.keyCode == Keyboard.NUMBER_3 && event.ctrlKey)
				btnAddAClass_clickHandler(null);
			
			if (event.keyCode == Keyboard.NUMBER_4 && event.ctrlKey)
				btnAddMXML_clickHandler(null);
			
			if (event.keyCode == Keyboard.NUMBER_5 && event.ctrlKey)
				btnAddSkin_clickHandler(null);
			
			if (event.keyCode == Keyboard.NUMBER_6 && event.ctrlKey)
				btnAddFile_clickHandler(null);
			
			if (event.keyCode == Keyboard.NUMBER_7 && event.ctrlKey)
				btnAddComment_clickHandler(null);
			
			if (event.keyCode == Keyboard.NUMBER_8 && event.ctrlKey)
				btnAddRect_clickHandler(null);
			
			if (event.keyCode == Keyboard.NUMBER_9 && event.ctrlKey)
				btnAddDiamond_clickHandler(null);
		}
		
		private function mainContainer_keyUpHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.CONTROL || !event.ctrlKey)
				GlobalKeyboardInfo.ctrlKeyIsPressed = false;
			
			if (event.keyCode == Keyboard.F1)
				panelManager.closeHelpPanel();
		}
		
		//-----------------------------------------------
		//
		// working with add panel
		//
		//-----------------------------------------------
		
		private function addListenersAddPanel():void
		{
			panelManager.addPanel.btnAddClass.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddClass_clickHandler);
			panelManager.addPanel.btnAddInterface.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddInterface_clickHandler);
			panelManager.addPanel.btnAddAClass.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddAClass_clickHandler);
			panelManager.addPanel.btnAddMXML.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddMXML_clickHandler);
			panelManager.addPanel.btnAddSkin.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddSkin_clickHandler);
			panelManager.addPanel.btnAddFile.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddFile_clickHandler);
			panelManager.addPanel.btnAddComment.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddComment_clickHandler);
			panelManager.addPanel.btnAddRect.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddRect_clickHandler);
			panelManager.addPanel.btnAddDiamond.addEventListener(ButtonEvent.BUTTON_CLICK, btnAddDiamond_clickHandler);
		}
		
		private function removeListenersAddPanel():void
		{
			panelManager.addPanel.btnAddClass.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddClass_clickHandler);
			panelManager.addPanel.btnAddInterface.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddInterface_clickHandler);
			panelManager.addPanel.btnAddAClass.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddAClass_clickHandler);
			panelManager.addPanel.btnAddMXML.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddMXML_clickHandler);
			panelManager.addPanel.btnAddSkin.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddSkin_clickHandler);
			panelManager.addPanel.btnAddFile.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddFile_clickHandler);
			panelManager.addPanel.btnAddComment.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddComment_clickHandler);
			panelManager.addPanel.btnAddRect.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddRect_clickHandler);
			panelManager.addPanel.btnAddDiamond.removeEventListener(ButtonEvent.BUTTON_CLICK, btnAddDiamond_clickHandler);
		}
		
		private function toggleAddPanel():void
		{
			panelManager.toggleAddPanel();
			if (panelManager.addPanelVisible)
				addListenersAddPanel();
		}
		
		private function closeAddPanel():void
		{
			removeListenersAddPanel();
			panelManager.closeAddPanel();
		}
		
		//-----------------------------------------------
		//
		// creating cards
		//
		//-----------------------------------------------
		
		private function btnAddClass_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.CLASS), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		private function btnAddInterface_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.INTERFACE), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		private function btnAddAClass_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.ABSTRACT_CLASS), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		private function btnAddMXML_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.MXML_COMPONENT), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		private function btnAddSkin_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.SKIN_CLASS), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		private function btnAddFile_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.FILE), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		private function btnAddComment_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.COMMENT), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		private function btnAddRect_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.RECTANGLE), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		private function btnAddDiamond_clickHandler(event:ButtonEvent):void
		{
			cardManager.addCardAt(new Card(CardType.DIAMOND), panelManager.activeMouseX, panelManager.activeMouseY);
			closeAddPanel();
			mainContainer.stage.focus = mainContainer.stage;
		}
		
		//-----------------------------------------------
		//
		// working with files
		//
		//-----------------------------------------------
		
		private function saveToFile():void
		{
			if (fileHelper.isBusy())
				return;
			
			fileHelper.saveToFile(Utils.objToJSON(cardManager.serializeContent()));
		}
		
		private function openFromFile():void
		{
			if (fileHelper.isBusy())
				return;
			
			fileHelper.loadFile();
			fileHelper.addEventListener(FileHelper.LOAD_COMPLETE, fileHelper_loadCompleteHandler);
		}
		
		private function fileHelper_loadCompleteHandler(event:Event):void
		{
			cardManager.deserializeContent(Utils.objFromJSON(fileHelper.loadedData));
		}
		
		private function mainContainer_mouseDownHandler(event:MouseEvent):void
		{
			if (event.target == mainContainer)
				cardManager.deselectAllCards();
		}
	}

}