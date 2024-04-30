extends Control

@export var port = 8910

@export var SceneMap: PackedScene
@export var LobbyScene: PackedScene

var lobby
@export var bots: int

var peer
# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_environment("USERNAME"):
		$nameLine.text = OS.get_environment("USERNAME")
	else:
		$nameLine.text = "Player " + str(randi_range(1, 200))
		
	if "--server" in OS.get_cmdline_args():
		print("server mode")
		var lobby = LobbyScene.instantiate()
		lobby.is_host = true
		get_tree().root.add_child.call_deferred(lobby)
		self.hide()
		PlayerManager.players_connected.connect(players_connected)
		
			

func players_connected():
	start_game.rpc()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func connected_to_server():
	print("Connected")
	GameManager.send_player_information.rpc_id(1, GameManager.player_info($nameLine.text, multiplayer.get_unique_id()),  multiplayer.get_unique_id())
	
func connection_failed():
	print("Connection Failed")
	
func peer_connected(id):
	print("Player connected " + str(id))
	
func peer_disconnected(id):
	print("Player disconnected " + str(id))


func _on_host_button_down():	
	lobby = LobbyScene.instantiate()
	lobby.is_host = true
	PlayerManager.player_info = {"name" : $nameLine.text, "score": 0}
	PlayerManager.players_connected.connect(players_connected)
	get_tree().root.add_child(lobby)
	
	self.hide()

func _on_join_button_down():
	PlayerManager.server_ip = $hostLine.text
	PlayerManager.player_info = {"name" : $nameLine.text, "score": 0}
	lobby = LobbyScene.instantiate()	
	get_tree().root.add_child(lobby)
	
	self.hide()

@rpc("any_peer", "call_local")
func start_game():
		
		var scene = SceneMap.instantiate()
		get_tree().root.add_child(scene)
		lobby.hide()
		lobby.queue_free()
		self.hide()

@rpc("any_peer")
func server_start():
	for n in bots:
		GameManager.send_player_information(GameManager.player_info("Bot %d" % n , -n),  -n)	
		
	start_game.rpc()
	
		
func _on_start_game_button_down():
	if multiplayer.is_server():
		server_start()
	else:
		server_start.rpc_id(1)
