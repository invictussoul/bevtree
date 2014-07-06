package engine.bevtree
{
	public class BevBranch extends BevNode
	{
	
		public function BevBranch(name:String="",priority:uint=0)
		{
			super(name,priority);
		}
		override public function evaluate(inData:InData,outData:OutData):Boolean
		{
			var ret:Boolean = false;
			for each(var child:BevNode in _childs)
			{
				if(child.evaluate(inData,outData))
				{
					
					if(_selectNodes.indexOf(child)==-1)
					{
						_selectNodes.push(child);	
					}
					ret = true;
				}
			}
			return ret;
		}
		override public function doTick(inData:InData,outData:OutData):void
		{
			
		}
		
	
	}
}