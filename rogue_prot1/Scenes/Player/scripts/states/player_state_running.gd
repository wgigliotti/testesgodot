extends State
class_name PlayerStateRunning

var animation_name = "Running_A"
var speed = 14

func enter(object_to_run):
	super.enter(object_to_run)
	object.setAnimation(animation_name)
	
func update(_delta:float):
	var direction = object.get_direction()
	
	if(direction == Vector3.ZERO):
		state_transition.emit("Idle")
		return
	
	if Input.is_action_just_pressed("ui_jump"):
		state_transition.emit("Signature")
		return	
	
	object.getPivot().basis = Basis.looking_at(direction)
	object.target_velocity = direction * speed
	object.setAnimation(animation_name)	
	
	
