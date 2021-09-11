extends Node2D

var crate_preload = preload("res://Objects/Crate/Crate.tscn")
onready var crateTimer = $CrateSpawnerTimer

func _ready():
  crateTimer.start()


func _on_CrateSpawnerTimer_timeout():
  add_child(crate_preload.instance())
