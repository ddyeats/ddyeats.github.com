package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	public class Deduction extends MovieClip {
		public var lightsNum:uint = 5;
		//正确的亮灯情况
		public var correctLights:Array;
		//当前行的亮灯情况
		public var currentLights:Array;
		//当前显示的文本信息
		public var currentText:TextField;
		//显示的行数
		public var lineNum:uint = 10;
		//显示的所有对象
		public var allDisplayObject:Array;
		//当前的行数
		public var currentLine:uint;
		//当前的Done按钮
		public var currentDone:DoneButton;
		
		public var paddingLeft:uint = 20;
		public var paddingTop:uint = 60;
		public var lightWidth:uint = 40;
		public var lightHight:uint = 30;
		public var btnWidth:uint = 70;
		//完全匹配的数量
		public var correctNum:uint = 0;
		//颜色匹配，位置不匹配的数量
		public var partCorrectNum:uint = 0;
		//正确亮灯组没有匹配上的情况
		public var corrComprArr:Array;
		//当前亮灯组没有匹配上的情况
		public var currComprArr:Array;
		//游戏是否结束
		public var isOver:Boolean;
		
		public function Deduction() {
			// constructor code
		}
		/**
		 * 开始游戏，进入第一行
		 */
		public function startGame():void {
			isOver = false;
			var index:uint;
			correctLights = new Array();
			allDisplayObject = new Array();
			for (var i:uint = 0; i < lightsNum; i++ ) {
				index = uint(Math.floor(Math.random() * lightsNum + 1));
				correctLights.push(index);
			}
			currentLine = 0;
			turnToNextLine();
		}
		/**
		 * 显示下一行
		 */
		public function turnToNextLine(showLight:Boolean = true, showCorrect:Boolean=false, showLabel:String=""):void {
			if (showLight) {
				currentLights = new Array();
				for (var i:uint = 0; i < lightsNum; i++ ) {
					var light:Light = new Light();
					light.x = paddingLeft + i * lightWidth;
					light.y = paddingTop + currentLine * lightHight;
					light.gotoAndStop(showCorrect?correctLights[i]+1:1);
					light.addEventListener(MouseEvent.CLICK, lightClick);
					light.buttonMode = true;
					light.num = i;
					addChild(light);
					currentLights.push( { Light:light, color:0 } );
					allDisplayObject.push(light);
				}
			}
			if (currentDone == null) {
				currentDone = new DoneButton();
				currentDone.x = paddingLeft + lightWidth * lightsNum;
				currentDone.y = paddingTop + currentLine * lightHight;
				currentDone.addEventListener(MouseEvent.CLICK, doneClick);
				addChild(currentDone);
				allDisplayObject.push(currentDone);
			} else {
				currentDone.y = paddingTop + currentLine * lightHight;
			}
			currentText = new TextField();
			currentText.text = showLabel?showLabel:"选择灯的颜色，确定后点击按钮！";
			currentText.x = paddingLeft + lightWidth * lightsNum + btnWidth;
			currentText.y = paddingTop + currentLine * lightHight;
			currentText.width = 300;
			allDisplayObject.push(currentText);
			addChild(currentText);
		}
		/**
		 * 点击灯
		 */
		public function lightClick(e:MouseEvent):void {
			var tar:Object = currentLights[e.currentTarget.num];
			var color:uint = tar.color;
			if (color < lightsNum) {
				tar.color = color +1;
			} else {
				tar.color = 0;
			}
			tar.Light.gotoAndStop(tar.color +1);
		}
		/**
		 * 点击Done按钮，进行判断
		 */
		public function doneClick(e:MouseEvent):void {
			if (isOver) {
				clearGame();
				MovieClip(root).gotoAndStop("gameover");
				return;
			}
			correctNum = 0;
			partCorrectNum = 0;
			corrComprArr = [0, 0, 0, 0, 0];
			currComprArr = [0, 0, 0, 0, 0];
			for (var i:uint = 0; i < lightsNum; i++ ) {
				if (correctLights[i] == currentLights[i].color) {
					correctNum++;
				} else {
					corrComprArr[correctLights[i] - 1]++;
					if (currentLights[i].color > 0)
						currComprArr[currentLights[i].color - 1]++;
				}
			}
			for (var x:uint = 0; x < lightsNum; x++ ) {
				partCorrectNum += Math.min(corrComprArr[x], currComprArr[x]);
			}
			currentText.text = "完全匹配：" + correctNum + " , " + "颜色匹配：" + partCorrectNum;
			currentLine++;
			if (correctNum == lightsNum) {
				isOver = true;
				turnToNextLine(false,false, "你赢了！");
			} else if (currentLine == lineNum) {
				isOver = true;
				turnToNextLine(true, true, "你失败了！");
			} else {
				turnToNextLine();
			}
		}
		/**
		 * 清理数据
		 */
		public function clearGame():void {
			for(var i in allDisplayObject)
				removeChild(allDisplayObject[i]);
			allDisplayObject = null;
			currentDone = null;
			currentLights = null;
			currentText = null;
		}
	}
	
}
