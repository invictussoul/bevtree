package engine.bevtree
{
	public class ParallelBranch extends BevBranch
	{
		
		public function ParallelBranch(name:String="",priority:uint=0)
		{
			super(name,priority);
		}
		override public function evaluate(inData:InData, outData:OutData):Boolean
		{
			return super.evaluate(inData,outData);	
		}
		override public function doTick(inData:InData, outData:OutData):void
		{
			 	for each(var child:BevNode in _childs)
				{
					child.doTick(inData ,outData);
				}
				
		}
	}
}