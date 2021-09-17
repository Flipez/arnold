extends Control

func _ready():
  pass
  

func crate_destroyed():
  $BarIncreasePlayer.play()
  $Progress.value += 1
  
  
func crate_collected():
  #$BarIncreasePlayer.play()
  $Progress.value += 5

func _on_Timer_timeout():
  $Progress.value -= 1
  pass
