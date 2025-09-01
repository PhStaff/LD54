extends Node2D

signal no_fuel()
signal no_food()
signal mech_broke()


var world_location = null

#Start value defined in Player_values
#Resources
var money = 0
var inventory_space = 0

var food = 0
var fuel = 0
var ammo = 0
var spare_parts = 0

#Mecha
var condition = 0

@onready var bodyPart: = $Parts/body
@onready var legsPart: = $Parts/legs
@onready var armsPart: = $Parts/arms

@onready var body_sprite: = $Sprite/body
@onready var l_leg_sprite: = $Sprite/l_leg
@onready var r_leg_sprite: = $Sprite/r_leg
@onready var l_arm_sprite: = $Sprite/l_arm
@onready var r_arm_sprite: = $Sprite/r_arm

@onready var parts: = $Parts

func _ready():
	update_labels()
	init_sprite()

	set_sprite_positions(bodyPart, legsPart, armsPart)

func init_sprite():
	switch_part_sprite(bodyPart, "Parts_Body")
	switch_part_sprite(armsPart, "Parts_Legs")
	switch_part_sprite(legsPart, "Parts_Weapons")

func _process(delta):
	if (fuel == 0):
		no_fuel.emit()
	if (food == 0):
		no_food.emit()
	if (condition == 0):
		mech_broke.emit()
	
	queue_redraw()

func update_labels():
	$Mecha/Cond_val.set_text(str(condition))
	$Mecha/Armor_val.set_text(str(bodyPart.armor))
	$Mecha/Damage_val.set_text(str(armsPart.combat))
	$Mecha/Weight_val.set_text(str(get_weight()))
	$Mecha/WeightCap_val.set_text(str(legsPart.weight_cap))
	
	$Items/Money_val.set_text(str(money))
	$Items/Ammo_val.set_text(str(ammo))
	$Items/Fuel_val.set_text(str(fuel))
	$Items/Food_val.set_text(str(food))
	$Items/Inventory_val.set_text(str(get_inventory_used()))
	$Items/InventoryCap_val.set_text(str(inventory_space))
	
	$Mecha/Cond_val.get_label_settings().font_color = Color.WHITE
	$Mecha/Armor_val.get_label_settings().font_color = Color.WHITE
	$Mecha/Damage_val.get_label_settings().font_color = Color.WHITE
	$Mecha/Weight_val.get_label_settings().font_color = Color.WHITE
	$Mecha/WeightCap_val.get_label_settings().font_color = Color.WHITE
	
	$Items/Money_val.get_label_settings().font_color = Color.WHITE
	$Items/Food_val.get_label_settings().font_color = Color.WHITE
	$Items/Fuel_val.get_label_settings().font_color = Color.WHITE
	$Items/Ammo_val.get_label_settings().font_color = Color.WHITE
	$Items/Inventory_val.get_label_settings().font_color = Color.WHITE

func get_weight():
	var value = 0
	value += bodyPart.weight
	value += armsPart.weight
	value += legsPart.weight
	
	value += food
	value += fuel
	value += ammo
	value += spare_parts
	
	return value

func get_inventory_used():
	var value = 0
	value += food
	value += fuel
	value += ammo
	value += spare_parts
	
	return value

func set_sprite_positions(body, legs, arms):
	l_arm_sprite.position.x = body.connect_l_arm_x + arms.l_arm.position.x
	l_arm_sprite.position.y = body.connect_l_arm_y + arms.l_arm.position.y
	
	l_leg_sprite.position.x = body.connect_l_leg_x + legs.l_leg.position.x
	l_leg_sprite.position.y = body.connect_l_leg_y + legs.l_leg.position.y
	
	r_arm_sprite.position.x = body.connect_r_arm_x + arms.r_arm.position.x
	r_arm_sprite.position.y = body.connect_r_arm_y + arms.r_arm.position.y
	
	r_leg_sprite.position.x = body.connect_r_leg_x + legs.r_leg.position.x
	r_leg_sprite.position.y = body.connect_r_leg_y + legs.r_leg.position.y

func switch_part_sprite(new_part, region):
	if (region == "Parts_Body"):
		body_sprite.set_texture(new_part.body.get_texture())
		
		set_sprite_positions(new_part, legsPart, armsPart)
	elif (region == "Parts_Legs"):
		l_leg_sprite.set_texture(new_part.l_leg.get_texture())
		r_leg_sprite.set_texture(new_part.r_leg.get_texture())
		
		set_sprite_positions(bodyPart, new_part, armsPart)
	elif (region == "Parts_Weapons"):
		l_arm_sprite.set_texture(new_part.l_arm.get_texture())
		r_arm_sprite.set_texture(new_part.r_arm.get_texture())
		
		set_sprite_positions(bodyPart, legsPart, new_part)
	
	queue_redraw()
