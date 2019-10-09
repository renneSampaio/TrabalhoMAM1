extends Node2D

var missiles := 250;
var lifes := 3;
var can_fire := true;

func _process(delta: float) -> void:
	position.x = GameZones.Middle;
	
	if Input.is_action_pressed("station_left"):
		position.x = GameZones.Left;
	elif Input.is_action_pressed("station_right"):
		position.x = GameZones.Right;
	
	if Input.is_action_just_pressed("station_fire") and can_fire:
		var missileScene := preload("res://Scenes/Missile.tscn");
		var missileInstance := missileScene.instance() as Node2D;
		missileInstance.position.x = position.x;
		
		get_parent().add_child(missileInstance);
		missiles -= 1;
		can_fire = false;
		
		$MissileCooldown.start();

func _on_collision(area: Area2D) -> void:
	lifes -= 1;
	
	if $"../StationLife/Container".get_child_count() > 0:
		$"../StationLife/Container".get_children()[0].queue_free();

func _on_MissileCooldown_timeout() -> void:
	can_fire = true;
