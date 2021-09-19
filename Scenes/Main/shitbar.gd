extends Control

func _ready():
  pass
  

func crate_destroyed():
  $BarIncreasePlayer.play()
  $Progress.value += 1
  
  if $Progress.value >= $Progress.max_value and name == "Shitbar" \
  or $Progress.value <= 0 and name != "Shitbar":
    match name:
      "Shitbar":
        Score.toilet = true
    var _return = get_tree().change_scene("res://Scenes/Lost/Lost.tscn")
  
  
func crate_collected():
  $Progress.value += 5

func _on_Timer_timeout():
  $Progress.value -= 1
  pass
