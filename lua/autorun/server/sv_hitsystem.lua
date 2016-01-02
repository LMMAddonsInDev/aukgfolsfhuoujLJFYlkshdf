resource.AddFile( "sound/achits.mp3" )
resource.AddFile( "sound/pendhits.mp3" )
resource.AddFile( "sound/hitcompleted.mp3" )

include("bhitsystem_config.lua")
AddCSLuaFile("bhitsystem_config.lua")

util.AddNetworkString("BlurHSOpenHitmanMenu")
util.AddNetworkString("BlurHSOpenHitMenu")


function SendGUI( ply )
	if table.HasValue( BHitSysConfig.HitmanTeams, team.GetName(ply:Team()) ) then
		net.Start("BlurHSOpenHitmanMenu")
		
		net.Send(ply)
	else
		net.Start("BlurHSOpenHitMenu")
		
		net.Send(ply)
	end
end

concommand.Add("hitmenu", function( ply )
	SendGUI(ply)
end )

concommand.Add("placehit", function( ply )
	SendGUI(ply)
end )

function BlurHSOpenMenu(ply, text)
	local text = string.lower(text)
	if(string.sub(text, 0, 100)== "/hitmenu" or string.sub(text, 0, 100)== "!hitmenu" or string.sub(text, 0, 100)== "!placehit" or string.sub(text, 0, 100)== "/placehit") then
		SendGUI(ply)
		return ''
	end
end 
hook.Add("PlayerSay", "BlurHSOpenMenu", BlurHSOpenMenu)