extends StaticBody2D

export var SPEED = 3
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  position.x = 192
  position.y = -8


func _process(delta):
  if position.x == 192 && position.y <= 56:
    position.y += SPEED * delta
  if position.y >= 56 && position.x >= 24:
    position.y == 56
    position.x -= SPEED * delta
  if position.x <= 24 && position.y <= 248:
    position.x = 24
    position.y += SPEED * delta
