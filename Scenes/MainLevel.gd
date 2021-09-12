extends Node2D

var crate_preload = preload("res://Objects/Crate/Crate.tscn")
onready var crateTimer = $CrateSpawnerTimer
onready var shitBar = $Shitbar
var player_2_joined = false

var CRATE_SPEED = 5

func _ready():
  crateTimer.start()
  Score.connect("new_score", self, "new_score")
  
func _process(delta):
  if Input.is_action_pressed("ui_accept") && !player_2_joined:
    player_2_joined = true
    var player2 = preload("res://Scenes/Player.tscn").instance()
    player2.set_name("Player2")
    player2.set_position(Vector2(200, 100))
    add_child(player2)


func _on_CrateSpawnerTimer_timeout():
  var crate = crate_preload.instance()
  crate.SPEED = CRATE_SPEED
  $Crates.add_child(crate)
  crate.connect("destroyed", shitBar, "crate_destroyed")
  crate.connect("collected", $Lungbar, "crate_collected")
  
func set_speed_scale(scale):
  $Belt.set_speed(scale)
  CRATE_SPEED = 5 * scale
  for crate in $Crates.get_children():
    crate.SPEED = 5 * scale

func new_score(score):
  set_speed_scale(1 + score / 10)
