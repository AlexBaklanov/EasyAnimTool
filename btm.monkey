Strict

Import imp

Const bottomStateGround:Int = 0 'white'
Const bottomStateLeaves:Int = 1 'green'

Global bottomStateToCreate:Int
Global bottomState:Int
Global bottomNext:Float
Global bottomLength:Int

Global bottomNewX:Float
Global bottomNewY:Float

Function BottomInit:Void()

	bottomStateToCreate = bottomStateGround
	bottomState = bottomStateToCreate

	bottomNewX = 0

	bottomNext = CreateBottom() - dw

End

Function BottomUpdate:Void()

	GenerateBottom()

	For Local bot := EachIn bottom

		bot.Update()

	End

End

Function BottomDraw:Void()

	For Local bot := EachIn bottom

		bot.Draw()

	End
	
End

Function BottomDeinit:Void()

	For Local bot := EachIn bottom

		bot.Deinit()

	End
	
End

Function CreateBottom:Int()

	bottomLength = Rnd(dw, dw * 3)

	'if this is the first time do not change the state'
	If bottomNewX > 0 bottomStateToCreate = Not bottomStateToCreate

	Local bot := New bottomClass
	bottom.AddLast(bot)
	bot.Init( bottomNewX, dh * 0.72, bottomStateToCreate, bottomLength )

	Return bottomLength

End

Function GenerateBottom:Void()

	bottomNext -= globalSpeed

	If bottomNext < 0

		bottomNewX = dw

		bottomNext = CreateBottom()

	End

End

Global bottom := New List<bottomClass>

Class bottomClass
	
	Field x:Float, y:Float
	Field state:Int
	Field length:Int

	Method Init:Void(theX:Float, theY:Float, theState:Int, theLength:Int)

		x = theX
		y = theY

		state = theState

		length = theLength

	End

	Method Update:Void()

		x -= globalSpeed

		If x > 0 And x < heroX And bottomState <> bottomStateToCreate bottomState = Not bottomState

		If x < -length

			bottom.Remove(Self)

		End		

	End

	Method Draw:Void()

		If state = bottomStateLeaves SetColor(125,200,75)
		DrawRect( x, y, length, 40 * Retina )
		If state = bottomStateLeaves White()

	End

	Method Deinit:Void()

		bottom.Remove(Self)

	End

End


