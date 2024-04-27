extends Area3D

@export var immolationScene : PackedScene

func get_buff() -> CharacterBuff:
	var buff = immolationScene.instantiate()
	buff.buff_name = "IMMOLATION"
	buff.time = 30	
	return buff
