extends State
class_name PlayerStateSignature

var animation_name = "2H_Melee_Attack_Spin"
var state_time

var start_animation = 0.7
var end_animation = 1.25
var speed = 14

var speed_scale = 3
var state_timeout = 500 / speed_scale

var damage_time = 500
var damage = false

func enter(object_to_run):
	super.enter(object_to_run)
	object.setAnimation(animation_name, speed_scale, start_animation, end_animation)
	state_time = Time.get_ticks_msec()
	#object.target_velocity = Vector3.ZERO
	damage = false
	
func update(_delta:float):
	var current_time = Time.get_ticks_msec() - state_time
	var direction = object.get_direction()
	#if current_time > state_timeout:
		#state_transition.emit("Idle")
		#return
	if !Input.is_action_pressed("ui_jump"):
		state_transition.emit("Idle")
		if direction != Vector3.ZERO:
			object.getPivot().basis = Basis.looking_at(direction)
		return
	
	if current_time > damage_time and damage != false:
		damage = true
		apply_damage()
		
	object.setAnimation(animation_name, speed_scale, start_animation, end_animation)
		
	object.target_velocity = direction * speed
	
func apply_damage():
	pass
	
	
	
