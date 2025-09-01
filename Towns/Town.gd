extends Node2D

@export var town_shop : String = "_shop_1.tscn"
@export var town_name : String = "Town 1"
@export var last_town : bool = false

var current_event
var current_job

var jobs_hidden = true

func _ready():
	PlayerValues.export_values($Player)
	$Player.update_labels()
	
	$Player.no_fuel.connect(game_over_fuel)
	$Player.no_food.connect(game_over_food)
	$Player.mech_broke.connect(game_over_broke)
	
	$Name_Label.text = town_name
	
	if (last_town):
		$Shop.hide()
	
	add_jobs()


func event_won_mission():
	$Event_Handler.event_won_mission($Player, current_event)
	remove_event()

func event_failed_mission():
	$Event_Handler.event_failed_mission($Player, current_event)
	remove_event()

func remove_event():
	PlayerValues.job_blacklist.append(town_name + str(current_job))
	
	var temp_node = get_node("Job_List/VBoxContainer/" + str(current_job))
	$Job_List/VBoxContainer.remove_child(temp_node)


func event_closed():
	disable_jobs(false)
	disable_buttons(false)

func _on_jobs_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	if (jobs_hidden):
		$Job_List.show()
	else:
		$Job_List.hide()
	
	jobs_hidden = !jobs_hidden

func add_jobs():
	var job_Buttons = get_node("Job_List/VBoxContainer")
	var job_offers = get_node("Job_Offers")
	for job in job_offers.get_children():
		if (PlayerValues.job_blacklist.has(town_name + str(job.get_index()))):
			continue
		
		var button := Button.new()
		button.text = str(job.job_name)
		job_Buttons.add_child(button)
		button.name = str(button.get_index())
		
		button.connect("pressed", _on_job_button.bind(job.name))

func _on_job_button(job_name):
	var job = get_node("Job_Offers/" + job_name)
	var new_event = job.activate_event().instantiate()
	new_event.set_player_damage($Player)
	add_child(new_event)
	
	current_event = new_event
	current_job = job.get_index()
	
	new_event.won_mission.connect(event_won_mission)
	new_event.failed_mission.connect(event_failed_mission)
	new_event.event_closed.connect(event_closed)
	
	disable_jobs(true)
	disable_buttons(true)

func disable_jobs(val):
	#TODO Maybe hide jobs
	var job_Buttons = get_node("Job_List/VBoxContainer")
	for button in job_Buttons.get_children():
		button.disabled = val


func _on_shop_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	get_tree().change_scene_to_file("res://shops/" + town_shop)

func _on_world_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	PlayerValues.import_values($Player)
	get_tree().change_scene_to_file("res://World/world.tscn")


func game_over_food():
	set_game_over_state()
	$Game_Over.show_message($Game_Over.NO_FOOD)

func game_over_fuel():
	set_game_over_state()
	$Game_Over.show_message($Game_Over.NO_FUEL)

func game_over_broke():
	set_game_over_state()
	$Game_Over.show_message($Game_Over.MECHA_BROKE)

func set_game_over_state():
	$Game_Over.show()
	
	disable_jobs(true)
	disable_buttons(true)

func disable_buttons(value):
	$Shop.disabled = value
	$Jobs.disabled = value
	$World.disabled = value
