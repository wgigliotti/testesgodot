extends Node
class_name PlayerCommands

var _player_commands_dict = {
	constants.PlayerCommandEnum.SIGNATURE: "ui_signature",
	constants.PlayerCommandEnum.ABILITY_A: "ui_ability_a",
	constants.PlayerCommandEnum.ABILITY_B: "ui_ability_b",
	constants.PlayerCommandEnum.ABILITY_C: "ui_ability_c",
	constants.PlayerCommandEnum.NEXT_CARD: "ui_next_card",
	constants.PlayerCommandEnum.CARD_ACCEPT: "ui_card_accept",
}

func getDirections() -> Vector3:
	var newdirection = Vector3.ZERO
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("ui_right"):
		newdirection.x += Input.get_action_strength("ui_right")
	if Input.is_action_pressed("ui_left"):
		newdirection.x -= Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_down"):
		newdirection.z += Input.get_action_strength("ui_down")
	if Input.is_action_pressed("ui_up"):
		newdirection.z -= Input.get_action_strength("ui_up")
	
	if newdirection != Vector3.ZERO:
		if	newdirection.length_squared() > 1:
			newdirection = newdirection.normalized()
	return newdirection

func getCommandJustPressed() -> constants.PlayerCommandEnum:	
	for command in constants.PlayerCommandEnum.values():
		if command != constants.PlayerCommandEnum.NONE and Input.is_action_just_pressed(_player_commands_dict[command]):
			return command
	return constants.PlayerCommandEnum.NONE
	
func isCommandPressed(command: constants.PlayerCommandEnum):
	return Input.is_action_pressed(_player_commands_dict[command])
