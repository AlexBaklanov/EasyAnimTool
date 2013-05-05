Strict

Import imp

Global part := New atlasClass

Global curPart:Int, curPartFrame:Int

Global printBtn := New Buttons
Global saveBtn := New Buttons
Global playBtn := New Buttons

Global partX:Float[10000], partY:Float[10000]
Global partRot:Float[10000], partSclX:Float[10000], partSclY:Float[10000]

Global centerPoint:Int = 300

Global animationEdit := New animationEditClass

Class animationEditClass

	Method Init:Void()

		part.Load("anim/img@2.png")

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

		If KeyHit(KEY_TAB) 
			curPart += 1
			If curPart >= part.cnt curPart = 0
		End

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

			If at > 0

				part.Draw(at, partX[atF] + partX[0 + curFrame * 10], partY[atF] + partY[0 + curFrame * 10], partRot[atF], partSclX[atF], partSclY[atF])

			Else
				
				part.Draw(at, partX[atF], partY[atF], partRot[atF], partSclX[atF], partSclY[atF])

			End

			If at = curPart

				'If pivotEditMode

					SetColor(255,0,0)

					DrawLine( part.x[curPart], part.y[curPart], part.x[curPart] + 20, part.y[curPart] )
					DrawLine( part.x[curPart], part.y[curPart], part.x[curPart] , part.y[curPart] - 20 )

				'End

				Yellow()

			End

			If (keyFrameMove[at + curFrame * 10] Or keyFrameRot[at + curFrame * 10] Or keyFrameScl[at + curFrame * 10]) And playMode = False

				SetAlpha(.3)

				DrawOutline( 	part.x[at] - part.pivotX[at] - 1,
								part.y[at] - part.pivotY[at] - 1,
								part.x[at] - part.pivotX[at] + part.w[at] * partSclX[atF] + 1,
								part.y[at] - part.pivotY[at] + part.h[at] * partSclY[atF] + 1)

				SetAlpha(1)

			End

			If at = curPart White()

		End

		DrawLine( centerPoint, centerPoint - 50, centerPoint, centerPoint + 50 )
		DrawLine( centerPoint - 50, centerPoint, centerPoint + 50, centerPoint )

		White()

		SetAlpha(.3)

		DrawOutline( 	part.x[curPart] - part.pivotX[curPart] + 1,
						part.y[curPart] - part.pivotY[curPart] + 1,
						part.x[curPart] - part.pivotX[curPart] + part.w[curPart] * partSclX[curPart + curFrame * 10] - 1,
						part.y[curPart] - part.pivotY[curPart] + part.h[curPart] * partSclY[curPart + curFrame * 10] - 1 )

		SetAlpha(1)

		DrawFrame()

		printBtn.Draw(dw - printBtn.Width, 0)
		saveBtn.Draw(dw - saveBtn.Width, printBtn.Height)

		DrawText( partX[1 + curFrame * 10] - centerPoint, 100, 100 )
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

	If moveMode And pivotEditMode = False And keyFrameMove[curPartFrame] And TouchDown(0)

		partX[curPartFrame] = TouchX() - touchStartX + partXlast[curPartFrame]
		partY[curPartFrame] = TouchY() - touchStartY + partYlast[curPartFrame]

		'If curPart = 0
			'For Local at:Int = 1 Until part.cnt

				'partX[at + curFrame * 10] = TouchX() - touchStartX + partXlast[at + curFrame * 10]
				'partY[at + curFrame * 10] = TouchY() - touchStartY + partYlast[at + curFrame * 10]

			'End
		'End

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

	If rotateMode And pivotEditMode = False And keyFrameRot[curPartFrame] And TouchDown(0)

		partRot[curPartFrame] = TouchX() - touchStartX + partRotLast[curPartFrame]

	End

	If KeyDown(KEY_SHIFT) And KeyHit(KEY_Y)

		partRot[curPartFrame] = 0

	End

End

Global scaleMode:Bool, scaleMode2:Bool
Global partSclLastX:Float[10000], partSclLastY:Float[10000]

Function ScaleHandle:Void()

	If scaleMode And pivotEditMode = False And keyFrameScl[curPartFrame] And TouchDown(0)

		partSclX[curPartFrame] = Float(TouchX() - touchStartX + partSclLastX[curPartFrame]) / 100.0
		partSclY[curPartFrame] = Float(TouchY() - touchStartY + partSclLastY[curPartFrame]) / 100.0

	End

	If scaleMode2 And pivotEditMode = False And keyFrameScl[curPartFrame] And TouchDown(0)

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

			If p > 0

				x += centerPoint
				y += centerPoint

			End

			Local r:Int = partRot[cp + fr * 10]
			Local sx:Int = Int( partSclX[cp + fr * 10] * 100 )
			Local sy:Int = Int( partSclY[cp + fr * 10] * 100 )

			If keyFrameMove[cp + fr * 10] Or keyFrameRot[cp + fr * 10] Or keyFrameScl[cp + fr * 10]

				Local ft:Int = Int(keyFrameMove[cp + fr * 10]) + Int(keyFrameRot[cp + fr * 10]) * 2 + Int(keyFrameScl[cp + fr * 10]) * 4

				Print "p" + p + ",f" + fr + ",m" + ft + ",x" + x/2 +  ",y" + y/2 +  ",r" + r +  ",s" + sx +  ",z" + sy

			End

		End

	Next

End














