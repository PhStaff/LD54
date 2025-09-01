extends Node2D

@onready var player: = $Player

@export var leave_to : String = ""

var current_part = null
var current_part_weight = 0
var previous_part = null

var current_money = 0
var current_inventory_use = 0

var temp_food = 0
var temp_fuel = 0
var temp_ammo = 0

var food_price = 5
var fuel_price = 5
var ammo_price = 5


#TODO Add repair button

func _ready():
	PlayerValues.export_values($Player)
	$Player.update_labels()
	
	$Panel/Weight_warn.get_label_settings().font_color = Color.DIM_GRAY
	$Panel/Inventory_war.get_label_settings().font_color = Color.DIM_GRAY
	$Panel/Money_war.get_label_settings().font_color = Color.DIM_GRAY

#Clearing fields
func clear_parts_list():
	$Player.update_labels()
	
	var preview = get_node("Preview")
	preview.hide()
	
	var partsButtons = get_node("PartShop/Parts/VBoxContainer")
	for button in partsButtons.get_children():
		partsButtons.remove_child(button)
	
	$Panel/Weight_warn.get_label_settings().font_color = Color.DIM_GRAY
	$Panel/Inventory_war.get_label_settings().font_color = Color.DIM_GRAY
	$Panel/Money_war.get_label_settings().font_color = Color.DIM_GRAY
	
	reset_player_sprite()

func reset_player_sprite():
	if (previous_part == null):
		return
	
	if (previous_part.type == 0):
		$Player.switch_part_sprite(previous_part, "Parts_Body")
	elif (previous_part.type == 1):
		$Player.switch_part_sprite(previous_part, "Parts_Legs")
	elif (previous_part.type == 2):
		$Player.switch_part_sprite(previous_part, "Parts_Weapons")

func clear_items():
	current_inventory_use = 0
	temp_food = 0
	temp_fuel = 0
	temp_ammo = 0
	
	$ItemShop/Food_sum.set_text(str(0))
	$ItemShop/Fuel_sum.set_text(str(0))
	$ItemShop/Ammo_sum.set_text(str(0))
	$ItemShop/Total_Price.set_text(str(0))
	
	$Player/Items/Food_val.get_label_settings().font_color = Color.WHITE
	$Player/Items/Fuel_val.get_label_settings().font_color = Color.WHITE
	$Player/Items/Ammo_val.get_label_settings().font_color = Color.WHITE

#Parts management
func _on_body_parts_button_down():
	parts_buttons("Parts_Body")

func _on_leg_parts_button_down():
	parts_buttons("Parts_Legs")

func _on_arm_parts_button_down():
	parts_buttons("Parts_Arms")

func _on_weapons_button_down():
	parts_buttons("Parts_Weapons")

func parts_buttons(region):
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	clear_parts_list()
	clear_items()
	
	#Show all buyable parts
	var partsButtons = get_node("PartShop/Parts/VBoxContainer")
	var parts = get_node(region)
	for part in parts.get_children():
		var button := Button.new()
		button.text = str(part.part_name)
		partsButtons.add_child(button)
		
		button.connect("pressed", _on_custom_part_button.bind(part.get_path(), region))

func _on_custom_part_button(part_path, region):
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	current_part = get_node(part_path)
	
	#Show preview
	var preview = get_node("Preview")
	preview.show()
	$Preview/Name_val.set_text(str(current_part.part_name))
	$Preview/Cost_val.set_text(str(current_part.price))
	$Preview/Armor_val.set_text(str(current_part.armor))
	$Preview/Damage_val.set_text(str(current_part.combat))
	$Preview/Weight_val.set_text(str(current_part.weight))
	$Preview/WeightCap_val.set_text(str(current_part.weight_cap))
	
	if (current_part.type == 0):
		$Preview/Type_val.set_text("Body")
	elif (current_part.type == 1):
		$Preview/Type_val.set_text("Legs")
	elif (current_part.type == 2):
		$Preview/Type_val.set_text("Arms")
	elif (current_part.type == 3):
		$Preview/Type_val.set_text("Weapon")
	
	#Update money
	current_money = $Player.money - current_part.price
	update_label($Player.money, $Player/Items/Money_val, current_money, 1)
	
	#Update stats
	current_part_weight = $Player.get_weight()
	current_part_weight += current_part.weight
	var current_weight_cap = $Player.legsPart.weight_cap
	
	$Player.switch_part_sprite(current_part, region)
	if (region == "Parts_Body"):
		previous_part = $Player.bodyPart
		current_part_weight -= $Player.bodyPart.weight
		
		update_label($Player.bodyPart.armor, $Player/Mecha/Armor_val, current_part.armor, 1)
	elif (region == "Parts_Legs"):
		previous_part = $Player.legsPart
		current_part_weight -= $Player.legsPart.weight
		current_weight_cap = current_part.weight_cap
		
		update_label($Player.legsPart.weight_cap, $Player/Mecha/WeightCap_val, current_part.weight_cap, 1)
	elif (region == "Parts_Arms"):
		previous_part = $Player.armsPart
		current_part_weight -= $Player.armsPart.weight
		
		update_label($Player.armsPart.combat, $Player/Mecha/Damage_val, current_part.combat, 1)
	elif (region == "Parts_Weapons"):
		previous_part = $Player.armsPart
		current_part_weight -= $Player.armsPart.weight
		
		update_label($Player.armsPart.combat, $Player/Mecha/Damage_val, current_part.combat, 1)
	
	#Checking weight
	update_label($Player.get_weight(), $Player/Mecha/Weight_val, current_part_weight, -1)
	
	check_buy_button(current_weight_cap)

func check_buy_button(current_weight_cap):
	$Panel/Weight_warn.get_label_settings().font_color = Color.DIM_GRAY
	$Panel/Inventory_war.get_label_settings().font_color = Color.DIM_GRAY
	$Panel/Money_war.get_label_settings().font_color = Color.DIM_GRAY
	
	$Preview/Buy.disabled = false
	$ItemShop/Buy_Items.disabled = false
	if (current_money < 0):
		$Preview/Buy.disabled = true
		$ItemShop/Buy_Items.disabled = true
		$Panel/Money_war.get_label_settings().font_color = Color.RED
	#if ($Player.legsPart.weight_cap < $Player.get_weight()):
	if (current_weight_cap < current_part_weight):
		$Preview/Buy.disabled = true
		$ItemShop/Buy_Items.disabled = true
		$Panel/Weight_warn.get_label_settings().font_color = Color.RED
	if ($Player.inventory_space < current_inventory_use):
		$Preview/Buy.disabled = true
		$ItemShop/Buy_Items.disabled = true
		$Panel/Inventory_war.get_label_settings().font_color = Color.RED

func update_label(player_val, label, temp_val, sign_val):
	label.set_text(str(temp_val) + "  (" + str(temp_val - player_val) + ")")
	if (player_val * sign_val < temp_val * sign_val):
		label.get_label_settings().font_color = Color.GREEN
	elif (player_val == temp_val):
		label.get_label_settings().font_color = Color.WHITE
	else:
		label.get_label_settings().font_color = Color.RED

func _on_back_button_down():
	clear_parts_list()
	clear_items()

func _on_buy_button_down():
	Soundplayer.play_sound(Soundplayer.CASH)
	
	previous_part = null
	
	if (current_part.type == 0):
		$Player.bodyPart = current_part
	elif (current_part.type == 1):
		$Player.legsPart = current_part
	elif (current_part.type == 2):
		$Player.armsPart = current_part
	elif (current_part.type == 3):
		$Player.armsPart = current_part
	
	$Player.money -= current_part.price
	
	clear_parts_list()
	clear_items()

#Item management
func _on_neg_button_down(product):
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	if (product == 0):
		if (0 >= temp_food):
			return
		
		temp_food -= 1
	elif (product == 1):
		if (0 >= temp_fuel):
			return
		
		temp_fuel -= 1
	elif (product == 2):
		if (0 >= temp_ammo):
			return
		
		temp_ammo -= 1
	
	clear_parts_list()
	update_items(product)

func _on_pos_button_down(product):
	Soundplayer.play_sound(Soundplayer.BUTTON)
	
	if (product == 0):
		temp_food += 1
	elif (product == 1):
		temp_fuel += 1
	elif (product == 2):
		temp_ammo += 1
	
	clear_parts_list()
	update_items(product)

func update_items(product):
	var item_sum = temp_food + temp_fuel + temp_ammo
	var item_price = 0
	item_price += temp_food * food_price
	item_price += temp_fuel * fuel_price
	item_price += temp_ammo * ammo_price
	
	check_item_limits(item_sum, item_price)
	
	$ItemShop/Food_sum.set_text(str(temp_food))
	$Player/Items/Food_val.set_text(str($Player.food + temp_food))
	$ItemShop/Fuel_sum.set_text(str(temp_fuel))
	$Player/Items/Fuel_val.set_text(str($Player.fuel + temp_fuel))
	$ItemShop/Ammo_sum.set_text(str(temp_ammo))
	$Player/Items/Ammo_val.set_text(str($Player.ammo + temp_ammo))
	
	if (product == 0):
		$Player/Items/Food_val.get_label_settings().font_color = Color.GREEN
	elif (product == 1):
		$Player/Items/Fuel_val.get_label_settings().font_color = Color.GREEN
	elif (product == 2):
		$Player/Items/Ammo_val.get_label_settings().font_color = Color.GREEN
		
	$ItemShop/Total_Price.set_text(str(item_price))
	check_buy_button($Player.legsPart.weight_cap)

func check_item_limits(item_sum, price):
	current_part_weight = $Player.get_weight()
	current_part_weight += item_sum
	update_label($Player.get_weight(), $Player/Mecha/Weight_val, current_part_weight, -1)
	
	current_inventory_use = $Player.get_inventory_used()
	current_inventory_use += item_sum
	update_label($Player.get_inventory_used(), $Player/Items/Inventory_val, current_inventory_use, -1)
	
	current_money = $Player.money - price
	update_label($Player.money, $Player/Items/Money_val, current_money, 1)

func _on_buy_items_button_down():
	Soundplayer.play_sound(Soundplayer.CASH)
	
	$Player.food += temp_food
	$Player.money -= temp_food * food_price
	$Player.fuel += temp_fuel
	$Player.money -= temp_fuel * fuel_price
	$Player.ammo += temp_ammo
	$Player.money -= temp_ammo * ammo_price
	
	clear_parts_list()
	clear_items()

#Leave shop
func _on_leave_button_down():
	Soundplayer.play_sound(Soundplayer.BUTTON)
	reset_player_sprite()
	
	PlayerValues.import_values($Player)
	
	if (leave_to == ""):
		get_tree().change_scene_to_file("res://World/world.tscn")
	else:
		get_tree().change_scene_to_file("res://Towns/" + leave_to)
