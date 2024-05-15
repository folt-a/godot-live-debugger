extends CharacterBody2D

#@Debug[position]

#@Debug
var speed:float = 300.0

#@Debug{AQUA}
var jump_velocity:float = -400.0

#@Debug'Player Gravity!!'
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

#@Debug
@export var text:String = "I'm Gobot san.":
	set(v):
		text = v
		queue_redraw()

#@Debug{#00ff00}
@onready var position_for_reset:Vector2 = global_position

@onready var _default_font:Font = get_tree().root.get_theme_default_font() 
@onready var _default_font_size:int = get_tree().root.get_theme_default_font_size() 

func _draw():
	draw_string(_default_font,Vector2(-64,-96),self.text)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


#@Call
func reset_position():
	global_position = position_for_reset
