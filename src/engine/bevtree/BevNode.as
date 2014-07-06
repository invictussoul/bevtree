package engine.bevtree
{
	public class  BevNode
	{
		protected var _name:String;
		protected var _preConditions:Vector.<PreCondition>;
		protected var _owner:BevNode;
		protected var _state:State;
		protected var _priority:uint ;
		protected var _childs:Vector.<BevNode>;
		protected var _selectNodes:Vector.<BevNode>;
		
		public function BevNode(name:String="",priority:uint=0)
		{
			_name = name;
			_priority = priority;
			_preConditions = Vector.<PreCondition>([]);
			_childs = Vector.<BevNode>([]);
			_selectNodes = Vector.<BevNode>([]);
			_state = new State();
		}
		public function set owner(o:BevNode):void
		{
			_owner = o;
		}
		public function get owner():BevNode
		{
			return _owner;
		}
		public function set priority(pr:uint):void
		{
			_priority = pr;
		}
		public function get priority():uint
		{
			return _priority;
		}
		
		public function evaluate(inData:InData,outData:OutData):Boolean
		{
			return true;
		}
		
		public function addPrecondition(preCon:PreCondition):BevNode
		{
			_preConditions.push(preCon);
			return this;
		}
		public function addChild(child:BevNode):BevNode
		{
			_childs.push(child);
			child.owner = this;
			return this;
		}
		public function unSelect():void
		{
			if(_owner)
			{
				_owner.unSelectChild (this);
			}
		}
		public function get state():uint
		{
			return _state.curState;
		}
		public function set state(st:uint):void
		{
			_state.curState = st;
		}
		public function doTick(inData:InData, outData:OutData):void
		{
			switch(_state.curState)
			{
				case State.state_idel:
				{
					doEnter(inData,outData);	
					break;
				}
				case State.state_start:
				{
					doEnter(inData,outData);	
					break;
				}
				case State.state_runing:
				{
					doExecute(inData,outData);
					break;
				}
				case State.state_exit:
				{
					doExit(inData,outData);
					break;
				}	
				default:
				{
					break;
				}
			}
			
		}
		public function doTrans(inData:InData,outData:OutData,from:BevNode,to:BevNode):void
		{
			from.state = State.state_exit;
			from.doTick(inData,outData);	
			to.state = State.state_start;
		}
		public function doEnter(inData:InData,outData:OutData):void
		{
			_state.doEnter(inData,outData); 
		}
		public function doExecute(inData:InData,outData:OutData):void
		{
			_state.doExecute(inData,outData);	
		}
		public function doExit(inData:InData,outData:OutData):void
		{
			_state.doExit(inData,outData);
			unSelect();
		}
		public function unSelectChild(child:BevNode):void
		{
			var index:int = _selectNodes.indexOf(child);
			if(index !=-1)
			{
				_selectNodes.splice(index,1);
			}
		}
		
		
	}
}