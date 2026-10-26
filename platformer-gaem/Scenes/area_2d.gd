extends Area2D
class_name HurtBox



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		owner.deathBySpikes = true
