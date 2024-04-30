extends BaseTargetProjectile


func hit_target():
	#var slow : CharacterBuff = CharacterBuff.new()
	#slow.buff_name = "Slow"
	#slow.attributes[constants.CharacterAttributes.SPEED] = -0.10	
	#slow.attributes[constants.CharacterAttributes.ATTACK_SPEED_CHANGE] = -0.05
	#slow.time = 3	
	#
	#target.get_character_sheet().append_buff(slow)
	RulesBook.apply_attack(actor.get_character_sheet(), target.get_character_sheet(), attack )
	
	
