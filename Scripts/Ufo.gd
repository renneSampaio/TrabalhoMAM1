extends Node2D

var alive := false;
var difficulty_modifier := 1.0;
var ActionWaitTime := 2.0;
var path := [];

func setup():
	var random_pos = int(rand_range(0, 2));
	if random_pos == 0:
		path = [GameZones.Left, GameZones.Middle, GameZones.Right];
	elif random_pos == 1:
		path = [GameZones.Right, GameZones.Middle, GameZones.Left];
	
	position.x = path.pop_front();
	position.y = GameZones.InvaderZoneStart;
	
	$Area2D.set_collision_layer_bit(2, true);
	
	alive = true;
	$UfoSprite.visible = true;
	$ActionTimer.wait_time =  ActionWaitTime / difficulty_modifier;
	$ActionTimer.start();

func _on_Area2D_area_entered(area: Area2D) -> void:
	$UfoSprite.visible = false;
	$Explosion.visible = true;
	
	$Area2D.set_collision_layer_bit(2, false);
	alive = false;
	
	get_tree().get_root().get_node("Game").update_score(10);
	
	$ExplosionTimer.start();

func _on_ExplosionTimer_timeout() -> void:
	$Explosion.visible = false;


func _on_ActionTimer_timeout() -> void:
	if !alive:
		return;
		
	if path.empty():
		$ActionTimer.stop();
		alive = false;
		$Area2D.set_collision_layer_bit(2, false);
		$UfoSprite.visible = false;

		return;
		
	$UfoSprite.frame = 0 if $UfoSprite.frame == 1  else 1;
	
	position.x = path.pop_front();
	
	
