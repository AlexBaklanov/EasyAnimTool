Strict

Import imp

Function MainInit:Void()

	GameCenterTrue = False
	
	#If TARGET = "ios"
		
		InitIOS()
		
	#Endif
	
	#If TARGET = "html5"
		
		InitHTML()
		
	#Endif
	
	#If TARGET = "android"

		InitANDROID()

	#Endif

	'other inits'
	
	dw = DeviceWidth()
	dh = DeviceHeight()

	LoadGeneralImages()

	indicate2xForImageRectangles()

	Mode = imgEdit
	imageEdit.Init()

End

Function InitIOS:Void()

	If DeviceWidth()=480
		Retina = 1
		loadadd = ""
		retinaStr = ""
		retinaScl = 1
	Elseif DeviceWidth()=960
		Retina = 2
		loadadd = ""
		retinaStr = "@p"
		retinaScl = 1
	Elseif DeviceWidth()=1024
		Retina = 2
		loadadd = "@2x"
		retinaStr = "@p"
		retinaScl = 1
	Elseif DeviceWidth()=2048
		Retina = 4
		loadadd = "@2x"
		retinaStr = "@p"
		retinaScl = 2
	Endif
	
	target = "ios"
	GameCenterTrue = True

End

Function InitHTML:Void()

	Local test_for$ = "html"
		
	If test_for = "html"
		Retina = 1
		loadadd = ""
		retinaScl = 1
		If DeviceWidth() = 960 Or DeviceWidth() = 1136
			Retina = 2
			loadadd = "@2x"
			retinaStr = "@p"
			retinaScl = 1
		End
		If DeviceWidth() = 1024
			Retina = 2
			loadadd = "@2x"
			retinaStr = "@p"
			retinaScl = 1
		End
		target = "html"
		
	Endif
	
	If test_for = "android"
		loadadd = "@a"
		loadfolder = "android/"
		Retina=2
		target = "android"
	Endif
	
	If test_for = "ipad"
		target = "ios"
		Retina = 2
		loadadd = "@p"
		loadfolder = "iPad/"
	Endif

End

Function InitANDROID:Void()

	Retina = 1
	loadadd = ""
	retinaStr = ""
	retinaScl = 1
	target = "android"
	
	InAppPurchase = False
	PlayerName = True

End





