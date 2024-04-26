extends Node
class_name BaseConstants

enum PlayerCommandEnum { SIGNATURE, ABILITY_A, ABILITY_B, ABILITY_C, NEXT_CARD, CARD_ACCEPT, NONE }

enum AttackType { HIT, DOT }

enum CharacterAttributes {
	NAME,
	HEALTH_CURRENT,
	HEALTH_MAX,
	HEALTH_REGEN,
	
	MANA_CURRENT,
	MANA_MAX,
	MANA_REGEN,
	
	SPEED,
	
	ATTACK_SPEED_CHANGE,
	
	DAMAGE_CHANGE,	
	MAGIC_DAMAGE_CHANGE,
	MAGIC_RESISTANCE,
		
	PHYSICAL_DAMANGE_CHANGE,
	PHYSICAL_RESISTANCE,	
	
	CRITICAL_DAMAGE_CHANCE_CHANGE,
	CRITICAL_DAMAGE_CHANGE,
	
	DISTANCE_VISION,
	
	RANGE_CHANGE,
	AREA_CHANGE
}

var defaultAtt : Dictionary = {
	CharacterAttributes.NAME : "",
	CharacterAttributes.HEALTH_CURRENT: 0,
	CharacterAttributes.HEALTH_MAX: 0,
	CharacterAttributes.HEALTH_REGEN: 0,
	
	CharacterAttributes.MANA_CURRENT: 0,
	CharacterAttributes.MANA_MAX: 0,
	CharacterAttributes.MANA_REGEN: 0,
	
	CharacterAttributes.MAGIC_RESISTANCE : 0.1,
	CharacterAttributes.PHYSICAL_RESISTANCE : 0.1,		
	
	CharacterAttributes.DISTANCE_VISION: 500

}
