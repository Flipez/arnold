extends Node

onready var player = $Player
onready var tween = $Tween

func pitch_sound_to(pitch_scale):
  tween.interpolate_property(player, "pitch_scale", player.pitch_scale, pitch_scale, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  tween.start()
