extends StaticBody2D

export var SPEED = 3
export var never_touched = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  if never_touched:
    position.x = 192
    position.y = -8


func _process(delta):
  if never_touched:
    move_on_belt(delta)


func move_on_belt(delta):
  if position.x == 192 && position.y <= 56:
    position.y += SPEED * delta
  elif position.y == 248 && position.x >= 272:
    queue_free()
  elif position.y >= 248 && position.x <= 272:
    position.y = 248
    position.x += SPEED * delta
  elif position.x <= 16 && position.y < 248:
    position.x = 16
    position.y += SPEED * delta
  elif position.y >= 56 && position.x > 16:
    position.y = 56
    position.x -= SPEED * delta
