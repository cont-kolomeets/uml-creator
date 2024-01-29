package supportClasses
{
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Filter
	{
		private static var shadowFilter:DropShadowFilter;
		private static var glowFilter:GlowFilter;
		
		public static function applyFilter(object:DisplayObject, useShadow:Boolean = false, useGlow:Boolean = false):void
		{
			var filters:Array = [];
			
			if (useShadow)
			{
				shadowFilter = new DropShadowFilter();
				filters.push(shadowFilter);
			}
			
			if (useGlow)
			{
				glowFilter = new GlowFilter(0, 0.5);
				filters.push(glowFilter);
			}
			
			object.filters = filters;
		}
	
	}

}