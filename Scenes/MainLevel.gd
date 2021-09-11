extends Node2D

var crate_preload = preload("res://Objects/Crate/Crate.tscn")
onready var crateTimer = $CrateSpawnerTimer
onready var shitBar = $Shitbar

func _ready():
  crateTimer.start()


func _on_CrateSpawnerTimer_timeout():
  var crate = crate_preload.instance()
  add_child(crate)
  crate.connect("destroyed", shitBar, "crate_destroyed")
