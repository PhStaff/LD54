extends CharacterBody2D

signal reached_target()

var STATE_WAITING = 0
var STATE_MOVING = 1
var STATE_PAUSING = 2
var state = STATE_WAITING

var speed = 100
var current_speed = 0

var target = null

func _physics_process(delta):
	if (target == null):
		return
	
	velocity = position.direction_to(target.position) * current_speed
	# look_at(target)
	if (position.distance_to(target.position) > 10):
		move_and_slide()
	else:
		reached_target.emit(target)
		target = null
		pause_player()

func pause_player():
	current_speed = 0

func move_player():
	current_speed = speed
