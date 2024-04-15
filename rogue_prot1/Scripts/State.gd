@icon("res://arts/icons/STATE.png")
extends Node
class_name State


signal state_transition
var object 

func enter(object_to_run):
	object = object_to_run
	
func exit():
	pass
	
func update(_delta:float):
	pass
