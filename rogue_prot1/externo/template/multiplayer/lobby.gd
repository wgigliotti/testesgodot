extends Control

@onready var label_message = $message
@onready var players = $playerPanel/playerList

var is_host = false
var peer

func _ready():
	if(is_host):
		host()
	else:
		join() 
	
	PlayerManager.connection_ok.connect(connection_ok)	
	

func players_connected():
	print("chamou")
	hide()
	queue_free()
	
func connection_ok():
	label_message.text = "Waiting for players"

func join():
	PlayerManager.join()
	print("Vou dar join...")	
	
func host():
	PlayerManager.host()
	label_message.text = "Waiting for players"	


func _on_refresh_player_list_timeout():
	for child in players.get_children():
		if child.is_in_group("score"):
			child.queue_free()
	
	createLabels(PlayerManager.players.values())
	
func createLabels(players_list):
	for player in players_list:
		var player_lbl = Label.new()
		
		player_lbl.text = player.name
		player_lbl.add_to_group("score")
		players.add_child(player_lbl)
