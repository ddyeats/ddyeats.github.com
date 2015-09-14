package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	public class gameObject extends MovieClip {
		private static const cardRowNum:uint = 6;
		private static const cardColNum:uint = 6;
		private static const cardWifth:uint = 58;
		private static const cardHeight:uint = 58;
		private static const paddingLeft:uint = 130;
		private static const paddingTop:uint = 70;
		
		private var firstCard:Card;
		private var secondCard:Card;
		private var cardsLeft:uint;
		
		private var pointsForMatch:int = 10;
		private static const pointsForMiss:int = -5;
		private var gameScore:int;
		private var lastMinuts:uint = 0;
		
		private var gameStatrTime:uint;
		private var gameTime:uint;
		
		private var gameScoreField:TextField;
		private var gameTimeField:TextField;
		
		private var flipBackTimer:Timer;
		
		var theFirstCardSound:FirstCardSound = new FirstCardSound();
		var theMissSound:MissSound = new MissSound();
		var theMathSound:MatchSound = new MatchSound();
		
		var myFormat:TextFormat = new TextFormat();
		
		/**
		 *显示6*6个卡片
		 */
		public function gameObject() {
			//添加图片列表
			var cardList:Array = new Array();
			for (var i:uint = 0; i < cardRowNum * cardColNum / 2; i++ ) {
				cardList.push(i);
				cardList.push(i);
			}
			for(var x:uint=0;x<cardRowNum;x++) {
				for(var y:uint=0;y<cardColNum;y++) {
					var newCard:Card = new Card();
					newCard.stop();
					newCard.x = x * cardWifth + paddingLeft;
					newCard.y = y * cardHeight + paddingTop;
					var r:uint = Math.floor(Math.random() * cardList.length);
					newCard.cardface = cardList[r];
					cardList.splice(r, 1);
					newCard.addEventListener(MouseEvent.CLICK, clickCard);
					newCard.buttonMode = true;
					addChild(newCard);
					cardsLeft++;
				}
			}
			
			myFormat.font = "Arial";
			myFormat.size = 24;
			myFormat.bold = true;
			
			gameScoreField = new TextField();
			gameScoreField.autoSize = TextFieldAutoSize.LEFT;
			gameScoreField.defaultTextFormat = myFormat;
			addChild(gameScoreField);
			gameScore = 0;
			showScore();
			
			gameTimeField = new TextField();
			gameTimeField.defaultTextFormat = myFormat;
			gameTimeField.autoSize = TextFieldAutoSize.LEFT;
			gameTimeField.x = 420;
			addChild(gameTimeField);
			gameStatrTime = getTimer();
			gameTime = 0;
			addEventListener(Event.ENTER_FRAME, showTime);
			
			pointsForMatch = MovieClip(root).point;
		}
		/**
		 *点击卡片显示卡片内容
		 */
		public function clickCard(e:MouseEvent):void {
			var thisCard:Card = (e.target as Card);
			if (firstCard == null) {
				firstCard = thisCard;
				firstCard.startFlip(thisCard.cardface + 2);
				playSound(theFirstCardSound);
			} else if (firstCard == thisCard) {
				firstCard.startFlip(1);
				firstCard = null;
				playSound(theMissSound);
			} else if (secondCard == null) {
				secondCard = thisCard;
				secondCard.startFlip(thisCard.cardface + 2);
				if (firstCard.cardface == secondCard.cardface) {
					removeChild(firstCard);
					removeChild(secondCard);
					firstCard = null;
					secondCard = null;
					gameScore += pointsForMatch;
					showScore();
					playSound(theMathSound);
					cardsLeft -= 2;
					if (cardsLeft == 0) {
						MovieClip(root).gameScore = gameScore;
						MovieClip(root).gameTime = clockTime(gameTime);
						MovieClip(root).gotoAndStop("gameOver");
					}
				} else {
					gameScore += pointsForMiss;
					showScore();
					playSound(theMissSound);
					flipBackTimer = new Timer(2000, 1);
					flipBackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, returnCards);
					flipBackTimer.start();
				}
			} else {
				returnCards(null);
				playSound(theFirstCardSound);
				firstCard = thisCard;
				firstCard.startFlip(thisCard.cardface + 2);
			}
		}
		/**
		 * 显示得分
		 */
		public function showScore():void {
			gameScoreField.text = "Score: " + String(gameScore);
		}
		/**
		 * 显示时间
		 */
		public function showTime(e:Event):void {
			gameTime = getTimer() - gameStatrTime;
			gameTimeField.text = "Time: " + clockTime(gameTime);
		}
		
		public function clockTime(ms:int):String {
			var seconds:int = Math.floor(ms / 1000);
			var minutes:int = Math.floor(seconds / 60);
			if (minutes - lastMinuts == 1) {
				lastMinuts = minutes;
				gameScore -= pointsForMatch;
				showScore();
			}
			seconds -= minutes * 60;
			var timeString:String = minutes + ":" + String(seconds + 100).substr(1, 2);
			return timeString;
		}
		/**
		 * 2秒翻回
		 */
		public function returnCards(e:TimerEvent) {
			firstCard.startFlip(1);
			secondCard.startFlip(1);
			firstCard = null;
			secondCard = null;
			flipBackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, returnCards);
		}
		/**
		 * 播放声音
		 */
		public function playSound(soundObject:Object) {
			var channel:SoundChannel = soundObject.play();
		}
	}
	
}
