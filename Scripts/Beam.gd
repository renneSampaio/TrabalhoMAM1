extends Node2D

export var speed: float = 70;
var simulated_pos : Vector2;
var beamHeight : float;

func _ready() -> void:
	var beamHeight = $Sprite.get_rect().size.y * $Sprite.scale.y;
	simulated_pos = position;

func _process(delta: float) -> void:
	simulated_pos.y += speed * delta;
	
	var current_row = GameZones.height_to_row(GameZones.InvaderZoneEnd - simulated_pos.y);
	position.y = current_row - beamHeight;

	if position.y > GameZones.InvaderZoneEnd - 10:
		queue_free();

func _on_collision(area: Area2D) -> void:
	queue_free();