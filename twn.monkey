Strict

Import imp

Global Power:Int = 1
Global Amplitude:Int = 1
Global Bounce := 1.70158

Function Tween:Float(b:Float, e:Float, f:Float, p:Float, n:Float)

	Local c:Float = e - b
	Local d:Float = n - p
	Local t:Float = f' - p

	Return CurTween(b,c,t,d)

End

Function LinearTween:Float( b:Float, c:Float, t:Float, d:Float )

	Return c * t / d + b

End

Function EaseInOutQuadTween:Float( b:Float, c:Float, t:Float, d:Float )

	t /= d/2
	If (t < 1) Return c/2*t*t + b
	t -= 1
	Return -c/2 * (t*(t-2) - 1) + b

End

Function EaseInOutCubicTween:Float( b:Float, c:Float, t:Float, d:Float )

		t /= d/2
		If (t < 1) Return c/2*t*t*t + b
		t -= 2
		Return c/2*(t*t*t + 2) + b

End

Function CurTween:Float( b:Float, c:Float, t:Float, d:Float )

		t /= d/2
		If (t < 1) Return c/2*t*t + b
		t -= 1
		Return -c/2 * (t*(t-2) - 1) + b

End












