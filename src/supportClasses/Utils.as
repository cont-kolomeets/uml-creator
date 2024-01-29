package supportClasses
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Utils
	{
		//private static var keyValueSeparator:String = ":";
		//private static var delimeter:String = ";";
		//private static var arrayDelimiter:String = ",";
		
		public static function objToJSON(obj:*):String
		{
			if (obj is Array)
				return arrayToJSON(obj as Array);
			
			if (obj is Object)
				return anyToJSON(obj, "{", "}", ";");
			
			return String(obj);
		}
		
		private static function arrayToJSON(array:Array):String
		{
			return anyToJSON(array, "[", "]", ";");
		}
		
		private static function anyToJSON(obj:Object, leftBracket:String, rightBracket:String, delimiter:String):String
		{
			var result:String = leftBracket;
			
			var array:Array = [];
			
			for (var id:String in obj)
				if (obj[id] is Array)
					array.push(id + ":" + arrayToJSON(obj[id]))
				else
					array.push(id + ":" + objToJSON(obj[id]));
			
			if (array.length == 0)
				return String(obj);
			
			for (var i:int = 0; i < array.length; i++)
				if (i < (array.length - 1))
					result += array[i] + delimiter;
				else
					result += array[i];
			
			return result + rightBracket;
		}
		
		public static function objFromJSON(s:String):*
		{
			var obj:Object = new Object();
			
			if (s.charAt(0) == "[")
				obj = [];
			
			s = s.substring(1, s.length - 1);
			
			var array:Array = smartSplit(s, ";");
			
			for each (var pair:String in array)
				if (isComplexPair(pair))
					obj[getKey(pair)] = objFromJSON(getValue(pair));
				else
					obj[getKey(pair)] = getValue(pair);
			
			return obj;
		}
		
		private static function smartSplit(s:String, delimiter:String):Array
		{
			var bracketCount:int = 0;
			var result:Array = [];
			
			var array:Array = s.split("");
			var pair:String = "";
			
			for (var i:int = 0; i < array.length; i++)
			{
				if (array[i] == delimiter && pair.length > 0 && bracketCount == 0)
				{
					result.push(pair);
					pair = "";
					continue;
				}
				
				if (array[i] == "{" || array[i] == "[")
					bracketCount++;
				
				if (array[i] == "}" || array[i] == "]")
					bracketCount--;
				
				pair += array[i];
			}
			
			if (pair.length > 0)
				result.push(pair);
			
			return result;
		}
		
		private static function getKey(s:String):String
		{
			return s.split(":")[0];
		}
		
		private static function getValue(s:String):*
		{
			var val:String = s.substring(s.indexOf(":") + 1);
			
			return (val == "") ? null : val;
		}
		
		private static function isComplexPair(s:String):Boolean
		{
			if (s.indexOf("{") != -1 || s.indexOf("[") != -1)
				return true;
			
			return false;
		}

		public static function generateUniqueID():String
		{
			var result:String = "";
			var id:Number = 1;
			
			for (var j:int = 0; j < 4; j++)
			{
				for (var i:int = 0; i < 10; i++)
					id += Math.random();
				
				result += String(id / 10).substring(2, 7) + "-";
			}
			
			return result.substring(0, result.length - 1);
		}
	
	}

}