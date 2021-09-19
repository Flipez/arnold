extends Node2D

var crate_preload = preload("res://Objects/Crate/Crate.tscn")
onready var crateTimer = $CrateSpawnerTimer
onready var shitBar = $Shitbar
var player_2_joined = false

var CRATE_SPEED = 5

func _ready():
  crateTimer.start()
  Score.connect("new_score", self, "new_score")
  $Camera2D/Camera_zoom_in.play("zoom_in")
  
func _process(delta):
  if Input.is_action_pressed("ui_accept") && !player_2_joined:
    player_2_joined = true
    var player2 = preload("res://Scenes/Player/Player.tscn").instance()
    player2.set_name("Player2")
    player2.set_position(Vector2(200, 100))
    $Players.add_child(player2)


func _on_CrateSpawnerTimer_timeout():
  var crate = crate_preload.instance()
  crate.SPEED = CRATE_SPEED
  $Crates.add_child(crate)
  crate.connect("destroyed", shitBar, "crate_destroyed")
  if crate.type_string == "air":
    crate.connect("collected", $Lungbar, "crate_collected")
  if crate.type_string == "chocolate":
    crate.connect("collected", $Heartbar, "crate_collected")
  if crate.type_string == "banana":
    crate.connect("collected", $Musclebar, "crate_collected")
  if crate.type_string == "coffee":
    crate.connect("collected", $Brainbar, "crate_collected")
    crate.connect("collected", self, "coffee_collected")
  if crate.type_string == "beer":
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
  
  $BackgroundAudioPlayer/Tween.interpolate_property($BackgroundAudioPlayer, "pitch_scale", $BackgroundAudioPlayer.pitch_scale, 1.5, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  $BackgroundAudioPlayer/Tween.start()
  $Players/Player.MAX_SPEED = 160
  if player_2_joined:
    $Players/Player2.MAX_SPEED = 160

  
func beer_collected():
  $BeerShaderTimer.start()
  $CoffeeShader.visible = false
  $BeerShader.visible = true
  
  $BackgroundAudioPlayer/Tween.interpolate_property($BackgroundAudioPlayer, "pitch_scale", $BackgroundAudioPlayer.pitch_scale, 0.5, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  $BackgroundAudioPlayer/Tween.start()
  $Players/Player.MAX_SPEED = 20
  if player_2_joined:
    $Players/Player2.MAX_SPEED = 20

func _on_CoffeeShaderTimer_timeout():
  $CoffeeShader.visible = false
  if $BackgroundAudioPlayer.pitch_scale == 1.5:
    $BackgroundAudioPlayer.pitch_scale = 1
    $Players/Player.MAX_SPEED = 80
    if player_2_joined:
      $Players/Player2.MAX_SPEED = 80

func _on_BeerShaderTimer_timeout():
  $BeerShader.visible = false
  if $BackgroundAudioPlayer.pitch_scale == 0.5:
    $BackgroundAudioPlayer.pitch_scale = 1
    $Players/Player.MAX_SPEED = 80
    if player_2_joined:
      $Players/Player2.MAX_SPEED = 80

func _on_Camera_zoom_in_animation_finished(_anim_name):
  print("animation finished")
  $skincover/AnimationPlayer.play("get_transparent")
  pass # Replace with function body.
