extends StaticBody2D

export var SPEED = 80
var hold_by_player = false
var player = null
export var never_touched = true

signal destroyed
signal collected

# Called when the node enters the scene tree for the first time.
func _ready():
  if never_touched:
    position.x = 200
    position.y = -8

func _process(delta):
  if never_touched:
    move_on_belt(delta)
  if hold_by_player:
    $ContentAnimatedSprite.visible = true
    $Sprite.visible = false
    stick_to_player(delta)
  else:
    $ContentAnimatedSprite.visible = false
    $Sprite.visible = true
    for body in $InteractionArea.get_overlapping_areas():
      if body.get_parent().is_in_group("tubes"):
        collect()
     # for body in 
      #if body.name == "Player" and Input.is_action_just_pressed("jump"):
  if never_touched == false && hold_by_player == false && out_of_play_area():
    destroy()


func move_on_belt(delta):
  if position.x == 200 && position.y <= 48:
    position.y += SPEED * delta
  elif position.y == 224 && position.x >= 252:
    destroy()
  elif position.y >= 224 && position.x <= 252:
    position.y = 224
    position.x += SPEED * delta
  elif position.x <= 24 && position.y < 224:
    position.x = 24
    position.y += SPEED * delta
  elif position.y >= 48 && position.x > 24:
    position.y = 48
    position.x -= SPEED * delta


func stick_to_player(_delta):
  position.x = player.position.x + cos(player.rotation - PI/2) * 13
  position.y = player.position.y + sin(player.rotation - PI/2) * 13
  look_at(player.position)

func out_of_play_area():
  return(position.y < 72 || position.y > 232 || position.x < 40 || position.x > 350)

func _on_InteractionArea_area_entered(area):
  if area.get_parent().is_in_group("players"):
    hold_by_player = true
    never_touched = false
    player = area.get_parent()
    $CratePickupPlayer.play()

func _on_InteractionArea_area_exited(_area):
  hold_by_player = false
  $CrateDropPlayer.play()
  pass

func destroy():
  print("destroyed")
  emit_signal("destroyed")
  queue_free()
  
func collect():
  emit_signal("collected")
  queue_free()
