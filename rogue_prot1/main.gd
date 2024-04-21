extends Node


@export var mob : PackedScene
@export var mob2 : PackedScene 
@export var mob3 : PackedScene 
var mobs
var nextMob
# Called when the node enters the scene tree for the first time.
func _ready():
	nextMob = Time.get_ticks_msec() + randi_range(0, 500)
	mobs = [mob, mob2, mob3]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("mob"):
		for i in 10:
			createNewMob()
		nextMob = Time.get_ticks_msec() + randi_range(0, 1000)
		
func createNewMob():
	var pos = randi_range(0,2)
	var newMob = mobs[pos].instantiate()
	newMob.name = str(Time.get_ticks_msec())
	add_child(newMob)
	newMob.global_position = Vector3(randf_range(-10, 10),1.5,randf_range(-10, 10))
	
