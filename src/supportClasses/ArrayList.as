package supportClasses
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ArrayList
	{
		public var source:Array = [];
		
		public function ArrayList(source:Array = null)
		{
			if (source)
				this.source = source;
		}
		
		public function get length():int
		{
			return source.length;
		}
		
		public function getItemAt(index:int):Object
		{
			return source[index];
		}
		
		public function removeItemAt(index:int):void
		{
			var result:Array = [];
			
			for (var i:int = 0; i < source.length; i++)
				if (i != index)
					result.push(source[i]);
			
			source = result;
		}
		
		public function removeItem(item:*):void
		{
			var result:Array = [];
			
			for (var i:int = 0; i < source.length; i++)
				if (item != source[i])
					result.push(source[i]);
			
			source = result;
		}
		
		public function addItem(item:*):void
		{
			if (!contains(item))
				source.push(item);
		}
		
		public function addItemAt(item:*, index:int):void
		{
			if (contains(item))
				removeItem(item);
			
			var result:Array = [];
			
			if (index > source.length)
				index = source.length;
			
			var pushed:Boolean = false;
			
			for (var i:int = 0; i <= source.length; i++)
				if (i == index)
				{
					pushed = true;
					result.push(item);
				}
				else
					result.push(source[(pushed ? (i - 1) : i)]);
			
			source = result;
		}
		
		public function contains(item:*):Boolean
		{
			for each (var i:*in source)
				if (i == item)
					return true;
			
			return false;
		}
		
		public function toString():String
		{
			return String(source);
		}
	
	}

}