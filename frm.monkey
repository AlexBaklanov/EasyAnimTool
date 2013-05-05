Strict

Import imp

Global keyFrameMove:Bool[10000]
Global keyFrameRot:Bool[10000]
Global keyFrameScl:Bool[10000]

Global curFrame:Int

Function InitFrame:Void()

	For Local pt:Int = 0 Until part.cnt

		keyFrameMove[pt + 0] = True
		keyFrameMove[pt + 9400] = True
		keyFrameRot[pt + 0] = True
		keyFrameRot[pt + 9400] = True
		keyFrameScl[pt + 0] = True
		keyFrameScl[pt + 9400] = True

	Next

End

Function DrawFrame:Void()

	DrawCircle( 10, 630, 10 )
	DrawCircle( 950, 630, 10 )
	DrawLine( 10, 630, 950, 630 )

	Yellow()
	DrawLine( curFrame + 10, 630, curFrame + 10, 600 )

	'Local curPercent:Float  = ( partX[curFrame * 10] - partX[prevKey * 10] ) / ( partX[nextKey * 10] - partX[prevKey * 10] )

	'Local nextPercentX:Float = partX[nextKey * 10] + ( partX[thirdKey * 10] - partX[nextKey * 10] ) * curPercent
	'Local nextPercentY:Float = partY[nextKey * 10] + ( partY[thirdKey * 10] - partY[nextKey * 10] ) * curPercent

	'DrawLine( partX[curFrame * 10], partY[curFrame * 10], nextPercentX, nextPercentY )
	'DrawCircle( partX[curFrame * 10] + (nextPercentX - partX[curFrame * 10]) 
	'* curPercent, partY[curFrame * 10] + (nextPercentY - partY[curFrame * 10]) * curPercent, 10 )

	'DrawCircle( nextPercentX, nextPercentY, 10 )

	For Local pt:Int = 0 Until part.cnt

		For Local fr:Int = 0 To 940

			If keyFrameMove[pt + fr * 10]

				SetColor(255,0,0)
				If pt = curPart DrawCircle( fr + 10, 625, 5 )

			End
			If keyFrameRot[pt + fr * 10]

				SetColor(0,255,0)
				If pt = curPart DrawCircle( fr + 10, 630, 5 )

			End
			If keyFrameScl[pt + fr * 10]

				SetColor(0,0,255)
				If pt = curPart DrawCircle( fr + 10, 635, 5 )

			End

			'For Local at:Int = 0 Until part.cnt

				DrawPoint( partX[pt + fr * 10], partY[pt + fr * 10] )

			'End

		End

	End

	White()

	playBtn.Draw(dw - playBtn.Width, 550 - playBtn.Height)

	DrawText( curFrame, curFrame + 10 - String(curFrame).Length()*8/2, 550 )

	'DrawText( nextKeyM, 200, 200 )
	'DrawText( nextKey, 200, 250 )

	'DrawText( partX[curPart + curFrame * 10], 260, 200 )
	'DrawText( partY[curPart + curFrame * 10], 260, 250 )

	'DrawText( partX[curPartFrame], 230, 230 )

	'DrawText( partX[curPart + prevKey * 10] + "+ (" + partX[curPart + nextKey * 10] + 
	'" - " + partX[curPart + prevKey * 10] + ") / (" + nextKey + " - " + prevKey + ") * " + curFrame, 300, 200 )

End

Global playMode:Bool

Function UpdateFrame:Void()

	If TouchY() > 550 And TouchDown(0)

		curFrame = TouchX() - 10

		If curFrame < 0 curFrame = 0
		If curFrame > 940 curFrame = 940

		For Local pt:Int = 0 Until part.cnt

			nextKeyM[pt] = NextKey(kfMOVE, pt)
			nextKeyR[pt] = NextKey(kfROT, pt)
			nextKeyS[pt] = NextKey(kfSCL, pt)

			prevKeyM[pt] = PrevKey(kfMOVE, pt)
			prevKeyR[pt] = PrevKey(kfROT, pt)
			prevKeyS[pt] = PrevKey(kfSCL, pt)

		Next

	End

	If KeyDown(KEY_CONTROL)

		If KeyHit(KEY_T)
			keyFrameMove[curPart + curFrame * 10] 	= Not keyFrameMove[curPart + curFrame * 10]
			
			'If curPart = 0

			''	For Local at:Int = 1 Until part.cnt

			''		keyFrameMove[at + curFrame * 10] = Not keyFrameMove[at + curFrame * 10]

			''	End
			'End

		End
		If KeyHit(KEY_Y) keyFrameRot[curPart + curFrame * 10] 	= Not keyFrameRot[curPart + curFrame * 10]
		If KeyHit(KEY_H) keyFrameScl[curPart + curFrame * 10] 	= Not keyFrameScl[curPart + curFrame * 10]

		RememberLast()

	End

	If playBtn.Pressed()

		playMode = Not playMode
		If playMode curFrame = 0

	End

	If playMode

		curFrame += 1
		If curFrame > 940 curFrame = 0

	End

End

Global nextKeyM:Float[30], nextKeyR:Float[30], nextKeyS:Float[30], prevKeyM:Float[30], prevKeyR:Float[30], prevKeyS:Float[30]

Function CalculateInterpolation:Void()

	For Local pt:Int = 0 Until part.cnt

		For Local fr:Int = prevKeyM[pt] To nextKeyM[pt]

			If keyFrameMove[pt + fr * 10] = False

				Local ptfr:Int = pt + fr * 10

				Local prev10:Int = pt + prevKeyM[pt] * 10
				Local next10:Int = pt + nextKeyM[pt] * 10
				Local curFrm:Float = Float( fr - prevKeyM[pt] )

				partX[ptfr] = 		Tween( partX[prev10], partX[next10], curFrm, prevKeyM[pt], nextKeyM[pt] )
				partY[ptfr] = 		Tween( partY[prev10], partY[next10], curFrm, prevKeyM[pt], nextKeyM[pt] )

			End

		Next

		For Local fr:Int = prevKeyR[pt] To nextKeyR[pt]

			If keyFrameRot[pt + fr * 10] = False

				Local ptfr:Int = pt + fr * 10

				Local prev10:Int = pt + prevKeyR[pt] * 10
				Local next10:Int = pt + nextKeyR[pt] * 10
				Local curFrm:Float = Float( fr - prevKeyR[pt] )

				partRot[ptfr] = 	Tween( partRot[prev10], partRot[next10], curFrm, prevKeyR[pt], nextKeyR[pt] )

			End

		Next

		For Local fr:Int = prevKeyS[pt] To nextKeyS[pt]

			If keyFrameScl[pt + fr * 10] = False

				Local ptfr:Int = pt + fr * 10

				Local prev10:Int = pt + prevKeyS[pt] * 10
				Local next10:Int = pt + nextKeyS[pt] * 10
				Local curFrm:Float = Float( fr - prevKeyS[pt] )

				partSclX[ptfr] = 	Tween( partSclX[prev10], partSclX[next10], curFrm, prevKeyS[pt], nextKeyS[pt] )
				partSclY[ptfr] = 	Tween( partSclY[prev10], partSclY[next10], curFrm, prevKeyS[pt], nextKeyS[pt] )

			End

		Next

		'#rem

		partX[pt + 940 * 10] = partX[pt + prevKeyM[pt] * 10]
		partY[pt + 940 * 10] = partY[pt + prevKeyM[pt] * 10]

		partRot[pt + 940 * 10] = partRot[pt + prevKeyR[pt] * 10]

		partSclX[pt + 940 * 10] = partSclX[pt + prevKeyS[pt] * 10]
		partSclY[pt + 940 * 10] = partSclY[pt + prevKeyS[pt] * 10]

		'#end

	End

End

Const kfMOVE:Int = 0
Const kfROT:Int = 1
Const kfSCL:Int = 2

Function NextKey:Float(kfType:Int, thePart:Int)

	';For Local pt:Int = 0 Until part.cnt

		For Local fr:Int = curFrame To 940

			If kfType = 0 And keyFrameMove[thePart + fr * 10] Return fr
			If kfType = 1 And keyFrameRot[thePart + fr * 10] Return fr
			If kfType = 2 And keyFrameScl[thePart + fr * 10] Return fr

		End

	'Next

	Return 0

End

Function PrevKey:Float(kfType:Int, thePart:Int)

	'For Local pt:Int = 0 Until part.cnt

		For Local fr:Int = curFrame - 1 To 0 Step -1

			If kfType = 0 And keyFrameMove[thePart + fr * 10] Return fr
			If kfType = 1 And keyFrameRot[thePart + fr * 10] Return fr
			If kfType = 2 And keyFrameScl[thePart + fr * 10] Return fr

		End

	'Next

	Return 0

End



