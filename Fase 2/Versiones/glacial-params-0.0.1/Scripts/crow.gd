extends CharacterBody3D


const JUMP_VELOCITY = 4.5

@export var _walking_speed : float = 2
@export var _acceleration : float = 2
@export var _deceleration : float = 4
@export var _rotation_speed : float = PI
var _angle_difference : float
var _xz_velocity : Vector3

#El signo peso sirve para especificar el Path de la agrupacion de animaciones 
@onready var _animation : AnimationTree = $AnimationTree
@onready var _state_machine : AnimationNodeStateMachinePlayback = _animation["parameters/playback"]
@onready var _rig : Node3D = $rig_v3


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _direction : Vector3

#func _ready():
	#_rotation_speed = deg_to_rad(_rotation_speed)

func move(direction : Vector3):
	_direction = direction
	
func jump():
	if is_on_floor():
		_state_machine.travel("rig_v3_jump")
		


func _physics_process(delta: float):
	#Copia la velocidad actual del modelo
	if _direction:
		_angle_difference = wrapf(atan2(_direction.x, _direction.z) - _rig.rotation.y, -PI, PI)
		_rig.rotation.y += clamp(_rotation_speed * delta, 0, abs(_angle_difference)) * sign(_angle_difference)

		_xz_velocity = Vector3(velocity.x, 0, velocity.z)

	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	#aplicar movimiento de entrada a xzvelocity
	if _direction:
		
		#Ajuste de Velocidad
		if _direction.dot(velocity):
			_xz_velocity = _xz_velocity.move_toward(_direction * _walking_speed, _acceleration * delta)
		else: 
			#Giro acorde a momentum
			_xz_velocity = _xz_velocity.move_toward(_direction * _walking_speed, _deceleration * delta)
	else:
		#Detención
		_xz_velocity = _xz_velocity.move_toward(Vector3.ZERO, _deceleration * delta)

	_animation.set("parameters/Locomotion/blend_position", _xz_velocity.length() / _walking_speed)
	
	#Aplicar ajuste de velocidad
	velocity.x = _xz_velocity.x
	velocity.z = _xz_velocity.z

	move_and_slide()
