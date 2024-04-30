extends Node

var player

var ping_time = 0


func getPlayerInfo(mid):
	return PlayerManager.players[mid]
	
func getCurrentPlayerInfo():
	return PlayerManager.player_info
	
func create_player(PlayerScene, UIScene, node, id):
	var currentPlayer = PlayerScene.instantiate()
	currentPlayer.name = str(id)	
	currentPlayer.add_to_group("player")
	
	PlayerManager.players[id].score = 0
		
	if multiplayer.get_unique_id() == id:
		player = currentPlayer		
	
	node.add_child(currentPlayer)
	
	var ui = UIScene.instantiate()
	ui.setShip(currentPlayer)
	
	node.add_child(ui)
		
	return currentPlayer
	
func add_score(playerid, score):
	PlayerManager.players[playerid].score += score


func pplayer_info(mname, id):
	return {
			"name": mname,
			"id": id,
			"score": 0
		}
		

@rpc("any_peer")
func ping(start):
	var from = multiplayer.get_remote_sender_id()
	pong.rpc_id(from, start)	
	
@rpc("any_peer")
func pong(start):
	ping_time = Time.get_ticks_msec() - start
