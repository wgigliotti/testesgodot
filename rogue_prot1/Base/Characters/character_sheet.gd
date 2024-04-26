extends Node
class_name CharacterSheet

signal _on_append_buff(buff : CharacterBuff)
signal _on_release_buff(buff : CharacterBuff)

var sheet : Dictionary = {}
var base_sheet : Dictionary
@export var sheet_data : JSON


var signals : Dictionary = {}
var buffs : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	base_sheet = sheet_data.data.duplicate(true)
	for key in base_sheet.keys():
		sheet[constants.CharacterAttributes[key]] = base_sheet[key]
	
	
func connect_signal_for_property(property_name, callable : Callable):
	if !signals.has(property_name):		
		var new_signal_for = Signal(self, "_signal_" + str(property_name))
		add_user_signal(new_signal_for.get_name())
		signals[property_name] = new_signal_for
	
	var signal_to_connect = signals[property_name]
	signal_to_connect.connect(callable)
	
	return signals[property_name]
	
func set_value(attribute : constants.CharacterAttributes, value):
	if ! sheet.has(attribute):
		sheet[attribute] = RulesBook.get_default_attribute(attribute)
	
	if sheet[attribute] != value:
		var old_value = sheet[attribute]
		sheet[attribute] = value
		
		if signals.has(attribute):			
			signals[attribute].emit(old_value, value)
		
func get_value(attribute : constants.CharacterAttributes):
	if ! sheet.has(attribute):
		sheet[attribute] = RulesBook.get_default_attribute(attribute)
		push_warning("%s Character Sheet without attribute %s, returning default value" % [sheet[constants.CharacterAttributes.NAME], str(attribute)])
	
	return sheet[attribute]
	
func _apply_buff(buff : CharacterBuff, increment : bool):
	for attribute in buff.attributes.keys():
		var increment_func = RulesBook.get_increment_for(attribute)
		var old_value = get_value(attribute)
		var new_value = increment_func.call(old_value, buff.attributes[attribute], increment)
		set_value(attribute, new_value)
	
func append_buff(buff : CharacterBuff):	
	buffs.append(buff)
	buff.attach(self)
	_apply_buff(buff, true)
	_on_append_buff.emit(buff)

func remove_buff(buff : CharacterBuff):		
	for index in buffs.size():
		if buffs[index] == buff:
			buffs.remove_at(index)
			break
	_apply_buff(buff, false)
	_on_release_buff.emit(buff)	
		
	
