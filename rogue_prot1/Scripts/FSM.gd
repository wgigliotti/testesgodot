@icon("res://arts/icons/FSM.png")
extends Node
class_name FiniteStateMachine

var states : Dictionary = {}
var current_state : State
var object

@export var initial_state : State
@export var auto_run : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
		
func start_running(object_to_run):
	object = object_to_run
	if initial_state:
		initial_state.enter(object)
		current_state = initial_state
		
func change_state(new_state_name : String):
	if current_state != null and current_state.name == new_state_name:	
		return
	print(new_state_name)
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		push_warning(new_state_name + " does not exists!")		
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter(object)
	
	current_state = new_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if auto_run:
		run(delta)

func run(delta):	
	if current_state:
		current_state.update(delta)
