Strict

Import imp

Global mainImage:Image

Global bgr1Img:Image
Global bgr2Img:Image
Global bgr:Int = 1

Global createRectBtn := New Buttons
Global createAtlasBtn := New Buttons
Global animateBtn := New Buttons

Global imageEdit := New imageEditClass

Global rectCurrentNumber:Int

Class imageEditClass

	Field x:Float, y:Float, rot:Float, sclX:Float, sclY:Float

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    
	
	Method Init:Void()

		mainImage = LoadImage("anim/img@2.png")
		bgr1Img = LoadImage("bgr1.png")
		bgr2Img = LoadImage("bgr2.png")

		createRectBtn.Init("New Rect")
		createAtlasBtn.Init("Create")

		animateBtn.Init("Animate")

		x = 0
		y = 0
		rot = 0
		sclX = 1.0
		sclY = 1.0

		

	End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

	Method Update:String()

		If KeyHit(KEY_B) bgr = Not bgr

		If KeyHit(KEY_P)
			pivotEditMode = Not pivotEditMode
		End

		MovePivotHandle()

		If pivotEditMode = False

			rectanglesHandle()

			If animateBtn.Pressed()

				animationEdit.Init()
				Return animEdit

			End

		End

		Return imgEdit

	End



	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  


	Method Draw:Void()

		If bgr DrawImage(bgr1Img, 0, 0) Else DrawImage(bgr2Img, 0, 0)

		DrawImage (mainImage, x, y, 0, sclX, sclY)

		createRectBtn.Draw( dw - createRectBtn.Width, 0 )
		createAtlasBtn.Draw( dw - createAtlasBtn.Width, createRectBtn.Height )
		animateBtn.Draw( dw - animateBtn.Width, createAtlasBtn.Height * 2 )

		For Local rct := EachIn rectangle

			rct.Draw()

		End 

	End

	'd8888b. d88888b .d8888. d88888b d888888b 
	'88  `8D 88'     88'  YP 88'     `~~88~~' 
	'88oobY' 88ooooo `8bo.   88ooooo    88    
	'88`8b   88~~~~~   `Y8b. 88~~~~~    88    
	'88 `88. 88.     db   8D 88.        88    
	'88   YD Y88888P `8888Y' Y88888P    YP    


	Method Reset:Void()

		

	End

	'd8888b. d88888b d888888b d8b   db d888888b d888888b 
	'88  `8D 88'       `88'   888o  88   `88'   `~~88~~' 
	'88   88 88ooooo    88    88V8o 88    88       88    
	'88   88 88~~~~~    88    88 V8o88    88       88    
	'88  .8D 88.       .88.   88  V888   .88.      88    
	'Y8888D' Y88888P Y888888P VP   V8P Y888888P    YP    

	Method Deinit:Void()
		
		
		
	End

End


Global pivotEditMode:Bool
Global curRect:Int

Function MovePivotHandle:Void()

	If pivotEditMode And TouchHit(0) 

		MakePivot()

	End

End

Function MakePivot:Void()

	For Local rct := EachIn rectangle

		If TouchX() > rct.x And TouchX() < rct.x + rct.w

			If TouchY() > rct.y And TouchY() < rct.y + rct.h

				rct.pivotX = TouchX()
				rct.pivotY = TouchY()

			End

		End

	End

End






