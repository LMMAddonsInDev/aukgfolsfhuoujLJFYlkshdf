resource.AddFile( "sound/achits.mp3" )
resource.AddFile( "sound/pendhits.mp3" )
resource.AddFile( "sound/hitcompleted.mp3" )
util.AddNetworkString("HTSYSOpenMenu")


concommand.Add("hitmenu", function( ply )
	net.Start("HTSYSOpenMenu")
	net.Send(ply)
end )