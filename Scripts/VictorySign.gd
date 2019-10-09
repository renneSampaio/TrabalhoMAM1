extends Sprite

func _ready() -> void:
	get_tree().get_root().get_node("/root/Game").game_over = true;
	get_tree().get_root().get_node("/root/Game").end_game();