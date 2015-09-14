package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public dynamic class Card extends MovieClip {
		private var flipStep:uint;
		private var isFlipping:Boolean = false;
		private var flipToFrame:uint;
		
		public function startFlip(flipToWhichFrame:uint) {
			isFlipping = true;
			flipStep = 10;
			flipToFrame = flipToWhichFrame;
			this.addEventListener(Event.ENTER_FRAME, flip);
		}
		
		public function flip(e:Event) {
			flipStep--;
			if (flipStep > 5) {
				this.scaleX = .2 * (flipStep - 6);
			} else {
				this.scaleX = .2 * (5 - flipStep);
			}
			if (flipStep == 5) {
				gotoAndStop(flipToFrame);
			}
			if (flipStep == 0) {
				this.removeEventListener(Event.ENTER_FRAME, flip);
			}
		}
	}
	
}
