extends Control

func _ready():
  pass
  
func _process(delta):
 # $LungProgress.value -= delta

func crate_destroyed():
  $BarIncreasePlayer.play()
  $ShitProgress.value += 1
  
  
func crate_collected():
  $BarIncreasePlayer.play()
  $LungProgress.value += 5
