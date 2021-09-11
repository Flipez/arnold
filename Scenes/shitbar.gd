extends Control

func _ready():
  pass

func crate_destroyed():
  $TextureProgress.value += 1
