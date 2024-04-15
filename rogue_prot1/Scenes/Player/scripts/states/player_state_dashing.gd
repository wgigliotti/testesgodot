extends State
class_name PlayerStateDashing

var animation_name = "Running_A"
var dashing_time

var dashing_max_time = 500
var dashing_velocity = 40

func enter(object_to_run):
	super.enter(object_to_run)
	object.setAnimation(animation_name)
	dashing_time = Time.get_ticks_msec()
	
	var direction = object.get_direction()
	object.target_velocity = direction * dashing_velocity
	
	
func update(_delta:float):
	if (Time.get_ticks_msec() - dashing_time) > dashing_max_time:
		state_transition.emit("Idle")
		return
		
	object.setAnimation(animation_name)
	object.getPivot().rotation.x = -PI/6
	
	
	
	
