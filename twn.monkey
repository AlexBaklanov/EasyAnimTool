Strict

Import imp

Global Power:Int = 1
Global Amplitude:Int = 1
Global Bounce := 1.70158

Function Tween:Float(b:Float, e:Float, f:Float, p:Float, n:Float)

	Local c:Float = e - b
	Local d:Float = n - p
	Local t:Float = f

	Return CurTween(b,c,t,d)

End

Function Interpolate:Float( p0:Float, p1:Float, p2:Float, pc:Float )

	Local curPercent:Float  = ( pc - p0 ) / ( p1 - p0 )
	'Local nextPercent:Float = p1 + ( p2 - p1 ) * curPercent

	Local bz0:Float = ( p1 - p0 ) * curPercent
	Local bz1:Float = ( p2 - p1 ) * curPercent

	Return (bz1 - bz0) * curPercent

	'Return (1 - t) * (1 - t) * p0 + 2 * (1 - t) * t * p1 + t * t * p2

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
	If (t < 1) Return c/2*t*t*t + b
	t -= 2
	Return c/2*(t*t*t + 2) + b

End








