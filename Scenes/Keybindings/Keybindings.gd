extends Node2D

func _on_Timer_timeout():
    get_tree().change_scene("res://Scenes/Main/MainLevel.tscn")

func _process(delta):
  if Input.is_action_just_pressed("ui_select"):
    get_tree().change_scene("res://Scenes/Main/MainLevel.tscn")
