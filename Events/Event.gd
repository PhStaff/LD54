extends Node2D

signal won_mission()
signal failed_mission()
signal event_closed()

@onready var description: = $Panel/Description
@onready var declined: = $Panel/Declined
@onready var win: = $Panel/Win
@onready var fail: = $Panel/Fail

@onready var accept: = $Panel/Accept
@onready var decline: = $Panel/Decline
@onready var close: = $Panel/Close


@export var event_name = ""
@export var difficulty = 10

@export var win_money : int = 0
@export var win_food : int = 0
@export var win_fuel : int = 0
@export var win_ammo : int = 0
@export var win_condition : int = 0

@export var fail_money : int = 0
@export var fail_food : int = 0
@export var fail_fuel : int = 0
@export var fail_ammo : int = 0
@export var fail_condition : int = 0

@export var decline_money : int = 0
@export var decline_food : int = 0
@export var decline_fuel : int = 0
@export var decline_ammo : int = 0
@export var decline_condition : int = 0

var player_damage = 0

func _ready():
	if is_instance_valid($Hidden_Text/Hidden_Description):
		description.text = $Hidden_Text/Hidden_Description.text
	if is_instance_valid($Hidden_Text/Hidden_Declined):
		declined.text = $Hidden_Text/Hidden_Declined.text
	if is_instance_valid($Hidden_Text/Hidden_Win):
		win.text = $Hidden_Text/Hidden_Win.text
	if is_instance_valid($Hidden_Text/Hidden_Fail):
		fail.text = $Hidden_Text/Hidden_Fail.text

func set_player_damage(player):
	player_damage = player.armsPart.combat + player.ammo

func _on_accept_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	description.hide()
	accept.hide()
	decline.hide()
	
	close.show()
	
	var win_mission = true
	win_mission = player_damage > difficulty
	
	if (win_mission):
		win.show()
		won_mission.emit()
	else:
		fail.show()
		failed_mission.emit()


func _on_decline_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	description.hide()
	accept.hide()
	decline.hide()
	
	declined.show()
	close.show()


func _on_close_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	event_closed.emit()
	queue_free()
