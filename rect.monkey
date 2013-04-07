Strict

Import imp

Function rectanglesHandle:Void()

	If rectCurrentNumber < 10 And createRectBtn.Pressed()

		CreateRect(rectCurrentNumber)
		rectCurrentNumber += 1

	End

	If createAtlasBtn.Pressed()

		For Local rct := EachIn rectangle

			Local pX:Int = rct.pivotX - rct.x
			Local pY:Int = rct.pivotY - rct.y

			Print "x" + rct.x/2 + "," + "y" + rct.y/2 + "," + "w" + (rct.x + rct.w)/2 + "," + "h" + (rct.y + rct.h)/2 + "," + "i" + pX/2 + "," + "j" + pY/2

		End

	End

	For Local rct := EachIn rectangle

		rct.Update()

		If TouchDown(0)

			If rct.canEdit1

				rct.w = TouchX() - rct.x
				rct.h = TouchY() - rct.y

			End

			If rct.canEdit2

				rct.x = TouchX()
				rct.y = TouchY()

			End

		End

	End

End

Global rectangle := New List<rectangleClass>

Class rectangleClass

	Field x:Int, y:Int
	Field w:Int, h:Int
	Field num:Int
	Field editX:Int, editY:Int, editRadius:Int = 5, canEdit1:Bool
	Field editW:Int, editH:Int, canEdit2:Bool
	Field pivotX:Int, pivotY:Int

	'd888888b d8b   db d888888b d888888b 
	'  `88'   888o  88   `88'   `~~88~~' 
	'   88    88V8o 88    88       88    
	'   88    88 V8o88    88       88    
	'  .88.   88  V888   .88.      88    
	'Y888888P VP   V8P Y888888P    YP    
	
	Method Init:Void(theNum:Int)
		
		x = dw * Rnd(.1, .35)
		y = dh * Rnd(.1, .35)
		w = dw * Rnd(.4, .8)
		h = dh * Rnd(.4, .8)

		num = theNum

	End

	'db    db d8888b. d8888b.  .d8b.  d888888b d88888b 
	'88    88 88  `8D 88  `8D d8' `8b `~~88~~' 88'     
	'88    88 88oodD' 88   88 88ooo88    88    88ooooo 
	'88    88 88~~~   88   88 88~~~88    88    88~~~~~ 
	'88b  d88 88      88  .8D 88   88    88    88.     
	'~Y8888P' 88      Y8888D' YP   YP    YP    Y88888P

	Method Update:Void()

		editX = x
		editY = y
		editW = x + w
		editH = y + h

		If TouchDown(0) = False

			canEdit1 = False
			canEdit2 = False

		End

		If TouchX() > editW - editRadius

			If TouchX() < editW + editRadius

				If TouchY() > editH - editRadius

					If TouchY() < editH + editRadius

						canEdit1 = True
						
					End

				End
				
			End

		End

		If TouchX() > editX - editRadius

			If TouchX() < editX + editRadius

				If TouchY() > editY - editRadius

					If TouchY() < editY + editRadius

						canEdit2 = True
						
					End

				End
				
			End

		End

	End

	'd8888b. d8888b.  .d8b.  db   d8b   db 
	'88  `8D 88  `8D d8' `8b 88   I8I   88 
	'88   88 88oobY' 88ooo88 88   I8I   88 
	'88   88 88`8b   88~~~88 Y8   I8I   88 
	'88  .8D 88 `88. 88   88 `8b d8'8b d8' 
	'Y8888D' 88   YD YP   YP  `8b8' `8d8'  

	Method Draw:Void()

		Select num

			Case 1

				Yellow()

			Case 2

				SetColor(255,0,0)

			Case 3

				SetColor(0,255,0)

			Case 4

				SetColor(255,255,0)

			Case 5

				SetColor(0,255,255)

			Case 6

				SetColor(255,0,255)

			Case 7

				SetColor(0,0,255)

			Case 8

				SetColor(255,255,255)

			Case 9

				SetColor(128,255,0)

		End

		DrawOutline( x, y, x + w, y + h)

		DrawLine( pivotX, pivotY, pivotX + 20, 	pivotY 		)
		DrawLine( pivotX, pivotY, pivotX , 		pivotY - 20 	)

		If canEdit1 DrawCircle(editW, editH, editRadius)
		If canEdit2 DrawCircle(editX, editY, editRadius)

		White()

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

Function CreateRect:Void(theNum:Int)

	Local rect:rectangleClass = New rectangleClass
	rect.Init(theNum)
	rectangle.AddLast(rect)

End

Function DrawOutline:Void( theX:Int, theY:Int, theW:Int, theH:Int )

	DrawLine( theX, 	theY, 	theW, 	theY )
	DrawLine( theW, 	theY, 	theW, 	theH )
	DrawLine( theX, 	theY, 	theX, 	theH )
	DrawLine( theX, 	theH, 	theW, 	theH )

End






