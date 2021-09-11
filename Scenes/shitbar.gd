extends Control

func _ready():
  pass

func crate_destroyed():
  print("receive destroed")
  $TextureProgress.value += 100
