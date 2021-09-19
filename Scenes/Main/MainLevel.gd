extends Node2D

var crate_preload = preload("res://Objects/Crate/Crate.tscn")
onready var crateTimer = $CrateSpawnerTimer
onready var shitBar = $Shitbar
var player_2_joined = false
var game_over = false

var CRATE_SPEED = 5

func _ready():
  $skincover.visible = true
  crateTimer.start()
  var _return = Score.connect("new_score", self, "new_score")
  $AnimationPlayer.play("coming_in")
  Score.score = 0
  $Shitbar/Progress.value = 0
  $Lungbar/Progress.value = 80
  $Heartbar/Progress.value = 65
  $Brainbar/Progress.value = 65
  $Musclebar/Progress.value = 65
  set_speed_scale(1)
  game_over = false
  
  
func _process(_delta):
  if game_over:
    return

  if Input.is_action_pressed("ui_accept") && !player_2_joined:
    spawn_player_2()
    
  if $Players/Player.is_holding_crate:
    match $Players/Player.crate.type_string:
      "air":
        $Lungbar/AnimatedSprite.play("active")
      "chocolate", "pizza":
        $Heartbar/AnimatedSprite.play("active")
      "banana", "chicken", "egg":
        $Musclebar/AnimatedSprite.play("active")
      "coffee", "beer":
        $Brainbar/AnimatedSprite.play("active")
  else:
    $Lungbar/AnimatedSprite.play("default")
    $Heartbar/AnimatedSprite.play("default")
    $Musclebar/AnimatedSprite.play("default")
    $Brainbar/AnimatedSprite.play("default")

func _on_CrateSpawnerTimer_timeout():
  var crate = crate_preload.instance()
  crate.SPEED = CRATE_SPEED
  $Crates.add_child(crate)
  crate.connect("destroyed", shitBar, "crate_destroyed")
  match crate.type_string:
    "air":
      crate.connect("collected", $Lungbar, "crate_collected")
    "chocolate", "pizza":
      crate.connect("collected", $Heartbar, "crate_collected")
    "banana", "egg", "chicken":
      crate.connect("collected", $Musclebar, "crate_collected")
    "coffee":
      crate.connect("collected", $Brainbar, "crate_collected")
      crate.connect("collected", self, "coffee_collected")
    "beer":
      crate.connect("collected", $Brainbar, "crate_collected")
      crate.connect("collected", self, "beer_collected")
  
func set_speed_scale(scale):
  $Belt.set_speed(scale)
  CRATE_SPEED = 5 * scale
  for crate in $Crates.get_children():
    crate.SPEED = 5 * scale
  # wait time for sporning of the next crate:
  # a * exp(-b*scale) + c
  # where:
  # c is the minimal wait time
  # a*1.1 + c is the spawn time of the very first crate 
  # b indicates how fast the function goes to the minimal wait time (direct proportional)
  $CrateSpawnerTimer.wait_time = 5 * exp(-0.2*scale) + 2.5

func new_score(score):
  set_speed_scale(1 + score / 10)
  

  
func coffee_collected():
  $CoffeeShaderTimer.start()
  $CoffeeShader.visible = true
  $BeerShader.visible = false
  
  Sound.pitch_sound_to(1.5)
  $Players/Player.MAX_SPEED = 160
  if player_2_joined:
    $Players/Player2.MAX_SPEED = 160

func beer_collected():
  $BeerShaderTimer.start()
  $CoffeeShader.visible = false
  $BeerShader.visible = true
  
  Sound.pitch_sound_to(0.5)
  $Players/Player.MAX_SPEED = 20
  if player_2_joined:
    $Players/Player2.MAX_SPEED = 20

func spawn_player_2():
  player_2_joined = true
  var player2 = preload("res://Scenes/Player/Player.tscn").instance()
  player2.is_player_2 = true
  $Players.add_child(player2)

func _on_CoffeeShaderTimer_timeout():
  $CoffeeShader.visible = false
  if Sound.player.pitch_scale == 1.5:
    Sound.pitch_sound_to(1)
    $Players/Player.MAX_SPEED = 80
    if player_2_joined:
      $Players/Player2.MAX_SPEED = 80

func _on_BeerShaderTimer_timeout():
  $BeerShader.visible = false
  if Sound.player.pitch_scale == 0.5:
    Sound.pitch_sound_to(1)
    $Players/Player.MAX_SPEED = 80
    if player_2_joined:
      $Players/Player2.MAX_SPEED = 80

func _on_Camera_zoom_in_animation_finished(anim_name):
  if anim_name == "zoom_in_to_game":
    $skincover/AnimationPlayer.play("get_transparent")
  else:
    var _return = get_tree().change_scene("res://Scenes/Lost/Lost.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
  $Camera2D/Camera_zoom_in.play("zoom_in_to_game")


func _game_over():
  game_over = false
  set_speed_scale(0)
  $Players/Player.MAX_SPEED = 0
  if player_2_joined:
    $Players/Player2.MAX_SPEED = 0
