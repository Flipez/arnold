extends Node2D

func _ready():
  if Score.toilet:
    $Arnold/AnimationPlayer.play("Toilet")
  else:
    $Arnold/AnimationPlayer.play("Falling")


func _on_AnimationPlayer_animation_finished(anim_name):
  if anim_name == "Toilet":
    $AudioStreamPlayer.play()
  else:
   _on_AudioStreamPlayer_finished()

func _on_AudioStreamPlayer_finished():
  var _return = get_tree().change_scene("res://Scenes/Credits/Credits.tscn")
