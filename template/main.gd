extends Control

@export var LobbyScene: PackedScene
@export var GameScene: PackedScene 

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_environment("USERNAME"):
		$name_line.text = OS.get_environment("USERNAME")
	else:
		$name_line.text = "Player " + str(randi_range(1, 200))
		
		
	if "--server" in OS.get_cmdline_args():
		print("server mode")
		var lobby = LobbyScene.instantiate()
		lobby.is_host = true
		get_tree().root.add_child.call_deferred(lobby)
		self.hide()
	
	PlayerManager.players_connected.connect(players_connected)

func players_connected():
	print("chamou2")
	var game = GameScene.instantiate()	
	get_tree().root.add_child.call_deferred(game)
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_find_match_pressed():
	var lobby = LobbyScene.instantiate()
	PlayerManager.player_info = {"name" : $name_line.text}
	get_tree().root.add_child(lobby)
		
	self.hide()


func _on_host_match_pressed():
	var lobby = LobbyScene.instantiate()
	lobby.is_host = true
	PlayerManager.player_info = {"name" : $name_line.text}
	get_tree().root.add_child(lobby)
	
	self.hide()


func _on_solo_player_pressed():
	var lobby = LobbyScene.instantiate()
	lobby.is_host = true
	PlayerManager.lobby_size = 1
	PlayerManager.player_info = {"name" : $name_line.text}
	get_tree().root.add_child(lobby)
	
	self.hide()
