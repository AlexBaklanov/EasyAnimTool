Strict

Import imp

Global keyFrameMove:Bool[1000]
Global keyFrameRot:Bool[1000]
Global keyFrameScl:Bool[1000]

Global curFrame:Int

Function InitFrame:Void()

	keyFrameMove[0] = True
	keyFrameMove[940] = True
	keyFrameRot[0] = True
	keyFrameRot[940] = True
	keyFrameScl[0] = True
	keyFrameScl[940] = True

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

	For Local fr:Int = 0 To 940

		If keyFrameMove[fr]

			SetColor(255,0,0)
			DrawCircle( fr + 10, 625, 5 )

		End
		If keyFrameRot[fr]

			SetColor(0,255,0)
			DrawCircle( fr + 10, 630, 5 )

		End
		If keyFrameScl[fr]

			SetColor(0,0,255)
			DrawCircle( fr + 10, 635, 5 )

		End

		For Local at:Int = 0 Until part.cnt

			DrawPoint( partX[at + fr * 10], partY[at + fr * 10] )

		End

	End

	White()

	playBtn.Draw(dw - playBtn.Width, 550 - playBtn.Height)

	DrawText( curFrame, curFrame + 10 - String(curFrame).Length()*8/2, 550 )

	'`DrawText( thirdKey, 200, 200 )
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

		nextKeyM = NextKey(kfMOVE)
		nextKeyR = NextKey(kfROT)
		nextKeyS = NextKey(kfSCL)

		prevKeyM = PrevKey(kfMOVE)
		prevKeyR = PrevKey(kfROT)
		prevKeyS = PrevKey(kfSCL)

	End

	If KeyDown(KEY_CONTROL)

		If KeyHit(KEY_T) keyFrameMove[curFrame] = Not keyFrameMove[curFrame]
		If KeyHit(KEY_Y) keyFrameRot[curFrame] = Not keyFrameRot[curFrame]
		If KeyHit(KEY_H) keyFrameScl[curFrame] = Not keyFrameScl[curFrame]

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

Global nextKeyM:Int, nextKeyR:Int, nextKeyS:Int, prevKeyM:Int, prevKeyR:Int, prevKeyS:Int

Function CalculateInterpolation:Void()

	For Local pt:Int = 0 Until part.cnt

		For Local fr:Int = prevKeyM To nextKeyM

			If keyFrameMove[fr] = False

				Local ptfr:Int = pt + fr * 10

				Local prev10:Int = pt + prevKeyM * 10
				Local next10:Int = pt + nextKeyM * 10
				Local curFrm:Float = Float(fr - prevKeyM)

				partX[ptfr] = 		Tween( partX[prev10], 		partX[next10], 		curFrm, prevKeyM, nextKeyM )
				partY[ptfr] = 		Tween( partY[prev10], 		partY[next10], 		curFrm, prevKeyM, nextKeyM )

			End

		Next

		For Local fr:Int = prevKeyR To nextKeyR

			If keyFrameRot[fr] = False

				Local ptfr:Int = pt + fr * 10

				Local prev10:Int = pt + prevKeyR * 10
				Local next10:Int = pt + nextKeyR * 10
				Local curFrm:Float = Float(fr - prevKeyR)

				partRot[ptfr] = 	Tween( partRot[prev10], 	partRot[next10], 	curFrm, prevKeyR, nextKeyR )

			End

		Next

		For Local fr:Int = prevKeyS To nextKeyS

			If keyFrameScl[fr] = False

				Local ptfr:Int = pt + fr * 10

				Local prev10:Int = pt + prevKeyS * 10
				Local next10:Int = pt + nextKeyS * 10
				Local curFrm:Float = Float(fr - prevKeyS)

				partSclX[ptfr] = 	Tween( partSclX[prev10], 	partSclX[next10], 	curFrm, prevKeyS, nextKeyS )
				partSclY[ptfr] = 	Tween( partSclY[prev10], 	partSclY[next10], 	curFrm, prevKeyS, nextKeyS )

			End

		Next

		'#rem

		partX[pt + 940 * 10] = partX[pt + prevKeyM * 10]
		partY[pt + 940 * 10] = partY[pt + prevKeyM * 10]

		partRot[pt + 940 * 10] = partRot[pt + prevKeyR * 10]

		partSclX[pt + 940 * 10] = partSclX[pt + prevKeyS * 10]
		partSclY[pt + 940 * 10] = partSclY[pt + prevKeyS * 10]

		'#end

	End

End

Const kfMOVE:Int = 0
Const kfROT:Int = 1
Const kfSCL:Int = 2

Function NextKey:Int(kfType:Int)

	For Local fr:Int = curFrame To 940

		If kfType = 0 And keyFrameMove[fr] Return fr
		If kfType = 1 And keyFrameRot[fr] Return fr
		If kfType = 2 And keyFrameScl[fr] Return fr

	End

	Return 0

End

Function PrevKey:Int(kfType:Int)

	For Local fr:Int = curFrame - 1 To 0 Step -1

		If kfType = 0 And keyFrameMove[fr] Return fr
		If kfType = 1 And keyFrameRot[fr] Return fr
		If kfType = 2 And keyFrameScl[fr] Return fr

	End

	Return 0

End



