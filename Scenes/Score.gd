extends Node

var score = 0

signal new_score

func increase(amount):
  score += amount
  emit_signal("new_score", score)
