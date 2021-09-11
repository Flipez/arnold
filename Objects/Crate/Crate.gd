extends StaticBody2D

export var SPEED = 80
var hold_by_player = false
var player = null
export var never_touched = true

signal destroyed
signal collected

enum types {
  AIR,
  BANANA,
  CHOCOLATE,
  COFFEE,
  BEER
 }

var rng = RandomNumberGenerator.new()
var type_string = ""
var type_id = null

func _ready():
  if never_touched:
    position.x = 200
    position.y = -8
    
  rng.randomize()
  var random_number = rng.randi_range(0, 10)
  
  match random_number:
    0,1,2,3:
      type_id = types.AIR
      $ContentAnimatedSprite.play("air")
      pass
    4,5,6:
      type_id = types.BANANA
      $ContentAnimatedSprite.play("banana")
      pass
    7,8:
      type_id = types.CHOCOLATE
      $ContentAnimatedSprite.play("chocolate")
      pass
    9:
      type_id = types.COFFEE
      $ContentAnimatedSprite.play("coffee")
      pass
    10:
      type_id = types.BEER
      $ContentAnimatedSprite.play("beer")
      pass

func _process(delta):
  if never_touched:
    move_on_belt(delta)
  if hold_by_player:
    $ContentAnimatedSprite.visible = true
    $Sprite.visible = false
    stick_to_player(delta)
  else:
    for body in $InteractionArea.get_overlapping_areas():
      if body.get_parent().is_in_group("tubes"):
        collect()
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
  if type_id != types.AIR:
    look_at(player.position)
    rotation_degrees -= 90

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
