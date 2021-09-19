extends Label

func _ready():
  var _return = Score.connect("new_score", self, "new_score")

func new_score(score):
  text = String(score) + " Points"
