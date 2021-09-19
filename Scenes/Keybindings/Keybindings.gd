extends Node2D

func _on_Timer_timeout():
    var _return = get_tree().change_scene("res://Scenes/Main/MainLevel.tscn")

func _process(_delta):
  if Input.is_action_just_pressed("ui_select_2"):
    var _return = get_tree().change_scene("res://Scenes/Main/MainLevel.tscn")
