package engine.bevtree
{
	public class State
	{
		
		public static var state_idel:uint = 0;
		public static var state_start:uint = 1;
		public static var state_runing:uint = 2;
		public static var state_exit:uint = 3;
		protected var _curState:uint;
		public function State()
		{
			_curState = state_idel;
		}
		public function set curState(state:uint):void
		{
			_curState = state;
		}
		public function get curState():uint
		{
			return _curState;
		}
		public function doEnter(inData:InData,outData:OutData):void
		{
			_curState = state_runing; 
		}
		public function doExecute(inData:InData,outData:OutData):void
		{
			_curState = state_exit;
		}
		public function doExit(inData:InData,outData:OutData):void
		{
			_curState = state_idel;
		}
	}
}