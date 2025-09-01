extends TextureButton

@export var next_town_1_name : String
@export var next_town_2_name : String
@export var next_town_3_name : String
@export var next_town_4_name : String

@export var town : String = "_town_1.tscn"

var next_town_1 = null
var next_town_2 = null
var next_town_3 = null
var next_town_4 = null

var active_town = false

func _ready():
	$Town_Name.text = get_path()

func _draw():
	if (!active_town):
		return
	
	if (next_town_1 != null):
		draw_line(Vector2(0, 0), next_town_1.position - position, Color.AQUA)
	if (next_town_2 != null):
		draw_line(Vector2(0, 0), next_town_2.position - position, Color.AQUA)
	if (next_town_3 != null):
		draw_line(Vector2(0, 0), next_town_3.position - position, Color.AQUA)
	if (next_town_4 != null):
		draw_line(Vector2(0, 0), next_town_4.position - position, Color.AQUA)

func get_town_path():
	return "res://Towns/" + town
