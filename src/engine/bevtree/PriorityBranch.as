package engine.bevtree
{
	public class PriorityBranch extends BevBranch
	{
	 
		private var _maxPriorityChild:BevNode = null;
		
		
		public function PriorityBranch(name:String="",priority:uint=0)
		{
			super(name,priority);
		}
		
		override public function evaluate(inData:InData, outData:OutData):Boolean
		{
			return super.evaluate(inData,outData);
		}
		override public function doTick(inData:InData, outData:OutData):void
		{
			if(_maxPriorityChild == null||_maxPriorityChild.state==State.state_exit)
			{
				_maxPriorityChild = getMaxPriorityChild();
				
			}else
			{
				var newMaxPriority:BevNode = getMaxPriorityChild();
				if(_maxPriorityChild!=newMaxPriority)
				{
					_maxPriorityChild.doTrans(inData,outData,_maxPriorityChild,newMaxPriority);
					_maxPriorityChild = newMaxPriority;
				}
				
			}
			_maxPriorityChild.doTick(inData,outData);
		}
		private function getMaxPriorityChild():BevNode
		{
			var ret:BevNode =null;
			if(_childs.length>0)
			{
				ret = _childs[0];
				for(var i:int=1;i<_childs.length;i++)
				{
					if(_childs[i].priority>ret.priority)
					{
						ret = _childs[i];
					}
				}
			}
			return ret;
		}
		
	}
}