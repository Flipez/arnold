extends Control

signal bar_full

func _ready():
  pass
  
  
func _process(_delta):
  if $Progress.value >= $Progress.max_value and name == "Shitbar" \
  or $Progress.value <= $Progress.min_value + 1 and name != "Shitbar":
    print("bar full/empty")
    emit_signal("bar_full")
    Sound.pitch_sound_to(0.3)
    match name:
      "Shitbar":
        Score.toilet = true


func crate_destroyed():
  $BarIncreasePlayer.play()
  $Progress.value += 1
  
  
func crate_collected():
  $Progress.value += 5

func _on_Timer_timeout():
  $Progress.value -= 1
  pass
