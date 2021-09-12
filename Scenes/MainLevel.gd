extends Node2D

var crate_preload = preload("res://Objects/Crate/Crate.tscn")
onready var crateTimer = $CrateSpawnerTimer
onready var shitBar = $Shitbar
var player_2_joined = false

func _ready():
  crateTimer.start()
  
func _process(delta):
  if Input.is_action_pressed("ui_accept") && !player_2_joined:
    player_2_joined = true
    var player2 = preload("res://Scenes/Player.tscn").instance()
    player2.set_name("Player2")
    player2.set_position(Vector2(200, 100))
    add_child(player2)


func _on_CrateSpawnerTimer_timeout():
  var crate = crate_preload.instance()
  $Crates.add_child(crate)
  crate.connect("destroyed", shitBar, "crate_destroyed")
