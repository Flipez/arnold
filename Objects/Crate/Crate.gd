extends KinematicBody2D

export var SPEED = 5
var hold_by_player = false
var player = null
export var never_touched = true

signal destroyed
signal collected

var collect_streams = [
  preload("res://Objects/Crate/balloon_deflate.mp3"),
  preload("res://Objects/Crate/banana_tear.mp3"),
  preload("res://Objects/Crate/chocolate_nom.mp3"),
  preload("res://Objects/Crate/coffee_sip.mp3"),
  preload("res://Objects/Crate/beer_open.mp3"),
  preload("res://Objects/Crate/egg.mp3"),
  preload("res://Objects/Crate/chicken.mp3"),
  preload("res://Objects/Crate/pizza.mp3")
 ]

enum types {
  AIR,
  BANANA,
  CHOCOLATE,
  COFFEE,
  BEER,
  EGG,
  CHICKEN,
  PIZZA
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
      type_string = "air"
    4:
      type_id = types.BANANA
      type_string = "banana"
    5:
      type_id = types.EGG
      type_string = "egg"
    6:
      type_id = types.CHICKEN
      type_string = "chicken"
    7:
      type_id = types.CHOCOLATE
      type_string = "chocolate"
    8:
      type_id = types.PIZZA
      type_string = "pizza"
    9:
      type_id = types.COFFEE
      type_string = "coffee"
    10:
      type_id = types.BEER
      type_string = "beer"
  
  $ContentAnimatedSprite.play(type_string)

func _process(delta):
  if never_touched:
    move_on_belt(delta)
  if hold_by_player:
    $ContentAnimatedSprite.visible = true
    $Sprite.visible = false
    stick_to_player(delta)
  else:
    for body in $InteractionArea.get_overlapping_areas():
      if body.get_parent().is_in_group("tubes") && body.is_in_group(type_string):
        collect()
  if never_touched == false && hold_by_player == false && out_of_play_area():
    destroy()
  
  if never_touched == false:
    var _return = move_and_slide(Vector2.ZERO)


func move_on_belt(delta):
  if position.x == 200 && position.y <= 48:
    position.y += SPEED * delta
  elif position.y == 224 && position.x >= 218:
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
  if type_id != types.AIR:
    position.x = player.position.x + cos(player.rotation - PI/2) * 16
    position.y = player.position.y + sin(player.rotation - PI/2) * 16
    look_at(player.position)
    rotation_degrees -= 90
  else:
    position.x = player.position.x + cos(player.rotation - PI/2) * 16
    position.y = player.position.y + sin(player.rotation - PI/2) * 16

func out_of_play_area():
  return(position.y < 72 || position.y > 232 || position.x < 40 || position.x > 350)

func _on_InteractionArea_area_entered(area):
  if area.get_parent().is_in_group("players") && area.get_overlapping_areas().size() == 0:
    hold_by_player = true
    never_touched = false
    player = area.get_parent()
    $CratePickupPlayer.play()

func _on_InteractionArea_area_exited(area):
  if area.get_parent().is_in_group("players"):
    hold_by_player = false
    $CrateDropPlayer.play()

func destroy():
  print("destroyed")
  emit_signal("destroyed")
  queue_free()
  
func collect():
  $InteractionArea/CollisionShape2D.disabled = true
  visible = false
  $CollectAudioPlayer.stream = collect_streams[type_id]
  $CollectAudioPlayer.play()

func _on_CollectAudioPlayer_finished():
  print("collected")
  emit_signal("collected")
  Score.increase(5)
  queue_free()
