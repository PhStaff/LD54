extends Node2D

var TYPE_BODY = 0
var TYPE_LEGS = 1
var TYPE_ARMS = 2
var TYPE_WEAPONS = 3

@export var type = 0

@export var part_name : String
#@export var sprite : int

@export var combat : int = 0
@export var speed : int = 0
@export var armor : int = 0
@export var weapon_type : int = 0
@export var weight : int = 0
@export var weight_cap : int = 0
@export var price : int = 0


@export var connect_l_leg_x = 0
@export var connect_l_leg_y = 0

@export var connect_l_arm_x = 0
@export var connect_l_arm_y = 0

@export var connect_r_leg_x = 0
@export var connect_r_leg_y = 0

@export var connect_r_arm_x = 0
@export var connect_r_arm_y = 0


@onready var body = $Body
@onready var r_leg = $r_leg
@onready var l_leg = $l_leg
@onready var r_arm = $r_arm
@onready var l_arm = $l_arm
