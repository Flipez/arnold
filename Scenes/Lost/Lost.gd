extends Node2D

func _ready():
  if !Score.toilet:
    $Arnold/AnimationPlayer.play("Toilet")
  else:
    $Arnold/AnimationPlayer.play("Falling")
