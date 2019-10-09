extends Node2D


var game_over := false;
var missile_bonus = true;
var difficulty_modifier := 1.0;

var score := 0;
var score_label;

var station;
var lifeContainer;
var invader1;
var invader2;
var ufo;
var display;

func _ready() -> void:
	GameZones.init();
	$Display.queue_free();
	setup();

func _process(delta: float) -> void:
	if game_over:
		return;
	
	if score >= 700 and missile_bonus:
		station.missiles += 50;
		station.lifes += 1;
		missile_bonus = false;
		
		if lifeContainer.get_child_count() < 3:
			lifeContainer.add_child(preload("res://Scenes/LifeIndicator.tscn").instance());
	
	if station.lifes <= 0:
		station.get_node("StationSprite").visible = false;
		station.get_node("Explosion").visible = true;
		game_over = true;
	
	if score >= 999:
		score_label.text = str(999);
		game_over = true;
	
	if station.missiles <= 0:
		game_over = true;
	
	if game_over:
		end_game();

func toogle_display():
	display.visible = !display.visible;

func update_score(points: int) -> void:
	score += points;
	score_label.text = str(score);

func setup():
	display = preload("res://Scenes/Display.tscn").instance();
	add_child(display);
	
	station = display.get_node("Station");
	lifeContainer = display.get_node("StationLife/Container");
	score_label = display.get_node("ScoreLabel");
	
	$UfoSpawnTimer.wait_time = rand_range(10, 30);
	ufo = preload("res://Scenes/Ufo.tscn").instance();
	ufo.difficulty_modifier = difficulty_modifier;
	display.add_child(ufo);
	
	invader1 = preload("res://Scenes/Invader.tscn").instance();
	invader2 = preload("res://Scenes/Invader.tscn").instance();
	
	invader1.difficulty_modifier = difficulty_modifier;
	invader2.difficulty_modifier = difficulty_modifier;
	
	$InvaderSpawnTimer.wait_time = 2 / difficulty_modifier;
	
	display.add_child(invader1);
	display.add_child(invader2);
	
	$InvaderSpawnTimer.start();
	
	score = 0;
	game_over = false;

func end_game():
	$BlinkTimer.start();
	$InvaderSpawnTimer.stop();
	get_tree().paused = true;

func restart_game():
	get_tree().paused = false;
	# remover display antigo
	display.queue_free();
	
	setup();

func _on_InvaderSpawnTimer_timeout() -> void:
	if !invader1.alive:
		invader1.reset();
	elif !invader2.alive:
		invader2.reset();

func _on_Switch_toggled(button_pressed: bool) -> void:
	if button_pressed:
		game_over = true;
		restart_game();
	else:
		end_game();
		display.visible = false;
		$BlinkTimer.stop();

func _on_UfoSpawnTimer_timeout() -> void:
	if !ufo.alive:
		ufo.setup();
	$UfoSpawnTimer.wait_time = rand_range(10, 30);

func _on_Level1_pressed() -> void:
	difficulty_modifier = 1.0;

func _on_Level2_pressed() -> void:
	difficulty_modifier = 1.5;

func _on_Level3_pressed() -> void:
	difficulty_modifier = 2.0;