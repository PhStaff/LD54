extends Node2D

var current_event
var event = preload("res://Events/_event_.tscn")
var event1 = preload("res://Events/_event_1.tscn")
var event2 = preload("res://Events/_event_2.tscn")
var event3 = preload("res://Events/_event_3.tscn")
var event4 = preload("res://Events/_event_4.tscn")
var event5 = preload("res://Events/_event_5.tscn")
var event6 = preload("res://Events/_event_6.tscn")
var event7 = preload("res://Events/_event_7.tscn")
var event8 = preload("res://Events/_event_8.tscn")
var event9 = preload("res://Events/_event_9.tscn")
var event10 = preload("res://Events/_event_10.tscn")

var event_total_no = 10

var current_town
var selected_town = null

var event_prop = 5
var event_counter = 0
var event_limit = 3

var event_break = 20
var event_break_counter = 0

var drain = 30
var drain_counter = 0

var rng = RandomNumberGenerator.new()

func _ready():
	$Player.no_fuel.connect(game_over_fuel)
	$Player.no_food.connect(game_over_food)
	$Player.mech_broke.connect(game_over_broke)
	
	PlayerValues.export_values($Player)
	$Player.update_labels()
	
	set_town_locations()
	$Town_goto.disabled = true
	
	if ($Player.world_location == null):
		$Town_Visit.disabled = true
		$Player.world_location = "Towns/Town_start"
	
	current_town = get_node($Player.world_location)
	current_town.active_town = true
	
	$Player_Node.position = current_town.position
	$Player_Node.reached_target.connect(player_reached_target)

func _process(delta):
	if ($Player_Node.current_speed == 0):
		return
	
	#Take ressource
	drain_counter += 1
	if (drain_counter % drain == 0):
		$Player.food -= 1
		$Player.fuel -= 1
		$Player.update_labels()
	
	#Trigger event
	var random = rng.randi_range(1, 100)
	#print(random)
	event_break_counter += 1
	if (event_break < event_break_counter  and random <= event_prop and event_counter < event_limit):
		event_break_counter = 0
		event_counter += 1
		
		$Player_Node.pause_player()
		
		var new_event = pick_random_event().instantiate()
		new_event.set_player_damage($Player)
		add_child(new_event)
		current_event = new_event
		new_event.won_mission.connect(event_won_mission)
		new_event.failed_mission.connect(event_failed_mission)
		new_event.event_closed.connect(event_closed)

func pick_random_event():
	var random = rng.randi_range(1, event_total_no)
	#current_event = random
	return get_event(random)
	
func get_event(index):
	if (index == 1):
		return event1
	elif (index == 2):
		return event2
	elif (index == 3):
		return event3
	elif (index == 4):
		return event4
	elif (index == 5):
		return event5
	elif (index == 6):
		return event6
	elif (index == 7):
		return event7
	elif (index == 8):
		return event8
	elif (index == 9):
		return event9
	elif (index == 10):
		return event10
	else:
		return event

func player_reached_target(target):
	event_counter = 0
	
	$Town_Visit.disabled = false
	$Player.world_location = target.get_path()

func event_won_mission():
	$Event_Handler.event_won_mission($Player, current_event)

func event_failed_mission():
	$Event_Handler.event_failed_mission($Player, current_event)

func event_closed():
	$Player_Node.move_player()

func set_town_locations():
	var towns = get_node("Towns")
	for town in towns.get_children():
		town.connect("pressed", _on_town_button_down.bind(town.get_path()))
		if (town.next_town_1_name != ""):
			town.next_town_1 = get_node("Towns/" + town.next_town_1_name)
		if (town.next_town_2_name != ""):
			town.next_town_2 = get_node("Towns/" + town.next_town_2_name)
		if (town.next_town_3_name != ""):
			town.next_town_3 = get_node("Towns/" + town.next_town_3_name)
		if (town.next_town_4_name != ""):
			town.next_town_4 = get_node("Towns/" + town.next_town_4_name)
	
func _on_town_button_down(town_name):
	var temp_town = get_node(town_name)
	if (!check_town_reach(temp_town)):
		return
	
	selected_town = temp_town
	$Town_goto.disabled = false

func check_town_reach(town):
	if (current_town.next_town_1 == town):
		return true
	if (current_town.next_town_2 == town):
		return true
	if (current_town.next_town_3 == town):
		return true
	if (current_town.next_town_4 == town):
		return true
	
	return false

func _on_town_goto_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	$Player_Node.target = selected_town
	$Player_Node.move_player()
	
	$Town_goto.disabled = true
	$Town_Visit.disabled = true
	
	current_town.queue_redraw()
	selected_town.queue_redraw()
	
	current_town.active_town = false
	current_town = selected_town
	current_town.active_town = true
	selected_town = null

func _on_town_visit_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	if (current_town.town == "_town_end.tscn"):
		set_game_won_state()
		return
	
	PlayerValues.import_values($Player)
	get_tree().change_scene_to_file(current_town.get_town_path())


func game_over_food():
	set_game_over_state()
	$Game_Over.show_message($Game_Over.NO_FOOD)

func game_over_fuel():
	set_game_over_state()
	$Game_Over.show_message($Game_Over.NO_FUEL)

func game_over_broke():
	set_game_over_state()
	$Game_Over.show_message($Game_Over.MECHA_BROKE)

func set_game_won_state():
	$Game_Finished.show()
	
	frost_game()

func set_game_over_state():
	$Game_Over.show()
	
	frost_game()

func frost_game():
	$Town_goto.disabled = true
	$Town_Visit.disabled = true
	
	$Player_Node.pause_player()
