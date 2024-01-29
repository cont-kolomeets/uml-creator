package supportClasses
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Prisoners
	{
		private static var prisoners:Array = [];
		private static var nPrisoners:int = 0;
		
		private static function fillPrisoners():void
		{
			for (var i:int = 0; i < nPrisoners; i++)
			{
				var pr:Object = new Object();
				
				if (i == int(nPrisoners / 2))
					pr.type = "counter";
				else
					pr.type = "normal";
				
				pr.switchedOnAlready = false;
				
				prisoners.push(pr);
			}
		}
		
		private static function getRandomPrisoner():Object
		{
			return prisoners[int(Math.random() * nPrisoners)];
		}
		
		public static function execute(numberOfPrisoners:int = 100):int
		{
			nPrisoners = numberOfPrisoners;
			var iterationsCount:int = 0;
			var lampIsOn:Boolean = false;
			var prCount:int = 0;
			
			fillPrisoners();
			
			while (true)
			{
				iterationsCount++;
				
				var pr:Object = getRandomPrisoner();
				
				if (pr.type == "normal" && !pr.switchedOnAlready && !lampIsOn)
				{
					lampIsOn = true;
					pr.switchedOnAlready = true;
				}
				
				if (pr.type == "counter" && lampIsOn)
				{
					lampIsOn = false;
					prCount++;
					if (prCount == (nPrisoners - 1))
					{
						break;
					}
				}
			}
			
			return iterationsCount;
		}
	
	}

}