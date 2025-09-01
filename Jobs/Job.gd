extends Node2D

@export var job_name : String
@export var event_index : int = 0

var event

func _ready():
	if (event_index == 0):
		event = preload("res://Events/_job_event_1.tscn")
	elif (event_index == 1):
		event = preload("res://Events/_job_event_1.tscn")
	elif (event_index == 2):
		event = preload("res://Events/_job_event_2.tscn")
	elif (event_index == 3):
		event = preload("res://Events/_job_event_3.tscn")
	elif (event_index == 4):
		event = preload("res://Events/_job_event_4.tscn")
	elif (event_index == 5):
		event = preload("res://Events/_job_event_5.tscn")
	elif (event_index == 6):
		event = preload("res://Events/_job_event_6.tscn")
	elif (event_index == 7):
		event = preload("res://Events/_job_event_7.tscn")
	elif (event_index == 8):
		event = preload("res://Events/_job_event_8.tscn")
	elif (event_index == 9):
		event = preload("res://Events/_job_event_9.tscn")
	else:
		event = preload("res://Events/_event_.tscn")

func activate_event():
	return event
