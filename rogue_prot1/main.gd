extends Node


@export var mob : PackedScene
@export var mob2 : PackedScene 
@export var mob3 : PackedScene 
@onready var character : CharacterBase = $Character 
@onready var asLabel = $HUD/asLabel
@onready var hpLabel = $HUD/hpLabel
@onready var msLabel = $HUD/msLabel
@onready var fpsLabel = $HUD/fpsLabel
@onready var vbox = $HUD/ColorRect/VBoxContainer

var mobs
var nextMob
# Called when the node enters the scene tree for the first time.
func _ready():
	nextMob = Time.get_ticks_msec() + randi_range(0, 500)
	mobs = [mob, mob2, mob3]
	
	asLabel.text = "AS: " + str(character.get_character_sheet().get_value(constants.CharacterAttributes.ATTACK_SPEED_CHANGE))
	character.get_character_sheet().connect_signal_for_property(constants.CharacterAttributes.ATTACK_SPEED_CHANGE, 
		func(_from, to) : asLabel.text = "AS: " + str(to))
		
	hpLabel.text = "HP: " + str(character.get_character_sheet().get_value(constants.CharacterAttributes.HEALTH_CURRENT))
	character.get_character_sheet().connect_signal_for_property(constants.CharacterAttributes.HEALTH_CURRENT, 
		func(_from, to) : hpLabel.text = "HP: " + str(to))
		
	msLabel.text = "MS: " + str(character.get_character_sheet().get_value(constants.CharacterAttributes.SPEED))
	character.get_character_sheet().connect_signal_for_property(constants.CharacterAttributes.SPEED, 
		func(_from, to) : msLabel.text = "MS: " + str(to))
		
	character.get_character_sheet()._on_append_buff.connect(refresh_buffs)
	character.get_character_sheet()._on_release_buff.connect(refresh_buffs)
	pass # Replace with function body.

func refresh_buffs(_buff):
	for node in vbox.get_children():
		node.queue_free()
	
	for nbuff in character.get_character_sheet().buffs:
		var label = Label.new()
		label.text = nbuff.buff_name
		vbox.add_child(label)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("mob"):
		for i in 10:
			createNewMob()
		nextMob = Time.get_ticks_msec() + randi_range(0, 1000)
	
	fpsLabel.text = str(Engine.get_frames_per_second())
		
func createNewMob():
	var pos = randi_range(0,2)
	var newMob = mobs[pos].instantiate()
	newMob.name = str(Time.get_ticks_msec())
	add_child(newMob)
	newMob.global_position = Vector3(randf_range(-10, 10),1.5,randf_range(-10, 10))
	

