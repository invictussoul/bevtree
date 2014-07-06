package testCase
{
	import flash.display.Sprite;
	/**
	 * behaviortree
	 * @author hbb
	 */
	public class behaviortree extends Sprite
	{
		// ----------------------------------------------------------------
		// :: Static
		
		// ----------------------------------------------------------------
		// :: Public Members
		
		// ----------------------------------------------------------------
		// :: Public Methods
		[Bindable]
		public var test:Test1;
		public function behaviortree()
		{
			test = new Test1();
			this.addChild( test );
		}
		
		// ----------------------------------------------------------------
		// :: Override Methods
		
		// ----------------------------------------------------------------
		// :: Private Methods
		
		// ----------------------------------------------------------------
		// :: Private Members
	}
}