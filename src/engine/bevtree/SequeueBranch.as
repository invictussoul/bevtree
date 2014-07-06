package engine.bevtree
{
	public class SequeueBranch extends BevBranch
	{
		private var _topChild:BevNode ; 
		public function SequeueBranch(name:String="",priority:uint=0)
		{
			super(name,priority);
			_topChild = null;
		}
		
		override public function evaluate(inData:InData, outData:OutData):Boolean
		{
			return super.evaluate(inData,outData);
		}
		override public function doTick(inData:InData, outData:OutData):void
		{
			if(_selectNodes.length>0)
			{
				if(_topChild == null||_topChild.state==State.state_idel)
				{
					_topChild = _selectNodes[0];
					
				}
				_topChild.doTick(inData,outData);
				
			}
		}
	}
}