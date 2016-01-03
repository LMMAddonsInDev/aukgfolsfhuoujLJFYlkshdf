include("bhitsystem_config.lua")

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

	local ply = LocalPlayer()

	local rvictim = ply:GetNWEntity("HitsVictim")
	local rprice = ply:GetNWInt("HitsReward")
	local rnotes = ply:GetNWString("ExtraNotes")		

	print(rvictim)
	print(rprice)
	print(rnotes)
	
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
local menu = vgui.Create( "DFrame" )
		menu:SetSize( 600, 400 )
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
		local model = vgui.Create( "DModelPanel", menu )
		model:SetSize( 200, 250 )
		model:SetPos( 395, 50 )
		if rvictim == true then
		model:SetModel( rvictim:GetModel() )  
		else
		model:SetModel(LocalPlayer():GetModel())
		end
		--model.Paint = function()
		--	surface.DrawOutlinedRect( 0, 0, model:GetWide(), model:GetTall() )		

		frameclose.DoClick = function()
			menu:Close()
			menu:Remove()
			model:Remove()			
			gui.EnableScreenClicker( false )
			end
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
		frameback:SetPos( 10, 60 )
		frameback:SetText( "Back" )
		frameback:SetFont( "HTSYSfontclose" )
		frameback:SetTextColor( Color( 255, 255, 255 ) )
		frameback.Paint = function( self, w, h )
			DrawBlur(frameback, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end
		frameback.DoClick = function()
			menu3:Close()
			menu3:Remove()
			MainMenu()
		end			
	local notes = net.ReadString()
	local hitprice = tonumber(net.ReadString())
	local victim = net.ReadEntity()
	local hitman = net.ReadEntity()
		local DListView = vgui.Create( "DListView", menu3 )
		DListView:SetSize( menu3:GetWide() - 20, menu3:GetTall() - 100 )
		DListView:SetPos( 10, 85 )
		DListView:AddColumn( "Placed On" )
		DListView:AddColumn( "Placed By" )
		DListView:AddColumn( "Price" )
		DListView:AddLine( victim, victim, hitprice )
		DListView.Paint = function( self, w, h )
			DrawBlur(DListView, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end 
		function DListView:DoDoubleClick( line )
		
			
			local LocalText = DListView:GetLine( line ):GetValue( 2 )
			local LocalTitle = DListView:GetLine( line ):GetValue( 1 )		
		
			LocalPlayer():ConCommand( "say "..LocalText )
			menu2:Close()
			menu2:Remove()	

		end		
	end

	MainMenu()	
	
end )

net.Receive( "BlurHSOpenHitMenu", function()

	function MainMenu()
		local menu = vgui.Create( "DFrame" )
		menu:SetSize( 300, 100 )
		menu:Center()
		menu:SetDraggable( true )
		menu:MakePopup()
		menu:SetTitle( "" )
		menu:ShowCloseButton( false )
		menu.Paint = function( self, w, h )
			DrawBlur(menu, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 2.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 3, Color(0,0,0,125))
			draw.SimpleText( "Place A Hit", "HTSYSTitleFont", menu:GetWide() / 2, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", menu )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu:GetWide() - 34,5 )
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
		
		local combobox = vgui.Create("DComboBox", menu)
			combobox:SetPos(10,60)
			combobox:SetSize(menu:GetWide() - 20, 20)
			combobox:SetValue("Select A Hitman")
			for k, v in pairs( player.GetAll() ) do
				if v != LocalPlayer() and table.HasValue( BHitSysConfig.HitmanTeams, team.GetName(v:Team()) ) then
				combobox:AddChoice(v:Nick(), function()
						net.Start("BlurHSPickSendHit")
							net.WriteEntity( v )
						net.SendToServer()
						menu:Close()
						menu:Remove()
						gui.EnableScreenClicker( false )	
	
	
				end)
			end
		end
		
	end
	
	MainMenu()
	
end )

net.Receive("BlurHSOpenHitMenuPlayerToHit", function()

	local hitman = net.ReadEntity()

	function MainMenu()
		local menu = vgui.Create( "DFrame" )
		menu:SetSize( 300, 100 )
		menu:Center()
		menu:SetDraggable( true )
		menu:MakePopup()
		menu:SetTitle( "" )
		menu:ShowCloseButton( false )
		menu.Paint = function( self, w, h )
			DrawBlur(menu, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 2.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 3, Color(0,0,0,125))
			draw.SimpleText( "Place A Hit", "HTSYSTitleFont", menu:GetWide() / 2, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", menu )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu:GetWide() - 34,5 )
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
		
		local combobox = vgui.Create("DComboBox", menu)
			combobox:SetPos(10,60)
			combobox:SetSize(menu:GetWide() - 20, 20)
			combobox:SetValue("Select A Victim")
			for k, v in pairs( player.GetAll() ) do
				if v != LocalPlayer() and !table.HasValue( BHitSysConfig.HitmanTeams, team.GetName(v:Team()) ) then
				combobox:AddChoice(v:Nick(), function()
						net.Start("BlurHSPickSendHit")
							net.WriteEntity( v )
						net.SendToServer()
						menu:Close()
						menu:Remove()
						gui.EnableScreenClicker( false )	
	
	
				end)
			end
		end
	end
	MainMenu()
end )
net.Receive( "BlurHSOpenHitMenuPrice", function()

	local victim = net.ReadEntity()
	local hitman = net.ReadEntity()

	function MainMenu()
		local menu = vgui.Create( "DFrame" )
		menu:SetSize( 300, 100 )
		menu:Center()
		menu:SetDraggable( true )
		menu:MakePopup()
		menu:SetTitle( "" )
		menu:ShowCloseButton( false )
		menu.Paint = function( self, w, h )
			DrawBlur(menu, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 2.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 3, Color(0,0,0,125))
			draw.SimpleText( "Place A Hit", "HTSYSTitleFont", menu:GetWide() / 2, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", menu )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu:GetWide() - 34,5 )
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

		local TextEntry = vgui.Create( "DTextEntry", menu )	-- create the form as a child of frame
		TextEntry:SetPos( 10, 60 )
		TextEntry:SetSize( menu:GetWide() - 20, 20 )
		TextEntry:SetText( "Set Hit Price ("..BHitSysConfig.MinHitPrice.."-"..BHitSysConfig.MaxHitPrice..")" )
		TextEntry.OnEnter = function( self )
			net.Start("BlurHSSendHitPrice")
				net.WriteString(self:GetValue())
				net.WriteEntity( victim )
				net.WriteEntity( hitman )
			net.SendToServer()
			menu:Close()
			menu:Remove()
			gui.EnableScreenClicker( false )			
		end
		
		
	end
	
	MainMenu()
	
end )

net.Receive( "BlurHSOpenHitMenuNotes", function()
	
	local hitprice = tonumber(net.ReadString())
	local victim = net.ReadEntity()
	local hitman = net.ReadEntity()
	
	function MainMenu()
		local menu = vgui.Create( "DFrame" )
		menu:SetSize( 300, 100 )
		menu:Center()
		menu:SetDraggable( true )
		menu:MakePopup()
		menu:SetTitle( "" )
		menu:ShowCloseButton( false )
		menu.Paint = function( self, w, h )
			DrawBlur(menu, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 2.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 3, Color(0,0,0,125))
			draw.SimpleText( "Place A Hit", "HTSYSTitleFont", menu:GetWide() / 2, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", menu )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu:GetWide() - 34,5 )
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

net.Recieve("")
		local TextEntry = vgui.Create( "DTextEntry", menu )	-- create the form as a child of frame
		TextEntry:SetPos( 10, 60 )
		TextEntry:SetSize( menu:GetWide() - 20, 20 )
		TextEntry:SetText( "Extra Notes" )
		TextEntry.OnEnter = function( self )
		net.Start("BlurHSSendHitNotes")
				net.WriteString(self:GetValue())
				net.WriteString(hitprice)
				net.WriteEntity( victim )
				net.WriteEntity( hitman )
			net.SendToServer()
			menu:Close()
			menu:Remove()
			gui.EnableScreenClicker( false )			
		end
		
		
	end
	
	MainMenu()
	
end )







--[[Errors]]--
net.Receive("BlurHSErrorHitIsPly", function()
	chat.AddText(Color(0,0,0), "[HitMenu] ", Color(255,255,255), "You can not select yourself to be the hitman!")
end )
net.Receive("BlurHSErrorHitOnSelf", function()
	chat.AddText(Color(0,0,0), "[HitMenu] ", Color(255,255,255), "You can not set a hit on yourself!")
end )
net.Receive("BlurHSErrorPriceIsString", function()
	chat.AddText(Color(0,0,0), "[HitMenu] ", Color(255,255,255), "You need to enter a number!")
end )
net.Receive("BlurHSErrorPriceIsToHigh", function()
	chat.AddText(Color(0,0,0), "[HitMenu] ", Color(255,255,255), "That price is too high!")
end )
net.Receive("BlurHSErrorPriceIsToLow", function()
	chat.AddText(Color(0,0,0), "[HitMenu] ", Color(255,255,255), "That price is too low!")
end )


--[[Errors]]--