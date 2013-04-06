Strict

Import imp

Global part := New atlasClass

Global curPart:Int, curPartFrame:Int

Global printBtn := New Buttons
Global saveBtn := New Buttons
Global playBtn := New Buttons

Global partX:Float[10000], partY:Float[10000]
Global partRot:Int[10000], partSclX:Float[10000], partSclY:Float[10000]

Global centerPoint:Int = 300

Global animationEdit := New animationEditClass

Class animationEditClass

	Method Init:Void()

		part.Load("anim/img.png")

		printBtn.Init("Print")
		saveBtn.Init("Save")
		playBtn.Init(">")

		moveMode = True

		LoadGame()

		InitFrame()

	End

	Method Update:String()

		If KeyHit(KEY_B) bgr = Not bgr

		If KeyHit(KEY_0) ResetGame()

		curPartFrame = curPart + curFrame * 10

		CalculateInterpolation()

		If TouchY() < 550

			SelectHandle()
			MoveHandle()
			MovePivotHandle()
			RotateHandle()
			ScaleHandle()

			ChooseMode()

		End

		UpdateFrame()

		If printBtn.Pressed()

			PrintResult()

		End

		If saveBtn.Pressed()

			SaveGame()

		End

		Return animEdit

	End

	Method Draw:Void()

		If bgr DrawImage(bgr1Img, 0, 0) Else DrawImage(bgr2Img, 0, 0)

		If moveMode DrawText("move", 0, 300)
		If rotateMode DrawText("rotate", 0, 300)
		If scaleMode DrawText("scale", 0, 300)
		If scaleMode2 DrawText("scale fixed", 0, 300)

		For Local at:Int = 0 Until part.cnt

			Local atF:Int = at + curFrame * 10

			'If partSclX[atF] = 0.0 partSclX[atF] = 1.0
			'If partSclY[atF] = 0.0 partSclY[atF] = 1.0

			Local prev10:Int = at + prevKey * 10
			Local next10:Int = at + nextKey * 10
			Local third10:Int = at + thirdKey * 10

			Local bzX:Float = partX[atF]'Interpolate( partX[prev10], partX[next10], partX[third10], partX[atF] )
			Local bzY:Float = partY[atF]'Interpolate( partY[prev10], partY[next10], partY[third10], partY[atF] )

			part.Draw(at, bzX, bzY, partRot[atF], partSclX[atF], partSclY[atF])

			If at = curPart

				'If pivotEditMode

					SetColor(255,0,0)

					DrawLine( part.x[curPart], part.y[curPart], part.x[curPart] + 20, part.y[curPart] )
					DrawLine( part.x[curPart], part.y[curPart], part.x[curPart] , part.y[curPart] - 20 )

				'End

				Yellow()

			End

			If keyFrame[curFrame] And playMode = False

				SetAlpha(.3)

				DrawOutline( 	part.x[at] - part.pivotX[at],
								part.y[at] - part.pivotY[at],
								part.x[at] - part.pivotX[at] + part.w[at] * partSclX[atF],
								part.y[at] - part.pivotY[at] + part.h[at] * partSclY[atF] )

				SetAlpha(1)

			End

			If at = curPart White()

		End

		DrawLine( centerPoint, centerPoint - 50, centerPoint, centerPoint + 50 )
		DrawLine( centerPoint - 50, centerPoint, centerPoint + 50, centerPoint )

		DrawFrame()

		printBtn.Draw(dw - printBtn.Width, 0)
		saveBtn.Draw(dw - saveBtn.Width, printBtn.Height)

		'DrawText( mainState[mainState.Length() - 100..], 100, 100 )
		'DrawText( paramscnt, 200, 200 )

	End

	Method Deinit:Void()

		part.Deinit()

		printBtn.Deinit()
		saveBtn.Deinit()

	End

End

Function ChooseMode:Void()

	If KeyHit(KEY_S)
		ResetOtherModes()
		selectMode = True
	End

	If KeyHit(KEY_T)
		ResetOtherModes()
		moveMode = True
	End
	
	If KeyHit(KEY_Y)
		ResetOtherModes()
		rotateMode = True
	End

	If KeyHit(KEY_H)
		ResetOtherModes()
		scaleMode = True
	End

	If KeyHit(KEY_J)
		ResetOtherModes()
		scaleMode2 = True
	End

End

Function ResetOtherModes:Void()

	moveMode = False
	pivotEditMode = False
	rotateMode = False
	scaleMode = False
	scaleMode2 = False

End

Global selectMode:Bool

Function SelectHandle:Void()

	If TouchHit(0)

		SaveGame()

		touchStartX = TouchX()
		touchStartY = TouchY()

		RememberLast()

		If ClickedInsideImage()

			Return

		End

	End

End

Function RememberLast:Void()

	For Local pt:Int = 0 Until part.cnt

		Local _pt:Int = pt + curFrame * 10
		
		partXlast[_pt] = partX[_pt]
		partYlast[_pt] = partY[_pt]

		partRotLast[_pt] = partRot[_pt]

		partSclLastX[_pt] = partSclX[_pt] * 100.0
		partSclLastY[_pt] = partSclY[_pt] * 100.0

	Next

End

Function ClickedInsideImage:Bool()

	For Local at:Int = 0 To part.cnt

		Local atF:Int = at + curFrame * 10

		If TouchX() > part.x[at] - part.pivotX[at] And TouchX() < part.x[at] + part.w[at] * partSclX[at] - part.pivotX[at]

			If TouchY() > part.y[at] - part.pivotY[at] And TouchY() < part.y[at] + part.h[at] * partSclY[at] - part.pivotY[at]

				curPart = part.num[at]
				Return True

			End

		End

	End

	Return False

End

Global touchStartX:Int, touchStartY:Int
Global partXlast:Int[10000], partYlast:Int[10000]
Global moveMode:Bool

Function MoveHandle:Void()

	If moveMode And pivotEditMode = False And keyFrame[curFrame] And TouchDown(0)

		partX[curPartFrame] = TouchX() - touchStartX + partXlast[curPartFrame]
		partY[curPartFrame] = TouchY() - touchStartY + partYlast[curPartFrame]

	End

	If KeyHit(KEY_UP) 		partY[curPartFrame] -= 1
	If KeyHit(KEY_DOWN) 	partY[curPartFrame] += 1
	If KeyHit(KEY_LEFT) 	partX[curPartFrame] -= 1
	If KeyHit(KEY_RIGHT) 	partX[curPartFrame] += 1

End

Global rotateMode:Bool
Global partRotLast:Int[10000]
Global partRotAddX:Int[10000], partRotAddY:Int[10000]

Function RotateHandle:Void()

	If rotateMode And pivotEditMode = False And keyFrame[curFrame] And TouchDown(0)

		partRot[curPartFrame] = TouchX() - touchStartX + partRotLast[curPartFrame]

	End

	If KeyDown(KEY_SHIFT) And KeyHit(KEY_Y)

		partRot[curPartFrame] = 0

	End

End

Global scaleMode:Bool, scaleMode2:Bool
Global partSclLastX:Float[10000], partSclLastY:Float[10000]

Function ScaleHandle:Void()

	If scaleMode And pivotEditMode = False And keyFrame[curFrame] And TouchDown(0)

		partSclX[curPartFrame] = Float(TouchX() - touchStartX + partSclLastX[curPartFrame]) / 100.0
		partSclY[curPartFrame] = Float(TouchY() - touchStartY + partSclLastY[curPartFrame]) / 100.0

	End

	If scaleMode2 And pivotEditMode = False And keyFrame[curFrame] And TouchDown(0)

		partSclX[curPartFrame] = Float(TouchX() - touchStartX + partSclLastX[curPartFrame]) / 100.0
		partSclY[curPartFrame] = partSclX[curPartFrame]

	End

	If KeyDown(KEY_SHIFT) And KeyHit(KEY_H)

		partSclX[curPartFrame] = 1.0
		partSclY[curPartFrame] = 1.0

	End

End

Function PrintResult:Void()

	For Local fr:Int = 0 Until 940

		For Local cp:Int = 0 Until part.cnt

			Local p:Int = cp
			Local x:Int = partX[cp + fr * 10] - centerPoint
			Local y:Int = partY[cp + fr * 10] - centerPoint
			Local r:Int = partRot[cp + fr * 10]
			Local sx:Int = Int( partSclX[cp + fr * 10] * 100 )
			Local sy:Int = Int( partSclY[cp + fr * 10] * 100 )

			If keyFrame[fr]

				Print "p" + p + ",f" + fr + ",x" + x +  ",y" + y +  ",r" + r +  ",s" + sx +  ",z" + sy

			End

		End

	Next

End














