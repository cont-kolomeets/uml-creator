package supportClasses 
{
	import events.ButtonEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class FileHelper extends EventDispatcher
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public var loadedData:String;
		private var fileReference:FileReference;
		private var lastFileName:String = "project.uml";
		private var busy:Boolean = false;
		
		public function FileHelper()
		{
		}
		
		public function saveToFile(line:String):void
		{
			fileReference = new FileReference();
			fileReference.save(line, lastFileName);
			fileReference.addEventListener(Event.COMPLETE, onComplete);
			fileReference.addEventListener(Event.CANCEL, onCancel);
			busy = true;
		}
		
		public function isBusy():Boolean
		{
			return busy;
		}
		
		public function loadFile():void
		{
			var fd:String = "Files (.uml)";
			var fe:String = "*";
			var ff:FileFilter = new FileFilter(fd, fe);
			
			fileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, onFileSelect);
			fileReference.addEventListener(Event.CANCEL, onCancel);
			fileReference.addEventListener(Event.COMPLETE, onFileLoadComplete);
			fileReference.browse([ff]);
			
			busy = true;
		}
		
		private function onCancel(event:Event):void
		{
			fileReference.removeEventListener(Event.CANCEL, onCancel);
			busy = false;
		}
		
		private function onComplete(event:Event):void
		{
			fileReference.removeEventListener(Event.COMPLETE, onComplete);
			lastFileName = fileReference.name;
			busy = false;
		}
		
		private function onFileSelect(event:Event):void
		{
			fileReference.load();
			fileReference.removeEventListener(Event.SELECT, onFileSelect);
			busy = false;
		}
		
		private function onFileLoadComplete(event:Event):void
		{
			fileReference.removeEventListener(Event.COMPLETE, onFileLoadComplete);
			
			var ba:ByteArray = event.currentTarget.data as ByteArray;
			loadedData = ba.toString();
			lastFileName = fileReference.name;
			
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
	}

}