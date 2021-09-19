extends KinematicBody2D

export var FRICTION = 500
export var ACCELERATION = 500
export var MAX_SPEED = 80

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var is_holding_crate = false
var is_player_2 = false

onready var interactionArea = $InteractionArea/InteractionShape
onready var playerSprite = $AnimatedSprite

func _ready():
  set_animation()
  set_position(Vector2(200, 100))
    
func _physics_process(delta):
  if is_player_2:
    rotation_degrees += Input.get_action_strength("ui_right_2") * 3
    rotation_degrees -= Input.get_action_strength("ui_left_2") * 3
    input_vector.y = Input.get_action_strength("ui_down_2") - Input.get_action_strength("ui_up_2")
  else:
    rotation_degrees += Input.get_action_strength("ui_right") * 3
    rotation_degrees -= Input.get_action_strength("ui_left") * 3
    input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
  
  input_vector = input_vector.normalized()

  if input_vector != Vector2.ZERO:
    velocity = velocity.move_toward(input_vector.rotated(rotation) * MAX_SPEED, ACCELERATION * delta)
  else:
    velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

  velocity = move_and_slide(velocity)
      
  if is_player_2:
    interactionArea.disabled = !Input.is_action_pressed("ui_select_2")
  else:
    interactionArea.disabled = !Input.is_action_pressed("ui_select")
  
func set_animation():
  if is_player_2:
    if is_holding_crate:
      playerSprite.play("holding_b")
    else:
      playerSprite.play("default_b")
  else:
    if is_holding_crate:
      playerSprite.play("holding_a")
    else:
      playerSprite.play("default_a")

func _on_interactionArea_area_entered(_area):
  is_holding_crate = true
  set_animation()

func _on_InteractionArea_area_exited(_area):
  is_holding_crate = false
  set_animation()
