extends Node2D

export var speed: float = 50;
var simulated_pos: Vector2;
var alive = false;
var ActionWaitTime := 1.25;
var difficulty_modifier := 1.0;

func _ready() -> void:
	reset();

func reset():
	var random_pos = int(rand_range(0, 3));
	if random_pos == 0:
		position.x = GameZones.Left;
	elif random_pos == 1:
		position.x = GameZones.Middle;
	elif random_pos == 2:
		position.x = GameZones.Right;
		
	position.y = GameZones.InvaderZoneStart  + rand_range(GameZones.RowHeight + 10, 3 * GameZones.RowHeight );
	simulated_pos = position;
	
	$ActionTimer.wait_time = ActionWaitTime / difficulty_modifier;
	
	$InvaderSprite.visible = true;
	$Area2D.set_collision_layer_bit(1, true);
	alive = true;

func _process(delta: float) -> void:
	if (!alive):
		return;
	
	position.y = GameZones.height_to_row(GameZones.InvaderZoneEnd - simulated_pos.y);
	position.y -= $InvaderSprite.texture.get_height() * $InvaderSprite.scale.y * 0.5;
	
	if position.y > GameZones.InvaderZoneEnd - GameZones.RowHeight:
		var victory_sign = preload("res://Scenes/VictorySign.tscn").instance();
		$InvaderSprite.visible = false;
		victory_sign.position = position;
		get_parent().add_child(victory_sign);
		alive = false;

func _on_collision(area: Area2D) -> void:
	if !alive:
		return;
	
	$Area2D.set_collision_layer_bit(1, false);
	alive = false;
	
	print("invader died");
	$InvaderSprite.visible = false;
	$Explosion.visible = true;
	
	var points : int = int(abs(position.y - GameZones.InvaderZoneEnd) / GameZones.RowHeight);
	get_tree().get_root().get_node("Game").update_score(points);
	
	$ExplosionTimer.start();

func _on_ExplosionTimer_timeout() -> void:
	$Explosion.visible = false;
	
func _on_FiringTimer_timeout() -> void:
	if (!alive):
		return 
		
	var beam = preload("res://Scenes/Beam.tscn").instance();
	beam.position = position;
	beam.speed *= difficulty_modifier;
	get_parent().add_child(beam);


func _on_ActionTimer_timeout() -> void:
	if (!alive):
		return;
	
	var choice = rand_range(0, 2)
	if choice > .7:
		simulated_pos.y += GameZones.RowHeight;
	else:
		if int(position.x) == GameZones.Left or int(position.x) == GameZones.Right:
			position.x = GameZones.Middle;
		else:
			choice = rand_range(0, 2);
			if choice > 1:
				position.x = GameZones.Left;
			else:
				position.x = GameZones.Right;