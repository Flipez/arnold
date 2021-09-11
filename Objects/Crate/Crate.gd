extends StaticBody2D

export var SPEED = 80
var hold_by_player = false
var player = null
export var never_touched = true


# Called when the node enters the scene tree for the first time.
func _ready():
  if never_touched:
    position.x = 200
    position.y = -8

func _process(delta):
  if never_touched:
    move_on_belt(delta)
  if hold_by_player:
    stick_to_player(delta)
  if never_touched == false && hold_by_player == false && out_of_play_area():
    queue_free()


func move_on_belt(delta):
  if position.x == 200 && position.y <= 56:
    position.y += SPEED * delta
  elif position.y == 248 && position.x >= 252:
    queue_free()
  elif position.y >= 248 && position.x <= 272:
    position.y = 248
    position.x += SPEED * delta
  elif position.x <= 24 && position.y < 248:
    position.x = 24
    position.y += SPEED * delta
  elif position.y >= 56 && position.x > 24:
    position.y = 56
    position.x -= SPEED * delta


func stick_to_player(delta):
  position.x = player.position.x + cos(player.rotation - PI/2) * 13
  position.y = player.position.y + sin(player.rotation - PI/2) * 13
  look_at(player.position)

func out_of_play_area():
  return(position.y < 72 || position.y > 232 || position.x < 40 || position.x > 350)

func _on_InteractionArea_area_entered(area):
  hold_by_player = true
  never_touched = false
  player = area.get_parent()

func _on_InteractionArea_area_exited(area):
  hold_by_player = false
  $CreateDropPlayer.play()
  pass
