extends Control

func _ready():
  pass

func crate_destroyed():
  $BarIncreasePlayer.play()
  $TextureProgress.value += 1
