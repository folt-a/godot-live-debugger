extends StaticBody2D

@export var color:Color = Color.DIM_GRAY

@onready var collision_shape:CollisionShape2D = get_child(0)

var image_texture:ImageTexture

#@Debug[position]

func _ready():
	var rect:= collision_shape.shape.get_rect()
	
	var sprite2d:= Sprite2D.new()
	var image:Image = Image.create(rect.size.x,rect.size.y,false,Image.FORMAT_RGB8)
	image.fill(color)
	image_texture = ImageTexture.create_from_image(image)
	sprite2d.texture = image_texture
	add_child(sprite2d)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rect:= collision_shape.shape.get_rect()
	var image:Image = Image.create(rect.size.x,rect.size.y,false,Image.FORMAT_RGB8)
	image.fill(color)
	image_texture.update(image)
