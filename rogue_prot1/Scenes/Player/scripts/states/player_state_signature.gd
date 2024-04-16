extends State
class_name PlayerStateSignature

@export var attack : CharacterAttack

var animation_name = "2H_Melee_Attack_Spin"
var state_time

var start_animation = 0.7
var end_animation = 1.25

var speed = 14

var speed_scale = 5

var damage_time = (end_animation - start_animation)*1000 / speed_scale

func enter(object_to_run):
	super.enter(object_to_run)
	object.setAnimation(animation_name, speed_scale, start_animation, end_animation)
	state_time = Time.get_ticks_msec()
	
	
func update(_delta:float):
	var current_time = Time.get_ticks_msec() - state_time
	var direction = object.get_direction()
	
	if !Input.is_action_pressed("ui_jump"):
		state_transition.emit("Idle")
		if direction != Vector3.ZERO:
			object.getPivot().basis = Basis.looking_at(direction)
		return
	
	if current_time > damage_time:		
		state_time = Time.get_ticks_msec()
		
		apply_damage()
		
	object.setAnimation(animation_name, speed_scale, start_animation, end_animation)
		
	object.target_velocity = direction * speed
	
func apply_damage():
	var area : Area3D = object.get_signature_area()
	for mob in area.get_overlapping_bodies():
		if mob.is_in_group("mobs"):
			mob.character_sheet.apply_hit(object.character_sheet, attack)
	
	
