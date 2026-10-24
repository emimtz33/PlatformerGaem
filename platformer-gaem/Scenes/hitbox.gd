
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	owner.dead = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	owner.dead = true
