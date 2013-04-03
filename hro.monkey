Strict

Import imp

Global heroX:Float, heroY:Float

Global heroAlive:Bool, heroState:Int
Const heroStateGround:Int = 0
Const heroStateLeaves:Int = 1

Global jump:Float, jumpForce:Float
Global isJump:Bool

Global jumpForceValue:Float
Global jumpForceSlowDown:Float

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    

Function HeroInit:Void()

	heroX = dw * .2
	heroY = dh * .66

	heroAlive = True

	heroState = heroStateGround

	jumpForceValue = 10.0 * Retina
	jumpForceSlowDown = .4 * Retina

End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

Function HeroUpdate:Void()

	Select ControlTouch()

		Case swipeUp

			If jump = 0 StartJump()

		Case touch

			heroState = Not heroState

	End

	'Collision To Obstacle Handle -- look in the obstacles Update Method

	JumpHandle()

End

'=====JUMP====='

Function StartJump:Void()

	isJump = True
	jumpForce = jumpForceValue

End

Function StopJump:Void()

	isJump = False
	jump = 0

End

Function JumpHandle:Void()

	If isJump

		jump -= jumpForce
		jumpForce -= jumpForceSlowDown

		'Hit the Ground'
		If jump > 0 StopJump()

	End

End

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  

Function HeroDraw:Void()

	If heroState = heroStateLeaves SetColor(125,200,75)
	DrawCircle( heroX, heroY + jump, 20 * Retina )
	If heroState = heroStateLeaves White()

End

	'd8888b. d88888b d888888b d8b   db d888888b d888888b 
	'88  `8D 88'       `88'   888o  88   `88'   `~~88~~' 
	'88   88 88ooooo    88    88V8o 88    88       88    
	'88   88 88~~~~~    88    88 V8o88    88       88    
	'88  .8D 88.       .88.   88  V888   .88.      88    
	'Y8888D' Y88888P Y888888P VP   V8P Y888888P    YP    

Function HeroDeinit:Void()

	

End









