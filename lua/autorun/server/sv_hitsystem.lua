resource.AddFile( "sound/achits.mp3" )
resource.AddFile( "sound/pendhits.mp3" )
resource.AddFile( "sound/hitcompleted.mp3" )

include("bhitsystem_config.lua")
AddCSLuaFile("bhitsystem_config.lua")

--[[Systems]]--
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
util.AddNetworkString("BlurHRecieveHitPrice")
--[[Systems]]--
--[[Errors]]--
util.AddNetworkString("BlurHSErrorHitIsPly")
util.AddNetworkString("BlurHSErrorHitOnSelf")
util.AddNetworkString("BlurHSErrorPriceIsString")
util.AddNetworkString("BlurHSErrorPriceIsToHigh")
util.AddNetworkString("BlurHSErrorPriceIsToLow")
--[[Errors]]--

function FinishData( hitman, victim, hitprice, notes )
	hitman:SetNWBool("ActiveHit", true)
	hitman:SetNWEntity("HitsVictim", victim)
	hitman:SetNWInt("HitsReward", hitprice)
	hitman:SetNWString("ExtraNotes", notes)
end

function SendGUI( ply )

	HitInfo = {}

	if table.HasValue( BHitSysConfig.HitmanTeams, team.GetName(ply:Team()) ) then
		net.Start("BlurHSOpenHitmanMenu")
			local victim = ply:GetNWEntity("HitsVictim")
			local price = ply:GetNWInt("HitsReward")
			local notes = ply:GetNWString("ExtraNotes")	
		net.Send(ply)
	else
		net.Start("BlurHSOpenHitMenu")
		net.Send(ply)
	end
end




net.Receive("BlurHSPickSendHit", function( len, ply )
	local hitman = net.ReadEntity()
	
	if hitman == ply then
		net.Start("BlurHSErrorHitIsPly")
		net.Send(ply)
		return
	end

	net.Start("BlurHSOpenHitMenuPlayerToHit")
		net.WriteEntity(hitman)
	net.Send(ply)
		
	
	
end )


net.Receive("BlurHSSendPlayerToHit", function( len, ply )
	local victim = net.ReadEntity()
	local hitman = net.ReadEntity()
	
	if victim == ply then
		net.Start("BlurHSErrorHitOnSelf")
		net.Send(ply)
		return 
	end
	
	net.Start("BlurHSOpenHitMenuPrice")
		net.WriteEntity(victim)
		net.WriteEntity(hitman)
	net.Send(ply)

end)




net.Receive("BlurHSSendHitPrice", function( len, ply )
	local hitprice = tonumber(net.ReadString())
	local victim = net.ReadEntity()
	local hitman = net.ReadEntity()
	ply:addMoney(-hitprice)
	
	if not isnumber(hitprice) then
		net.Start("BlurHSErrorPriceIsString")
		net.Send(ply)
		return
	else
		if hitprice > BHitSysConfig.MaxHitPrice then 
			net.Start("BlurHSErrorPriceIsToHigh")
			net.Send(ply)
			return
		elseif hitprice < BHitSysConfig.MinHitPrice then
			net.Start("BlurHSErrorPriceIsToLow")
			net.Send(ply)
			return
		else
			net.Start("BlurHSOpenHitMenuNotes")
				net.WriteString( hitprice )
				net.WriteEntity( victim )
				net.WriteEntity( hitman )
			net.Send(ply)
			
			
			net.Start("BlurHRecieveHitPrice")
				net.WriteString( hitprice )
				net.WriteEntity( victim )
				net.WriteEntity( hitman )
			net.Send(ply)
			
			
	
		end
	end
	
end )

net.Receive("BlurHSSendHitNotes", function( len, ply )
	local notes = net.ReadString()
	local hitprice = tonumber(net.ReadString())
	local victim = net.ReadEntity()
	local hitman = net.ReadEntity()
	
	if notes == nil then notes = "None" end
	
	FinishData( hitman, victim, hitprice, notes )
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