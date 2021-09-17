extends KinematicBody2D

export var FRICTION = 500
export var ACCELERATION = 500
export var MAX_SPEED = 80

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var is_holding_crate = false
var is_player_2 = false

enum {
  MOVE,
  DIALOG,
  INTERACT
 }

export var state = MOVE

onready var interactionArea = $InteractionArea/InteractionShape
onready var playerSprite = $AnimatedSprite

func _ready():
  if name == "Player2":
    is_player_2 = true
    
func _physics_process(delta):
  set_animation()
  match state:
    MOVE:
      move_state(delta)
    INTERACT:
      interact_state()
    DIALOG:
      dialog_state()
      
  if is_player_2:
    if Input.is_action_pressed("ui_select_2"):
      interactionArea.disabled = false
    else:
      interactionArea.disabled = true
  else:
    if Input.is_action_pressed("ui_select"):
      interactionArea.disabled = false
    else:
      interactionArea.disabled = true
  

  
  
  
func move_state(delta):
  # set the strength of rotation depending on the users input
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

  move()
  
func move():
  velocity = move_and_slide(velocity)


func interact_state():
  velocity = Vector2.ZERO
  interactionArea.disabled = false

  
func dialog_state():
  velocity = Vector2.ZERO

func disable_interaction():
  interactionArea.disabled = true

func invisible():
  $Sprite.hide()
  
func set_animation():
  if is_holding_crate:
    $AnimatedSprite.play("holding")
  else:
    $AnimatedSprite.play("default")

func _on_InteractionTimer_timeout():
  state = MOVE
  interactionArea.disabled = true

func _on_interactionArea_area_entered(_area):
  is_holding_crate = true


func _on_InteractionArea_area_exited(_area):
  is_holding_crate = false

