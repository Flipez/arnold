extends Node2D

var message = [
  "Your score: " + String(Score.score)
]

var typing_speed = .15

var display = ""
var current_char = 0


func _ready():
  start_dialogue()
  $Label2.visible = false
  $Godot_logo.visible = false
  
  
func _process(_delta):
  if Input.is_action_just_pressed("ui_select_2"):
    Sound.pitch_sound_to(1)
    var _return = get_tree().change_scene("res://Scenes/Main/MainLevel.tscn")
  
func start_dialogue():
  display = ""
  current_char = 0
  print(len(message[0]))
  $next_char.set_wait_time(typing_speed)
  $next_char.start()


func _on_next_char_timeout():
  if (current_char < len(message[0])):
    var next_char = message[0][current_char]
    display += next_char
    
    $Label.text = display
    current_char += 1
  else:
    $next_char.stop()
    $Label2.visible = true
    $Godot_logo.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
