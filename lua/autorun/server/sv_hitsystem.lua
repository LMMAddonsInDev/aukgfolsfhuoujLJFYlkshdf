resource.AddFile( "sound/achits.mp3" )
resource.AddFile( "sound/pendhits.mp3" )
resource.AddFile( "sound/hitcompleted.mp3" )

include("bhitsystem_config.lua")
AddCSLuaFile("bhitsystem_config.lua")

util.AddNetworkString("BlurHSOpenHitmanMenu")
util.AddNetworkString("BlurHSOpenHitMenu")
util.AddNetworkString("BlurHSPickSendHit")
util.AddNetworkString("BlurHSSendPlayerToHit")
util.AddNetworkString("BlurHSPickHitman")
util.AddNetworkString("BlurHSOpenHitMenuPlayerToHit")
util.AddNetworkString("BlurHSOpenHitMenuPrice")
util.AddNetworkString("BlurHSSendHitPrice")
util.AddNetworkString("BlurHSOpenHitMenuNotes")
util.AddNetworkString("BlurHSSendHitNotes")



function SendGUI( ply )
	if table.HasValue( BHitSysConfig.HitmanTeams, team.GetName(ply:Team()) ) then
		net.Start("BlurHSOpenHitmanMenu")
		
		net.Send(ply)
	else
		net.Start("BlurHSOpenHitMenu")
		
		net.Send(ply)
	end
end

net.Receive("BlurHSPickSendHit", function( len, ply )
	local hitman = net.ReadEntity()
	
	if hitman == ply then
		--error msg
		return
	end

	net.Start("BlurHSOpenHitMenuPlayerToHit")
	net.Send(ply)
	
end )


net.Receive("BlurHSSendPlayerToHit", function( len, ply )
	local tohit = net.ReadEntity()
	
	if tohit == ply then
		--error msg
		return 
	end
	
	net.Start("BlurHSOpenHitMenuPrice")
	net.Send(ply)

end)

net.Receive("BlurHSSendHitPrice", function( len, ply )
	local hitprice = tonumber(net.ReadString())
	
	if not isnumber(hitprice) then
		--error msg

		return
	else
		if hitprice > BHitSysConfig.MaxHitPrice then 
			--error msg
			return
		elseif hitprice < BHitSysConfig.MinHitPrice then
			--error msg
			return
		else
			net.Start("BlurHSOpenHitMenuNotes")
			net.Send(ply)
		end
	end
	
end )

function BlurHSOpenMenu(ply, text)
	local text = string.lower(text)
	if(string.sub(text, 0, 100)== "/hitmenu" or string.sub(text, 0, 100)== "!hitmenu" or string.sub(text, 0, 100)== "!placehit" or string.sub(text, 0, 100)== "/placehit") then
		SendGUI(ply)
		return ''
	end
end 
hook.Add("PlayerSay", "BlurHSOpenMenu", BlurHSOpenMenu)

concommand.Add("hitmenu", function( ply )
	SendGUI(ply)
end )

concommand.Add("placehit", function( ply )
	SendGUI(ply)
end )