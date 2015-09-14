package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	
	public class merryGame extends MovieClip {
		private static const numLights:uint = 5;
		
		private var lights:Array;
		private var playOrder:Array;
		private var repeatOrder:Array;
		
		private var textMessage:TextField;
		private var textScore:TextField;
		
		private var lightTimer:Timer;
		private var offTimer:Timer;
		
		private var gameMode:String;
		private var currentSelection:MovieClip = null;
		private var soundList:Array;
		
		public function merryGame() {
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.size = 24;
			textFormat.align = "center";
			
			textMessage = new TextField();
			textMessage.width = 550;
			textMessage.y = 110;
			textMessage.selectable = false;
			textMessage.defaultTextFormat = textFormat;
			addChild(textMessage);
			
			textScore = new TextField();
			textScore.width = 550;
			textScore.y = 250;
			textScore.selectable = false;
			textScore.defaultTextFormat = textFormat;
			addChild(textScore);
			//添加声音
			soundList = new Array();
			var thisSound:Sound;
			var req:URLRequest;
			for (var i:uint = 1; i <= numLights; i++ ) {
				thisSound = new Sound();
				req = new URLRequest("note" + i + ".mp3");
				thisSound.load(req);
				soundList.push(thisSound);
			}
			//添加灯
			lights = new Array();
			var thisLight:light;
			for (i = 0; i < numLights; i++ ) {
				thisLight = new light();
				thisLight.lightColors.gotoAndStop(i + 1);
				thisLight.x = i * 75 + 100;
				thisLight.y = 175;
				thisLight.lightNum = i;
				lights.push(thisLight);
				addChild(thisLight);
				thisLight.addEventListener(MouseEvent.CLICK, clickLight);
				thisLight.buttonMode = true;
			}
			
			playOrder = new Array();
			gameMode = "play";
			nextTurn();
		}
		/**
		 * 下一次循环
		 */
		public function nextTurn() {
			var r:uint = Math.floor(Math.random() * numLights);
			playOrder.push(r);
			
			textMessage.text = "Watch and Listen.";
			textScore.text = "Sequence Length: " + playOrder.length;
			
			lightTimer = new Timer(1000, playOrder.length + 1);
			lightTimer.addEventListener(TimerEvent.TIMER, lightSequence);
			lightTimer.start();
		}
		/**
		 * 依次点亮灯
		 */
		public function lightSequence(e:TimerEvent) {
			var playStep:uint = e.currentTarget.currentCount - 1;
			
			if (playStep < playOrder.length) {
				lightOn(playOrder[playStep]);
			} else {
				startPlayerRepeat();
			}
		}
		/**
		 * 灯亮完后由玩家操作
		 */
		public function startPlayerRepeat() {
			currentSelection = null;
			textMessage.text = "Repeat.";
			gameMode = "replay";
			repeatOrder = playOrder.concat();
		}
		/**
		 * 点亮灯的方法
		 */
		public function lightOn(newLight) {
			soundList[newLight].play();
			currentSelection = lights[newLight];
			currentSelection.gotoAndStop(2);
			offTimer = new Timer(500, 1);
			offTimer.addEventListener(TimerEvent.TIMER_COMPLETE, lightOff);
			offTimer.start();
		}
		/**
		 * 关灯
		 */
		public function lightOff(e:TimerEvent) {
			if (currentSelection != null) {
				currentSelection.gotoAndStop(1);
				currentSelection = null;
				offTimer.stop();
			}
		}
		/**
		 * 玩家点灯的操作
		 */
		public function clickLight(e:MouseEvent) {
			if (gameMode != "replay") return;
			lightOff(null);
			if (e.currentTarget.lightNum == repeatOrder.shift()) {
				lightOn(e.currentTarget.lightNum);
				if (repeatOrder.length == 0) {
					nextTurn();
				}
			} else {
				textMessage.text = "Game Over!";
				gameMode = "gameover";
			}
		}
	}
	
}
