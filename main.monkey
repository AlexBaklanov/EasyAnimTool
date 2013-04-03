Import imp

Global coords = False

Class GameGW Extends App
		
	Field JustChanged:Bool
	Field WaitALittle:Int
	Field ModeOld:String
	
	Method OnCreate()
		
		SetUpdateRate 60

		MainInit()
		
		
	End
	
	Method OnUpdate()
		
		Select Mode
			
			Case imgEdit
				
				Mode = imageEdit.Update()
				
			Case animEdit
				
				Mode = animationEdit.Update()
				
		End
		
		If Mode <> ModeOld And Mode <> imgEdit
			WaitALittle = 20
			ModeOld = Mode
		End
		
		ModeOld = Mode
		
	End
	
	Method OnRender()
	
		Select Mode
		
			Case imgEdit
				
				imageEdit.Draw()
				
			Case animEdit
				
				animationEdit.Draw()
		
		End
		
		DrawAllAnimations()
		
		WindowsRender()
		
		DrawBubbles()
		
		White()
		If coords = True DrawText(MouseX() + ", "+ MouseY(), 0,0)

	End

	Method OnSuspend()

	End

End





Function Main()

        New GameGW

End

'=================


