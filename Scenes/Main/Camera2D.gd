extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass


func _on_Shitbar_bar_full():
  $Camera_zoom_in.play("zoom_in_to_toilet")

func _on_Lungbar_bar_full():
  $Camera_zoom_in.play("zoom_in_to_lung")


func _on_Heartbar_bar_full():
  $Camera_zoom_in.play("zoom_in_to_heart")


func _on_Musclebar_bar_full():
  $Camera_zoom_in.play("zoom_in_to_muscle")


func _on_Brainbar_bar_full():
  $Camera_zoom_in.play("zoom_in_to_brain")
