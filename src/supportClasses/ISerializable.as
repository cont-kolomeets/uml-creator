package supportClasses 
{
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public interface ISerializable 
	{
		function serialize():Object;
		function implementDeserializedProperties(obj:Object):void;
	}

}