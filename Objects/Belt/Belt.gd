extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
  for sprite in get_children():
    sprite.frame = 0
    sprite.playing = true

func set_speed(speed):
  for sprite in get_children():
    sprite.speed_scale = speed
