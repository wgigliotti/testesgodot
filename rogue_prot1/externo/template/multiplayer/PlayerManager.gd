extends Node


enum Status {IDLE=0, PLAYER_JOINING=1, WAITING_READY=2, READY=3}

signal connection_ok
signal cannot_host
signal players_connected

var server_ip : String = "localhost"
var server_port : int = 9999
var lobby_size: int = 2
var state: Status = Status.PLAYER_JOINING
var players = {}
var player_info
var player_objects = {}
var peer
var dedicated_server = false

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if "--server" in OS.get_cmdline_args():
		dedicated_server = true
	

func is_dedicated_server():
	return dedicated_server
	
func connected_to_server():
	player_info.id =  multiplayer.get_unique_id()
	PlayerManager.send_player_information.rpc_id(1, player_info)
	print("Connected")
	connection_ok.emit()
	
func connection_failed():
	print("Connection Failed")
	
func peer_connected(id):
	print("Player connected " + str(id))
	
func peer_disconnected(id):
	PlayerManager.players.erase(id)
	print("Player disconnected " + str(id))
	
func join():
	print("Vou dar join...")
	peer = ENetMultiplayerPeer.new()
	peer.create_client(server_ip, server_port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
func host():
	peer = ENetMultiplayerPeer.new()
	var addHost = (0 if PlayerManager.player_info == null else -1) + lobby_size
	var number = 1 if lobby_size == 1 else addHost
	var error = peer.create_server(server_port, number)
	
	if error  != OK:
		cannot_host.emit()
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)	
	
	if PlayerManager.player_info != null:
		PlayerManager.player_info.id = multiplayer.get_unique_id()
		PlayerManager.send_player_information(PlayerManager.player_info)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if multiplayer.is_server():		
		if state == Status.PLAYER_JOINING and players.size() == lobby_size:
			print("Multiplayer process server:" + str(players.size()))			
			state = Status.READY
			players_connected.emit()
			
			
	
	
@rpc("any_peer")
func send_player_information(player_info):
	players[player_info.id] = player_info
	
	update_players()
		
func update_players():
	if multiplayer.is_server():
		for i in players:
			send_player_information.rpc(players[i])
	
