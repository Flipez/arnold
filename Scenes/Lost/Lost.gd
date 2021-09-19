extends Node2D

func _ready():
  if Score.toilet:
    $Arnold/AnimationPlayer.play("Toilet")
  else:
    $Arnold/AnimationPlayer.play("Falling")


func _on_AnimationPlayer_animation_finished(anim_name):
  var _return = get_tree().change_scene("res://Scenes/Credits/Credits.tscn")
