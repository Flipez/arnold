extends StaticBody2D

export var SPEED = 3
var hold_by_player = false
var player = null
export var never_touched = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#add_to_group ( "collectables", persistent=true )
  if never_touched:
    position.x = 192
    position.y = -8


func _process(delta):
  if never_touched:
    move_on_belt(delta)
  if hold_by_player:
    stick_to_player(delta)


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


func stick_to_player(delta):
  position.x = player.position.x + cos(player.rotation - PI/2) * 13
  position.y = player.position.y + sin(player.rotation - PI/2) * 13
  look_at(player.position)
#position = point + vector2(cos(angle), sin(angle))* distance
#position = point + (position-point).rotated(angle)

func _on_InteractionArea_area_entered(area):
  hold_by_player = true
  never_touched = false
  player = area.get_parent()
  #var pos_area = area.get_global_position()
  #var relative_position = Vector2.ZERO
  #relative_position.x = position.x - pos_area.x
  #relative_position.y = position.y - pos_area.y
#  print('create yay')
#  prints(relative_position.x, position.x, pos_area.x)
#  prints(relative_position.y, position.y, pos_area.y)


func _on_InteractionArea_area_exited(area):
  hold_by_player = false
  pass
