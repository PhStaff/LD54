extends Node2D


var NO_FOOD = 0
var NO_FUEL = 1
var MECHA_BROKE = 2

func _ready():	
	$No_Fuel.get_label_settings().font_color = Color.DIM_GRAY
	$No_Food.get_label_settings().font_color = Color.DIM_GRAY
	$Mecha_Broke.get_label_settings().font_color = Color.DIM_GRAY

func _on_button_button_down():
	get_tree().quit()

func show_message(cause):
	if (cause == NO_FUEL):
		$No_Fuel.get_label_settings().font_color = Color.WHITE
	elif (cause == NO_FOOD):
		$No_Food.get_label_settings().font_color = Color.WHITE
	elif (cause == MECHA_BROKE):
		$Mecha_Broke.get_label_settings().font_color = Color.WHITE
