package testCase
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import engine.bevtree.BevNode;
	import engine.bevtree.ParallelBranch;
	import engine.bevtree.PriorityBranch;
	import engine.bevtree.SequeueBranch;
	
	/**
	 * Test1
	 * @author hbb
	 */
	public class Test1 extends Sprite
	{
		// ----------------------------------------------------------------
		// :: Static
		
		// ----------------------------------------------------------------
		// :: Public Members
		
		// ----------------------------------------------------------------
		// :: Public Methods
		
		public function Test1()
		{
			super();
			
			if(stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			create();
			stage.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function create():void
		{
			// create behavior tree
			_root =
			new PriorityBranch("root")
			.addChild(
				new SequeueBranch("move",2).addPrecondition( new HasSound )
				.addChild( new FaceTo )
				.addChild( new Idle )
				.addChild( new MoveTo )
				.addChild( new LookAround )
			)
			.addChild(
				new ParallelBranch("patrol",1)
				.addChild( new Hovering )
				.addChild(
					new SequeueBranch("smoking")
					.addChild(new Smoking().addPrecondition((new NoHasQiangDao)))
				)
			);
			
			// create data
			_input = new BevInputData;
			_output = new BevOutputData;
			_output.nextVelocity = new Point( 3, 0 );
			
			// create objects
			_soldier = new Soldier;
			_soldier.x = 200;
			_soldier.y = 200;
			this.addChild(_soldier);
		
		}
		
		public function tick():void
		{
			// prepare data
			_input.target = _clickPos;
			_input.currPosition.x = _soldier.x;
			_input.currPosition.y = _soldier.y;
			_input.currVelocity.x = _output.nextVelocity.x;
			_input.currVelocity.y = _output.nextVelocity.y;
			_input.owner = _soldier;
			
			// ai
			if( _root.evaluate( _input,_output ) )
			{
				_root.doTick( _input, _output );
			}
			
			render();
		}
		
		public function render():void
		{
			const r2a:Number = 180 / Math.PI;
			
			_soldier.rotation = _output.faceDirection * r2a;
			_soldier.x = _output.nextPosition.x;
			_soldier.y = _output.nextPosition.y;
			
			curState = _output.status;
		}
		
		// ----------------------------------------------------------------
		// :: Override Methods
		
		// ----------------------------------------------------------------
		// :: Private Methods
		public function onEnterFrame(e:Event):void
		{
			tick();
		}
		
		public function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		public function onClick(e:MouseEvent):void
		{
			_clickPos = new Point( e.stageX, e.stageY );
			
			this.addChild( new SoundWave( e.stageX, e.stageY ) );
		}
		// ----------------------------------------------------------------
		// :: Private Members
		
		private var _root:BevNode;
		private var _input:BevInputData;
		private var _output:BevOutputData;
		private var _clickPos:Point  = new Point(400,400);
		private var _soldier:Soldier;
		
		[Bindable]
		public var curState:String;
	}
}
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.Dictionary;

import engine.bevtree.BevNode;
import engine.bevtree.InData;
import engine.bevtree.OutData;
import engine.bevtree.PreCondition;
import engine.bevtree.State;

class SoundWave extends Shape
{
	public function SoundWave( x:Number, y:Number )
	{
		this.x = x;
		this.y = y;
		
		this.graphics.beginFill(0, 0.8);
		this.graphics.drawCircle(0,0,8);
		this.graphics.endFill();
		
		this.addEventListener(Event.ENTER_FRAME, update);
	}
	public function update(e:Event):void
	{
		if( this.alpha < 0.05 )
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			if(this.parent)
				this.parent.removeChild(this);
			this.alpha = 0;
		}
		this.alpha *= 0.66;
		this.scaleX *= 1.1;
		this.scaleY = this.scaleX;
	}
}

class Soldier extends Sprite
{
	public function Soldier()
	{
		this.graphics.lineStyle(1,0);
		this.graphics.moveTo(20, -10);
		this.graphics.lineTo(20, +10);
		this.graphics.lineTo(30, 0);
		this.graphics.lineTo(20, -10);
		
		this.graphics.beginFill(0xffffff);
		this.graphics.drawCircle(0,0,25);
		this.graphics.endFill();
	}
	
	public var touchedTargets:Dictionary = new Dictionary;
}

class BevInputData extends InData
{
	public var target:Point;
	public var currPosition:Point = new Point;
	public var currVelocity:Point = new Point;
	public var owner:Soldier;
}

class BevOutputData extends OutData
{
	public var status:String = "";
	public var nextPosition:Point = new Point;
	public var nextVelocity:Point = new Point;
	public var faceDirection:Number;
}


class Smoking extends BevNode
{
	
	override public function doExecute(input:InData, output:OutData):void
	{
		var outputData:BevOutputData = BevOutputData(output);
		outputData.status = "smoking";
		state=State.state_runing;
	}
}
class Coughing extends BevNode
{
	override public function doEnter(input:InData, output:OutData):void
	{
		_times = 5;
		state=State.state_runing;
	}
	override public function doExecute(input:InData, output:OutData):void
	{
		super.doExecute(input,output);
		var outputData:BevOutputData = BevOutputData(output);
		outputData.status = "coughing";
		
		if( --_times > 0 )
			state=State.state_runing;
		else
			state=State.state_exit;
	}
	
	private var _times:int = 0;
}
class Hovering extends BevNode
{
	override public function doEnter(input:InData, output:OutData):void
	{
	
		state=State.state_start;
		_ticks = 0;
		state=State.state_runing;
	}
	override public function doExecute(input:InData, output:OutData):void
	{
		var inputData:BevInputData = BevInputData(input);
		var outputData:BevOutputData = BevOutputData(output);
		outputData.status = "Hovering";
		var v:Point = inputData.currVelocity.clone();
		
		if( int(++_ticks / 20)%2 == 0 )
		{
			v.x = +1;
//			v.y = -v.y;
		}else
		{
			v.x = -1;
//			v.y = +v.y;
		}
		
		v.normalize( 3 );
		outputData.nextVelocity = v;
		outputData.nextPosition = inputData.currPosition.add( v );
		outputData.faceDirection = Math.atan2( v.y, v.x );
		state=State.state_runing;
	}
	
	private var _ticks:int;
}
class FaceTo extends BevNode
{
	override public function doExecute(input:InData, output:OutData):void
	{
		var inputData:BevInputData = BevInputData(input);
		var outputData:BevOutputData = BevOutputData(output);
		outputData.status = "FaceTo";
		var v:Point = inputData.target.subtract( inputData.currPosition );
		outputData.faceDirection = Math.atan2( v.y, v.x );
		state=State.state_exit;
	}
}
class MoveTo extends BevNode
{
	override public function doExecute(input:InData, output:OutData):void
	{
		var inputData:BevInputData = BevInputData(input);
		var outputData:BevOutputData = BevOutputData(output);
		outputData.status = "MoveTo";
		var v:Point = inputData.target.subtract(inputData.currPosition);
		
		if( v.length < inputData.currVelocity.length )
		{
			outputData.nextPosition = inputData.target.clone();
			state=State.state_exit;
			return;
		}
		
		v.normalize( 10 );
		
		outputData.nextVelocity = v;
		outputData.nextPosition = inputData.currPosition.add( outputData.nextVelocity );
		outputData.faceDirection = Math.atan2( v.y, v.x );
		state=State.state_runing;
	}
}
class LookAround extends BevNode
{
	override public function doEnter(input:InData, output:OutData):void
	{
		super.doEnter(input,output);
		_times = 3 + Math.random() * 3;
		_ticks = -1;
		state=State.state_runing;
	}
	override public function doExecute(input:InData, output:OutData):void
	{
		var inputData:BevInputData = BevInputData(input);
		var outputData:BevOutputData = BevOutputData(output);
		outputData.status = "LookAround";
		if( ++_ticks % 12 == 0 )
		{
			outputData.faceDirection = Math.PI * 2 * Math.random();
			--_times;
		}
		
		if( _times > 0 )
			state=State.state_runing; 
		else
		{
			inputData.owner.touchedTargets[ inputData.target ] = true;
			outputData.nextVelocity.x = Math.cos( outputData.faceDirection ) * inputData.currVelocity.length;
			outputData.nextVelocity.y = Math.sin( outputData.faceDirection ) * inputData.currVelocity.length;
			state=State.state_exit;
		}
	}
	
	private var _ticks:int;
	private var _times:int;
}
class Idle extends BevNode
{
	override public function doEnter(input:InData, output:OutData):void
	{
		super.doEnter(input,output);
		_waitTicks = 1;
		state=State.state_runing;
	}
	override public function doExecute(input:InData, output:OutData):void
	{
		var outputData:BevOutputData = BevOutputData(output);
		outputData.status = "Idle";
		if( --_waitTicks > 0 )
			state=State.state_runing;
		else
			state=State.state_exit;
	}
	
	private var _waitTicks:int;
}
class HasSound extends PreCondition
{
	override public function evaluate(inData:InData,outData:OutData):Boolean
	{
		var inputData:BevInputData = BevInputData(inData);
		var check:Boolean = inputData.target && !inputData.owner.touchedTargets[ inputData.target ];
		return check;
	}
}
class TouchSound extends PreCondition
{
	override public function evaluate(inData:InData,outData:OutData):Boolean
	{
		var inputData:BevInputData = BevInputData(inData);
		return inputData.currPosition.subtract( inputData.target ).length < 0.5;
	}
}
class NoHasQiangDao extends PreCondition
{
	override public function evaluate(inData:InData,outData:OutData):Boolean
	{
		return Math.random() > 0.1;
	}
}
class NoHasCoughFeeling extends PreCondition
{
	override public function evaluate(inData:InData,outData:OutData):Boolean
	{
		return Math.random() > 0.1;
	}
}