surface.CreateFont( "HTSYSfontclose", {
		font = "Lato Light",
		size = 25,
		weight = 250,
		antialias = true,
		strikeout = false,
		additive = true,
} )
 
surface.CreateFont( "HTSYSTitleFont", {
		font = "Lato Light",
		size = 30,
		weight = 250,
		antialias = true,
		strikeout = false,
		additive = true,
} )
 
local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount) --Panel blur function
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 6 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local function drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end

net.Receive( "BlurHSOpenHitmanMenu", function()
	local title = net.ReadTable()
	
	function MainMenu()
		local menu = vgui.Create( "DFrame" )
		menu:SetSize( 300, 500 )
		menu:Center()
		menu:SetDraggable( true )
		menu:MakePopup()
		menu:SetTitle( "" )
		menu:ShowCloseButton( false )
		menu.Paint = function( self, w, h )
			DrawBlur(menu, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 8.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 9, Color(0,0,0,125))
			draw.SimpleText( "Hit Menu", "HTSYSTitleFont", menu:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", menu )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu:GetWide() - 36,9 )
		frameclose:SetText( "X" )
		frameclose:SetFont( "HTSYSfontclose" )
		frameclose:SetTextColor( Color( 255, 255, 255 ) )
		frameclose.Paint = function()
			
		end
		frameclose.DoClick = function()
			menu:Close()
			menu:Remove()
			gui.EnableScreenClicker( false )			
		end	

		local active = vgui.Create("DButton", menu)
		active:SetParent(menu)
		active:SetSize(100,20)
		active:SetPos(20,80)
		active:SetFont("Trebuchet18")
		active:SetText("Active Hits")
		active:SetTextColor(Color(255,255,255,255))
		active.DoClick = function()
		menu:Close()
		surface.PlaySound( "achits.mp3" )
		Active()
		gui.EnableScreenClicker(true)
		end
		active.Paint = function( self, w, h )
			DrawBlur(active, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end 

		local pending = vgui.Create("DButton", menu)
		pending:SetParent(menu)
		pending:SetSize(100,20)
		pending:SetPos(170,80)
		pending:SetFont("Trebuchet18")
		pending:SetText("Pending Hits")
		pending:SetTextColor(Color(255,255,255,255))	
		pending.DoClick = function()
		menu:Close()
		surface.PlaySound( "pendhits.mp3" )
		Pendinghits()
		gui.EnableScreenClicker(true)
		end
		pending.Paint = function( self, w, h )
			DrawBlur(pending, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end 
	end
		
	function Active()
		local menu2 = vgui.Create( "DFrame" )
		menu2:SetSize( 300, 500 )
		menu2:Center()
		menu2:SetDraggable( true )
		menu2:MakePopup()
		menu2:SetTitle( "" )
		menu2:ShowCloseButton( false )
		menu2.Paint = function( self, w, h )
			DrawBlur(menu2, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 8.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 9, Color(0,0,0,125))
			draw.SimpleText( "Hit Menu", "HTSYSTitleFont", menu2:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", menu2 )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu2:GetWide() - 36,9 )
		frameclose:SetText( "X" )
		frameclose:SetFont( "HTSYSfontclose" )
		frameclose:SetTextColor( Color( 255, 255, 255 ) )
		frameclose.Paint = function()
			
		end
		frameclose.DoClick = function()
			menu2:Close()
			menu2:Remove()
			gui.EnableScreenClicker( false )			
		end	

		local frameback = vgui.Create( "DButton", menu2 )
		frameback:SetSize( menu2:GetWide() - 20, 20 )
		frameback:SetPos( 12, 60 )
		frameback:SetText( "<-- Back" )
--		frameback:SetFont( "HTSYSfontclose" )
--		frameback:SetTextColor( Color( 255, 255, 255 ) )
--		frameback.Paint = function( self, w, h )
--			DrawBlur(frameback, 2)
--			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
--			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
--		end
		frameback.DoClick = function()
			menu2:Close()
			menu2:Remove()
			MainMenu()
		end			
		
		local DListView = vgui.Create( "DListView", menu2 )
		DListView:SetSize( menu2:GetWide() - 20, menu2:GetTall() - 100 )
		DListView:SetPos( 10, 85 )
		DListView:AddColumn( "Placed On" )
		DListView:AddColumn( "Placed By" )
		DListView:AddColumn( "Price" )
--		function DListView:DoDoubleClick( line )
--			local LocalText = DListView:GetLine( line ):GetValue( 2 )
--			local LocalTitle = DListView:GetLine( line ):GetValue( 1 )		
--		
--			LocalPlayer():ConCommand( "say "..LocalText )
--			menu2:Close()
--			menu2:Remove()			
--		end		
		
	end
	
	function Pendinghits()
		local menu3 = vgui.Create( "DFrame" )
		menu3:SetSize( 300, 500 )
		menu3:Center()
		menu3:SetDraggable( true )
		menu3:MakePopup()
		menu3:SetTitle( "" )
		menu3:ShowCloseButton( false )
		menu3.Paint = function( self, w, h )
			DrawBlur(menu3, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 8.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 9, Color(0,0,0,125))
			draw.SimpleText( "Hit Menu", "HTSYSTitleFont", menu3:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", menu3 )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu3:GetWide() - 36,9 )
		frameclose:SetText( "X" )
		frameclose:SetFont( "HTSYSfontclose" )
		frameclose:SetTextColor( Color( 255, 255, 255 ) )
		frameclose.Paint = function()
			
		end
		frameclose.DoClick = function()
			menu3:Close()
			menu3:Remove()
			gui.EnableScreenClicker( false )			
		end	

		local frameback = vgui.Create( "DButton", menu3 )
		frameback:SetSize( menu3:GetWide() - 20, 20 )
		frameback:SetPos( 12, 60 )
		frameback:SetText( "<-- Back" )
--		frameback:SetFont( "HTSYSfontclose" )
--		frameback:SetTextColor( Color( 255, 255, 255 ) )
--		frameback.Paint = function( self, w, h )
--			DrawBlur(frameback, 2)
--			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
--			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
--		end
		frameback.DoClick = function()
			menu3:Close()
			menu3:Remove()
			MainMenu()
		end			
		
		local DListView = vgui.Create( "DListView", menu3 )
		DListView:SetSize( menu3:GetWide() - 20, menu3:GetTall() - 100 )
		DListView:SetPos( 10, 85 )
		DListView:AddColumn( "Placed On" )
		DListView:AddColumn( "Placed By" )
		DListView:AddColumn( "Price" )
--		function DListView:DoDoubleClick( line )
--			local LocalText = DListView:GetLine( line ):GetValue( 2 )
--			local LocalTitle = DListView:GetLine( line ):GetValue( 1 )		
--		
--			LocalPlayer():ConCommand( "say "..LocalText )
--			menu2:Close()
--			menu2:Remove()			
--		end		
	end

	MainMenu()	
	
end )

net.Receive( "BlurHSOpenHitMenu", function()

	function MainMenu()
		local menu = vgui.Create( "DFrame" )
		menu:SetSize( 300, 300 )
		menu:Center()
		menu:SetDraggable( true )
		menu:MakePopup()
		menu:SetTitle( "" )
		menu:ShowCloseButton( false )
		menu.Paint = function( self, w, h )
			DrawBlur(menu, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 8.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 9, Color(0,0,0,125))
			draw.SimpleText( "Place A Hit", "HTSYSTitleFont", menu:GetWide() / 2, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", menu )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu:GetWide() - 36,5 )
		frameclose:SetText( "X" )
		frameclose:SetFont( "HTSYSfontclose" )
		frameclose:SetTextColor( Color( 255, 255, 255 ) )
		frameclose.Paint = function()
			
		end
		frameclose.DoClick = function()
			menu:Close()
			menu:Remove()
			gui.EnableScreenClicker( false )			
		end	
	end
	
	MainMenu()
	
end )
