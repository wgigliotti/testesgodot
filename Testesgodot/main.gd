extends Node3D

@onready var fpsLabel = $HUD/fpsLabel
var ct = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fpsLabel.text = str(Engine.get_frames_per_second())
	pass


func _on_timer_timeout():
	#$MultiplayerSpawner.clear_spawnable_scenes()
	
		
	for i in 200:
		ct +=1
		print(ct)
		var sphere = preload("res://Mob.tscn").instantiate()		
		sphere.position = Vector3(randf_range(-500,500), 0, randf_range(-500,500))
		sphere.name = str(randi())
		add_child(sphere, true)
	$Timer.start()
