extends Node2D

export var speed: float = 70;
var simulated_pos : Vector2;

func _ready() -> void:
	var missileHeight = $Sprite.get_rect().size.y * $Sprite.scale.y;
	position.y = GameZones.InvaderZoneEnd - missileHeight/2.0 - 10;
	simulated_pos = position;
	
	position.y -= missileHeight/2;
	print(position.y);

func _process(delta: float) -> void:
	simulated_pos.y -= speed * delta;
	
	var current_row = GameZones.height_to_row(GameZones.InvaderZoneEnd - simulated_pos.y);
	position.y = current_row - $Sprite.get_rect().size.y * $Sprite.scale.y * 0.5;

	if position.y < GameZones.InvaderZoneStart:
		queue_free();

func _on_collision(area: Area2D) -> void:
	queue_free();