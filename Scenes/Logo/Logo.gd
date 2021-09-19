extends Node2D

func _ready():
  Sound.player.play()


func _on_Timer_timeout():
  var _return = get_tree().change_scene("res://Scenes/Keybindings/Keybindings.tscn")
