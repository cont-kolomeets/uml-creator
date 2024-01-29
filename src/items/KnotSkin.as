package items
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class KnotSkin extends Sprite
	{
		public var hostComponent:Knot;
		public var lineOffsetX:Number = 0;
		public var lineOffsetY:Number = 0;
		
		private var pseudoLine:Sprite = new Sprite();
		private var mouseFeel:Sprite = new Sprite();
		
		private var pointRadius:Number = 5;
		private var triangleSide:Number = 5;
		private var diamondSide:Number = 5;
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		public function KnotSkin()
		{
			pseudoLine.doubleClickEnabled = true;
			mouseFeel.doubleClickEnabled = true;
			
			addChild(pseudoLine);
			addChild(mouseFeel);
		}
		
		public function drawKnot():void
		{
			graphics.clear();
			resetOffset();
			
			switch (hostComponent.type)
			{
				case KnotType.POINT: 
					drawPoint();
					break;
				case KnotType.DIAMOND: 
					drawDiamond();
					break;
				case KnotType.EMPTY_ARROW: 
					drawTriangle(false);
					break;
				case KnotType.FILLED_ARROW: 
					drawTriangle(true);
					break;
			}
		
		}
		
		private function resetOffset():void
		{
			offsetX = 0;
			offsetY = 0;
			lineOffsetX = 0;
			lineOffsetY = 0;
		}
		
		private function drawPoint():void
		{
			if (hostComponent.state == KnotState.CONNECTED)
			{
				graphics.lineStyle(2, 0x555555, 0.8);
				graphics.beginFill(0x555555, 0.5);
			}
			else
			{
				graphics.lineStyle(2, 0x555555, hostComponent.hidden ? 0.1 : 0.8);
				graphics.beginFill(0xDDDDDD, hostComponent.hidden ? 0.1 : 0.5);
			}
			
			if (hostComponent.position == KnotPosition.TOP)
			{
				lineOffsetY = -pointRadius * 2;
				offsetY = -pointRadius;
				
				if (hostComponent.showArrow)
				{
					graphics.moveTo(0, lineOffsetY);
					graphics.lineTo(5, lineOffsetY - 5);
					graphics.moveTo(0, lineOffsetY);
					graphics.lineTo(-5, lineOffsetY - 5);
				}
			}
			
			if (hostComponent.position == KnotPosition.BOTTOM)
			{
				lineOffsetY = pointRadius * 2;
				offsetY = pointRadius;
				
				if (hostComponent.showArrow)
				{
					graphics.moveTo(0, lineOffsetY);
					graphics.lineTo(5, lineOffsetY + 5);
					graphics.moveTo(0, lineOffsetY);
					graphics.lineTo(-5, lineOffsetY + 5);
				}
			}
			
			if (hostComponent.position == KnotPosition.LEFT)
			{
				lineOffsetX = -pointRadius * 2;
				offsetX = -pointRadius;
				
				if (hostComponent.showArrow)
				{
					graphics.moveTo(lineOffsetX, 0);
					graphics.lineTo(lineOffsetX - 5, 5);
					graphics.moveTo(lineOffsetX, 0);
					graphics.lineTo(lineOffsetX - 5, -5);
				}
			}
			
			if (hostComponent.position == KnotPosition.RIGHT)
			{
				lineOffsetX = pointRadius * 2;
				offsetX = pointRadius;
				
				if (hostComponent.showArrow)
				{
					graphics.moveTo(lineOffsetX, 0);
					graphics.lineTo(lineOffsetX + 5, 5);
					graphics.moveTo(lineOffsetX, 0);
					graphics.lineTo(lineOffsetX + 5, -5);
				}
			}
			
			graphics.drawCircle(offsetX, offsetY, pointRadius);
		}
		
		private function drawDiamond():void
		{
			if (hostComponent.position == KnotPosition.TOP)
			{
				offsetX = -diamondSide;
				offsetY = -diamondSide;
				lineOffsetX = 0;
				lineOffsetY = -diamondSide * 2;
			}
			
			if (hostComponent.position == KnotPosition.LEFT)
			{
				lineOffsetX = -diamondSide * 2;
				offsetX = -diamondSide * 2;
			}
			
			if (hostComponent.position == KnotPosition.RIGHT)
			{
				lineOffsetX = diamondSide * 2;
			}
			
			if (hostComponent.position == KnotPosition.BOTTOM)
			{
				offsetX = -diamondSide;
				offsetY = diamondSide;
				lineOffsetX = 0;
				lineOffsetY = diamondSide * 2;
			}
			
			if (hostComponent.state == KnotState.CONNECTED)
			{
				graphics.lineStyle(2, 0x555555, 0.8);
				graphics.beginFill(0x555555, 0.5);
			}
			else
			{
				graphics.lineStyle(2, 0x555555, hostComponent.hidden ? 0.1 : 0.8);
				graphics.beginFill(0xDDDDDD, hostComponent.hidden ? 0.1 : 0.5);
			}
			
			graphics.moveTo(offsetX, offsetY);
			graphics.lineTo(diamondSide + offsetX, -diamondSide + offsetY);
			graphics.lineTo(diamondSide * 2 + offsetX, offsetY);
			graphics.lineTo(diamondSide + offsetX, diamondSide + offsetY);
			graphics.lineTo(offsetX, offsetY);
		}
		
		private function drawTriangle(filled:Boolean):void
		{
			if (hostComponent.position == KnotPosition.TOP)
			{
				offsetX = -triangleSide;
				offsetY = -triangleSide;
				lineOffsetX = 0;
				lineOffsetY = -triangleSide * 2;
			}
			
			if (hostComponent.position == KnotPosition.LEFT)
			{
				lineOffsetX = -triangleSide * 2;
				offsetX = -triangleSide * 2;
			}
			
			if (hostComponent.position == KnotPosition.RIGHT)
			{
				lineOffsetX = triangleSide * 2;
			}
			
			if (hostComponent.position == KnotPosition.BOTTOM)
			{
				offsetX = -triangleSide;
				offsetY = triangleSide;
				lineOffsetX = 0;
				lineOffsetY = triangleSide * 2;
			}
			
			if (hostComponent.state == KnotState.CONNECTED)
			{
				graphics.lineStyle(2, 0x555555, 0.8);
				graphics.beginFill(0x555555, 0.5);
			}
			else
			{
				graphics.lineStyle(2, 0x555555, hostComponent.hidden ? 0.1 : 0.8);
				graphics.beginFill(0xDDDDDD, hostComponent.hidden ? 0.1 : 0.5);
			}
			
			if (hostComponent.position == KnotPosition.RIGHT)
			{
				graphics.moveTo(offsetX, offsetY);
				graphics.lineTo(triangleSide * 2 + offsetX, -triangleSide + offsetY);
				graphics.lineTo(triangleSide * 2 + offsetX, triangleSide + offsetY);
				graphics.lineTo(offsetX, offsetY);
			}
			
			if (hostComponent.position == KnotPosition.LEFT)
			{
				graphics.moveTo(triangleSide * 2 + offsetX, offsetY);
				graphics.lineTo(offsetX, -triangleSide + offsetY);
				graphics.lineTo(offsetX, triangleSide + offsetY);
				graphics.lineTo(triangleSide * 2 + offsetX, offsetY);
			}
			
			if (hostComponent.position == KnotPosition.TOP)
			{
				graphics.moveTo(triangleSide + offsetX, triangleSide + offsetY);
				graphics.lineTo(offsetX, -triangleSide + offsetY);
				graphics.lineTo(triangleSide * 2 + offsetX, -triangleSide + offsetY);
				graphics.lineTo(triangleSide + offsetX, triangleSide + offsetY);
			}
			
			if (hostComponent.position == KnotPosition.BOTTOM)
			{
				graphics.moveTo(triangleSide + offsetX, -triangleSide + offsetY);
				graphics.lineTo(offsetX, triangleSide + offsetY);
				graphics.lineTo(triangleSide * 2 + offsetX, triangleSide + offsetY);
				graphics.lineTo(triangleSide + offsetX, -triangleSide + offsetY);
			}
		
		}
		
		public function drawPseudoLineTo(xTo:Number, yTo:Number):void
		{
			pseudoLine.graphics.clear();
			pseudoLine.graphics.lineStyle(2, 0xAAAAAA, 0.8);
			pseudoLine.graphics.drawCircle(xTo, yTo, pointRadius);
			pseudoLine.graphics.moveTo(lineOffsetX, lineOffsetY);
			pseudoLine.graphics.lineTo(xTo, yTo);
		}
		
		public function clearPseudoLine():void
		{
			pseudoLine.graphics.clear();
		}
		
		public function drawOverRect():void
		{
			mouseFeel.graphics.lineStyle(1, 0xFF0000, 0.8);
			mouseFeel.graphics.beginFill(0, 0);
			
			if (hostComponent.type == KnotType.POINT)
				mouseFeel.graphics.drawRect(-10 + offsetX, -10 + offsetY, 20, 20);
			
			if (hostComponent.type == KnotType.DIAMOND)
				mouseFeel.graphics.drawRect(-10 + offsetX + diamondSide, -10 + offsetY, 20, 20);
			
			if (hostComponent.type == KnotType.FILLED_ARROW || hostComponent.type == KnotType.EMPTY_ARROW)
				mouseFeel.graphics.drawRect(-10 + offsetX + triangleSide, -10 + offsetY, 20, 20);
		}
		
		public function clearOverRect():void
		{
			mouseFeel.graphics.clear();
		}
	
	}

}