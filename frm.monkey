Strict

Import imp

Global keyFrame:Bool[1000]

Global curFrame:Int

Function InitFrame:Void()

	keyFrame[0] = True
	keyFrame[940] = True

End

Function DrawFrame:Void()

	DrawCircle( 10, 630, 10 )
	DrawCircle( 950, 630, 10 )
	DrawLine( 10, 630, 950, 630 )

	Yellow()
	DrawLine( curFrame + 10, 630, curFrame + 10, 600 )

	For Local fr:Int = 0 To 940

		If keyFrame[fr] = True

			DrawCircle( fr + 10, 630, 5 )

		End

	End

	White()

	playBtn.Draw(dw - playBtn.Width, 550 - playBtn.Height)

	DrawText( curFrame, curFrame + 10 - String(curFrame).Length()*8/2, 550 )

	'DrawText( prevKey, 200, 200 )
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

		nextKey = NextKey()
		prevKey = PrevKey()

	End

	If KeyHit(KEY_F)

		keyFrame[curFrame] = Not keyFrame[curFrame]

		RememberLast()

	End

	If playBtn.Pressed()

		playMode = Not playMode

	End

	If playMode

		curFrame += 1
		If curFrame > 940 curFrame = 0

	End

End

Global nextKey:Int, prevKey:Int

Function CalculateInterpolation:Void()

	For Local pt:Int = 0 Until part.cnt

		For Local fr:Int = prevKey To nextKey

			If keyFrame[fr] = False

				Local prev10:Int = pt + prevKey * 10
				Local next10:Int = pt + nextKey * 10

				Local ptfr:Int = pt + fr * 10

				'Local duration:Float = Float(nextKey - prevKey)
				Local curFrm:Float = Float(fr - prevKey)

				partX[ptfr] = Tween( partX[prev10], partX[next10], curFrm, prevKey, nextKey  )
				partY[ptfr] = Tween( partY[prev10], partY[next10], curFrm, prevKey, nextKey  )

				partRot[ptfr] = Tween(partRot[prev10], partRot[next10], curFrm, prevKey, nextKey  )

				partSclX[ptfr] = Tween(partSclX[prev10], partSclX[next10], curFrm, prevKey, nextKey  )
				partSclY[ptfr] = Tween(partSclY[prev10], partSclY[next10], curFrm, prevKey, nextKey  )

			ElseIf fr = 940

				partX[pt + fr * 10] = partX[pt + prevKey * 10]
				partY[pt + fr * 10] = partY[pt + prevKey * 10]

				partRot[pt + fr * 10] = partRot[pt + prevKey * 10]

				partSclX[pt + fr * 10] = partSclX[pt + prevKey * 10]
				partSclY[pt + fr * 10] = partSclY[pt + prevKey * 10]

			End

		End

	End

End

Function NextKey:Int()

	For Local fr:Int = curFrame To 940

		If keyFrame[fr]

			Return fr

		End

	End

	Return 0

End

Function PrevKey:Int()

	For Local fr:Int = curFrame - 1 To 0 Step -1

		If keyFrame[fr]

			Return fr

		End

	End

	Return 0

End



