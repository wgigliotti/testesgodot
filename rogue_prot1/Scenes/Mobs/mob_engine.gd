@tool
extends Node
class_name MobEngine
	
@onready var mob : MobBase = get_parent()
var target
@export var forget_distance : int = 15 * 15
var SPEED = 10
var active_behavior : Behavior = null

@onready var state_chart : StateChart = get_node("StateChart")
var deaths_animation = ["Death_A", "Death_B", "Death_C_Skeletons"]

@onready var character_sheet = mob.get_node("CharacterSheet")

func _ready():
	for behavior in get_children():
		if behavior is Behavior:
			behavior.on_attach(self)
	
	character_sheet.connect_signal_for_property("health", _on_health_change)
	character_sheet.set_value("name", self.name)

	
func _on_health_change(_from, to):
	if to <= 0:
		state_chart.send_event("die")
	
	
func _check_warning_search(node_check, node_name, message, warnings):
	for child in get_children():		
		if node_check.call(child): 
			if node_name == null or child.name == node_name:
				return
	
	warnings.append(message)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings:PackedStringArray = []
	var parent = get_parent()	
	if not parent is MobBase: 
		warnings.append("This engine must have a MobBase as parent.")
	return warnings


func _on_traversing_state_entered():
	mob.velocity = Vector3.ZERO	
	mob.active_animation = { "name": "Idle", "scale": 1, "start":null, "end":null}

func _on_traversing_state_physics_processing(_delta):
	var vision : Area3D = mob.get_vision()
	
	for candidate in vision.get_overlapping_bodies():
		
		print(candidate)
		target = candidate
		state_chart.send_event("chase")
		break


func _on_chasing_state_entered():
	mob.active_animation = { "name": "Walking_A", "scale": 1, "start":null, "end":null}	


func _on_chasing_state_exited():
	pass


func _on_chasing_state_physics_processing(delta):
	var dir : Vector3 = target.global_position - mob.global_position		
	if dir.length_squared() > forget_distance:
		state_chart.send_event("forget")
	else:
		dir = dir.normalized()
		mob.get_pivot().basis = Basis.looking_at(dir)
		mob.velocity = dir * SPEED
	
	for behavior in get_children():
		if behavior is Behavior and behavior.check_execution(target, delta):
			active_behavior = behavior			
			state_chart.send_event("attack")
			

func _on_attacking_state_entered():	
	active_behavior.start_execution(target)


func _on_attacking_state_physics_processing(delta):
	if !active_behavior.run_execution(delta):
		state_chart.send_event("chase")


func _on_attacking_state_exited():
	active_behavior.finish_execution()


func _on_dead_state_entered():
	mob.get_node("CollisionShape3D").disabled = true
	mob.animationPlayer.play(deaths_animation[randi_range(0,2)])	
	return
