package supportClasses
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Graph extends Sprite
	{
		public var center:Point = new Point();
		public var lineColor:int = 0;
		public var lineWeight:int = 1;
		public var lineAlpha:Number = 1;
		public var isDash:Boolean = false;
		
		public function Graph()
		{
			super();
		}
		
		public function drawBezierCurve(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
		{
			var cx:Number = 3 * (x1 - x0);
			var bx:Number = 3 * (x2 - x1) - cx;
			var ax:Number = x3 - x0 - cx - bx;
			var cy:Number = 3 * (y1 - y0);
			var by:Number = 3 * (y2 - y1) - cy;
			var ay:Number = y3 - y0 - cy - by;
			
			graphics.clear();

			var dist:Number = Math.sqrt((x3 - x0) * (x3 - x0) + (y3 - y0) * (y3 - y0));
			var precision:Number = Math.min(1 / dist * 3, 0.02);
			var cycles:int = Math.round(1 / precision);
			
			var curX:Number = x0;
			var curY:Number = y0;
			
			for (var i:int = 0; i <= cycles; i++)
			{
				var t:Number = precision * i;
				
				graphics.moveTo(curX, curY);
				curX = ax * t * t * t + bx * t * t + cx * t + x0;
				curY = ay * t * t * t + by * t * t + cy * t + y0;
				
				graphics.lineStyle(lineWeight, lineColor, !isDash || i % 2 ? lineAlpha : 0);
				graphics.lineTo(curX, curY);
				
				if (i === Math.floor(cycles / 2))
				{
					center.x = curX;
					center.y = curY;
				}
			}
		}
	
	}

}