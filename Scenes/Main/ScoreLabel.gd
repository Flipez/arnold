extends Label

func _ready():
  Score.connect("new_score", self, "new_score")

func new_score(score):
  text = String(score) + " Points"
