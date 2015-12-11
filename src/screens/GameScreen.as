package screens 
{
	import actors.AI;
	import actors.Ball;
	import actors.Paddle;
	import actors.Player;
	import actors.Powerup;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import utils.MovementCalculator;
	import screens.Scoreboard;
	
	/**
	 * ...
	 * @author erwin henraat
	 */
	public class GameScreen extends Screen
	{
		private var balls:Array = [];
		private var paddles:Array = [];
		private var scoreboard:Scoreboard;
		private var powerups:Array = [];
		private var obstacles:Array = [];
		static public const GAME_OVER:String = "game over";
		static public const WON:String = "you win";
		static public const BALL_BOUNCE:String = "ballBounce";
		public function GameScreen() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);			
		}				
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
				for (var i:int = 0; i <1; i++) 
			{
				balls.push(new Ball());
				addChild(balls[i]);
				balls[i].reset();
				
				balls[i].addEventListener(Ball.OUTSIDE_RIGHT, onRightOut);
				balls[i].addEventListener(Ball.OUTSIDE_LEFT, onLeftOut);
				
			}	
			paddles.push(new AI());
			paddles.push(new Player());
			paddles[0].balls = balls;
			for (i = 0; i < 2; i++) 
			{
				
				addChild(paddles[i]);
				paddles[i].y = stage.stageHeight / 2;
			}	
			paddles[0].x = stage.stageWidth - 100;
			
			paddles[1].x = 100;
			
			for (i = 0; i < 4; i++) 
			{
			powerups.push(new Powerup());
			addChild(powerups[i]);
			}
			
			scoreboard = new Scoreboard();
			addChild(scoreboard);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}		
		
		private function loop(e:Event):void 
		{
			checkCollision(paddles);
			var pow:Powerup = checkCollision(powerups) as Powerup;
            if (pow != null)
            {
            removeChild(pow);
            powerups.splice(powerups.indexOf(pow), 1);
            }
		}	
		 private function checkCollision(objects:Array):MovieClip 
  {
   for (var i:int = 0; i < balls.length; i++) 
   {
    for (var j:int = 0; j < objects.length; j++) 
    {
     if (objects[j].hitTestObject(balls[i]))
     {
      if (balls[i].xMove > 0 && balls[i].x < objects[j].x || balls[i].xMove < 0 && balls[i].x > objects[j].x)
      {
       balls[i].xMove *= -1;       
       balls[i].x += objects[j].x - balls[i].x;
       dispatchEvent(new Event(BALL_BOUNCE));
       return objects[j];
       //if (objects[j] is Obstacle || objects[j] is Powerup) objects[j].remove();
      } 
      if (balls[i].yMove > 0 && balls[i].y < objects[j].y || balls[i].yMove < 0 && balls[i].y > objects[j].y)
      {
       balls[i].yMove *= -1;       
       balls[i].y += objects[j].y - balls[i].y;
       dispatchEvent(new Event(BALL_BOUNCE));
       //if (objects[j] is Obstacle || objects[j] is Powerup) objects[j].remove();
       return objects[j];
      }
     }     
    }
   }
   return null;
  }
		private function onLeftOut(e:Event):void 
		{
			var b:Ball = e.target as Ball;
			b.reset();
			
			scoreboard.player2 += 1;
			
			checkScore();
		}		
		private function onRightOut(e:Event):void 
		{
			var b:Ball = e.target as Ball;
			b.reset();
			scoreboard.player1 += 1;
			
			
			checkScore();
		}		
		
		private function checkScore():void 
		{
			if (scoreboard.player2 >= 20)
			{
				destroy();
				dispatchEvent(new Event(GAME_OVER));
			}
		
			if (scoreboard.player1 >= 20)
			{
				destroy();
				dispatchEvent(new Event(WON));
				
			}
			
		}
			
		private function destroy():void
		{
			for (var i:int = 0; i < balls.length; i++) 
			{
				balls[i].destroy();
				removeChild(balls[i]);
			}
			balls.splice(0, balls.length);
		}
	}

}