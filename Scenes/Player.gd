extends KinematicBody2D

export var FRICTION = 500
export var ACCELERATION = 500
export var MAX_SPEED = 80

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var is_holding_crate = false

enum {
  MOVE,
  DIALOG,
  INTERACT
 }

export var state = MOVE

onready var interactionArea = $InteractionArea/InteractionShape
onready var playerSprite = $Sprite

func _ready():
  pass

func _physics_process(delta):
  set_animation()
  match state:
    MOVE:
      move_state(delta)
    INTERACT:
      interact_state()
    DIALOG:
      dialog_state()
      
  if Input.is_action_pressed("ui_select"):
    interactionArea.disabled = false
  else:
    interactionArea.disabled = true
  

  
  
  
func move_state(delta):
  # set the strength of rotation depending on the users input
  rotation_degrees += Input.get_action_strength("ui_right") * 2
  rotation_degrees -= Input.get_action_strength("ui_left") * 2

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

func _on_interactionArea_area_entered(area):
  is_holding_crate = true


func _on_InteractionArea_area_exited(area):
  is_holding_crate = false

