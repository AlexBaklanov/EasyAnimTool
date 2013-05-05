Strict

Import imp

Global mainState:String
Global paramLine:String[600000]

Function SaveGame:Void()

	paramsCount = 0

	mainState = ""

	For Local pl:Int = 0 Until 10000

		addParam( Int(partX[pl]) )

	Next

	For Local pl:Int = 0 Until 10000

		addParam( Int(partY[pl]) )

	End

	For Local pl:Int = 0 Until 10000

		addParam( Int(partRot[pl]) )

	Next

	For Local pl:Int = 0 Until 10000

		addParam( Int(partSclX[pl] * 100) )

	Next

	For Local pl:Int = 0 Until 10000

		addParam( Int(partSclY[pl] * 100) )

	Next

	For Local pl:Int = 0 Until 10000

		addParam( Int(keyFrameMove[pl]) )

	Next

	For Local pl:Int = 0 Until 10000

		addParam( Int(keyFrameRot[pl]) )

	Next

	For Local pl:Int = 0 Until 10000

		addParam( Int(keyFrameScl[pl]) )

	Next

	SaveState(mainState)

End


Function LoadGame:Void()

	mainState = LoadState()

	If mainState
		
		Local pn:Int = 0

		For Local line$=Eachin mainState.Split( "," )
			
			paramLine[pn] = line
			pn += 1
			
		Next

		



		For Local pl:Int = 0 Until 10000

			partX[pl] =						Int(paramLine[pl])

		Next

		For Local pl:Int = 10000 Until 20000

			partY[pl - 10000] =				Int(paramLine[pl])

		Next

		For Local pl:Int = 20000 Until 30000

			partRot[pl - 20000] =			Int(paramLine[pl])

		Next

		For Local pl:Int = 30000 Until 40000

			partSclX[pl - 30000] =			Float(paramLine[pl]) / 100.0

		Next

		For Local pl:Int = 40000 Until 50000

			partSclY[pl - 40000] =			Float(paramLine[pl]) / 100.0

		Next

		For Local pl:Int = 50000 Until 60000

			keyFrameMove[pl - 50000] = False
			If paramLine[pl] = 1 keyFrameMove[pl - 50000] = True

		Next

		For Local pl:Int = 60000 Until 70000

			keyFrameRot[pl - 60000] = False
			If paramLine[pl] = 1 keyFrameRot[pl - 60000] = True

		Next

		For Local pl:Int = 70000 Until 80000

			keyFrameScl[pl - 70000] = False
			If paramLine[pl] = 1 keyFrameScl[pl - 70000] = True

		Next
		
	Else
		
		ResetGame()
		
	End

End


Function ResetGame:Void()

	For Local pl:Int = 0 Until 10000

		partX[pl] =						0

	Next

	For Local pl:Int = 10000 Until 20000

		partY[pl - 10000] =				0

	Next

	For Local pl:Int = 20000 Until 30000

		partRot[pl - 20000] =			0

	Next

	For Local pl:Int = 30000 Until 40000

		partSclX[pl - 30000] =			1.0

	Next

	For Local pl:Int = 40000 Until 50000

		partSclY[pl - 40000] =			1.0

	Next

	For Local pl:Int = 50000 Until 60000

		keyFrameMove[pl - 50000] = 			False
		keyFrameRot[pl - 50000] = 			False
		keyFrameScl[pl - 50000] = 			False

	Next

	For Local pt:Int = 0 Until part.cnt

		keyFrameMove[pt + 0] = True
		keyFrameMove[pt + 9400] = True
		keyFrameRot[pt + 0] = True
		keyFrameRot[pt + 9400] = True
		keyFrameScl[pt + 0] = True
		keyFrameScl[pt + 9400] = True

	Next

End

Global paramsCount:Int

Function addParam:Void(param:Int)

	paramsCount += 1
	
	Local strParam:String = String(param)
	strParam = strParam.Trim()
	
	mainState += strParam + ","

End


