extends Area3D


func get_buff() -> CharacterBuff:
	var buff = CharacterBuff.new()
	buff.buff_name = "HASTE"
	buff.attributes[constants.CharacterAttributes.ATTACK_SPEED_CHANGE] = 0.20
	
	return buff
