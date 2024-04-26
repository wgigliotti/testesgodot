@tool
extends Node
class_name PlayerEngine

@onready var player : PlayerBase = get_parent()
@onready var state_chart : StateChart = get_node("StateChart")
@onready var player_commands : PlayerCommands = get_node("PlayerCommands")
@onready var cen : PlayerCommands = $CommandsEnum

var direction : Vector3 = Vector3.UP
var active_command : constants.PlayerCommandEnum = constants.PlayerCommandEnum.NONE

func _physics_process(_delta):
	if  Engine.is_editor_hint():			
		return
	direction = player_commands.getDirections()		
		
		
func _on_idle_state_entered():	
	player.velocity = Vector3.ZERO
	player.active_animation = { "name": "Idle", "scale": 1, "start":null, "end":null}	


func _on_running_state_entered():
	player.active_animation = { "name": "Running_A", "scale": 1, "start":null, "end":null}


func _on_running_state_physics_processing(delta):
	var mdirection = direction
	if mdirection == Vector3.ZERO:		
		state_chart.send_event("stop")
		return
	
	active_command = player_commands.getCommandJustPressed()
	
	if active_command != constants.PlayerCommandEnum.NONE:
		state_chart.send_event("act")
		
	player.get_pivot().basis = Basis.looking_at(mdirection)
	player.move(1, delta, mdirection)


func _on_idle_state_physics_processing(delta):
	active_command = player_commands.getCommandJustPressed()
	
	if active_command != constants.PlayerCommandEnum.NONE:
		print("act")
		state_chart.send_event("act")
		
	if direction != Vector3.ZERO:
		state_chart.send_event("run")
		player.get_pivot().basis = Basis.looking_at(direction)


func _on_acting_state_entered():
	print("_on_signature_state_entered")
	player.signature_skill.enter_skill(player)


func _on_acting_state_physics_processing(delta):
	var response = player.signature_skill._process_skill(delta, player_commands.isCommandPressed(active_command))
	if response:
		state_chart.send_event("idle")
