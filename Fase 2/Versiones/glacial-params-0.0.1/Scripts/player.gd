extends Node

@export var _character : CharacterBody3D
@export var _camera : Camera3D
var _move_direction : Vector3
var _input_direction : Vector2

func _input(event : InputEvent):
	if event.is_action_pressed("jump"):
		_character.jump()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	
	_input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#Movimiento en base a lo que sería perpectiva de cámara sin afectar la coalisión
	_move_direction = (_camera.basis.x * Vector3(1, 0, 1)).normalized() *  _input_direction.x

	_move_direction += (_camera.basis.z * Vector3(1, 0, 1)).normalized() * _input_direction.y

	_character.move(_move_direction)
