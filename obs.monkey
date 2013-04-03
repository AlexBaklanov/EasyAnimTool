Strict

Import imp

Global obstacleNext:Int

Function ObstaclesInit:Void()

	obstacleNext = 0

End

Function ObstaclesUpdate:Void()

	GenerateObstacles()

	For Local obst := EachIn obstacle

		obst.Update()

	End

End

Function ObstaclesDraw:Void()

	For Local obst := EachIn obstacle

		obst.Draw()

	End
	
End

Function ObstaclesDeinit:Void()

	For Local obst := EachIn obstacle

		obst.Deinit()

	End
	
End

Function CreateObstacle:Int()

	Local obst := New obstacleClass
	obstacle.AddLast(obst)
	obst.Init( dw, dh * 0.72, Rnd(10 * Retina, 40 * Retina), 50 * Retina )

	Return Rnd(dw, dw * 3)

End

Function GenerateObstacles:Void()

	obstacleNext -= globalSpeed

	If obstacleNext < 0

		obstacleNext = CreateObstacle()

	End

End

Global obstacle := New List<obstacleClass>

Class obstacleClass
	
	Field x:Float, y:Float
	Field length:Int, height:Int

	Method Init:Void(theX:Float, theY:Float, theLength:Int, theHeight:Int)

		x = theX
		y = theY

		length = theLength
		height = -theHeight

	End

	Method Update:Void()

		x -= globalSpeed

		If heroX > x And heroX < x + length And heroY + jump > y + height GameOverMode = True

		If x < -length

			obstacle.Remove(Self)

		End		

	End

	Method Draw:Void()

		Yellow()
		DrawRect( x, y, length, height )
		White()

		'DrawText(y + height,x,y)

	End

	Method Deinit:Void()

		obstacle.Remove(Self)

	End

End