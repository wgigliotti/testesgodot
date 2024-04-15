extends State
class_name PlayerStateIdle

var animation_name = "Idle"

func enter(object_to_run):
	super.enter(object_to_run)
	object.setAnimation(animation_name)
	
func update(_delta:float):
	var direction = object.get_direction()
	
	if Input.is_action_just_pressed("ui_jump"):
		state_transition.emit("Signature")
		return	
	
	if(direction != Vector3.ZERO):
		print(direction)
		state_transition.emit("Running")
		return
		
	
	
	object.target_velocity = Vector3.ZERO
	object.setAnimation(animation_name)
