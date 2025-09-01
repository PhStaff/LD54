extends Node

#Resources
var money = 200
var inventory_space = 20

var food = 5
var fuel = 5
var ammo = 5
var spare_parts = 0

#Mecha Stats
var condition = 100

var body_part_path = "res://Parts/_part_body_01.tscn"
var legs_part_path = "res://Parts/_part_body_02.tscn"
var arms_part_path = "res://Parts/_part_body_03.tscn"

var l_arm_sprite = Sprite2D.new()
var l_leg_sprite = Sprite2D.new()
var body_sprite = Sprite2D.new()
var r_leg_sprite = Sprite2D.new()
var r_arm_sprite = Sprite2D.new()


var world_location = null

var job_blacklist = Array()

func instantiate_part(source):
	var part = load(source).instantiate()
	add_child(part)
	part.hide()
	
	return part

func export_values(player):
	player.money = money
	player.inventory_space = inventory_space

	player.food = food
	player.fuel = fuel
	player.ammo = ammo
	player.spare_parts = spare_parts

	#Mecha Stats
	player.condition = condition
	
	var bodyPart = instantiate_part(body_part_path)
	var legsPart = instantiate_part(legs_part_path)
	var armsPart = instantiate_part(arms_part_path)
	
	player.bodyPart = bodyPart
	player.legsPart = legsPart
	player.armsPart = armsPart
	
	player.switch_part_sprite(bodyPart, "Parts_Body")
	player.switch_part_sprite(legsPart, "Parts_Legs")
	player.switch_part_sprite(armsPart, "Parts_Weapons")
	
	player.world_location = world_location


func import_values(player):
	money = player.money
	inventory_space = player.inventory_space

	food = player.food
	fuel = player.fuel
	ammo = player.ammo
	spare_parts = player.spare_parts

	#Mecha Stats
	condition = player.condition
	
	body_part_path = player.bodyPart.scene_file_path
	legs_part_path = player.legsPart.scene_file_path
	arms_part_path = player.armsPart.scene_file_path
	
	body_sprite.set_texture(player.body_sprite.get_texture())
	l_arm_sprite.set_texture(player.l_arm_sprite.get_texture())
	r_arm_sprite.set_texture(player.r_arm_sprite.get_texture())
	l_leg_sprite.set_texture(player.l_leg_sprite.get_texture())
	r_leg_sprite.set_texture(player.r_leg_sprite.get_texture())
	
	world_location = player.world_location
