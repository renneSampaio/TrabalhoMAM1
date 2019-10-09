extends Node

var Left: int;
var Middle: int;
var Right: int;

var InvaderZoneStart: int;
var InvaderZoneEnd: int;
var InvaderZoneHeight: float;

var RowHeight;

func init() -> void:
	var gameNode := get_node("/root/Game/");
	Left = gameNode.get_node("Display/Columns/Left").position.x;
	Middle = gameNode.get_node("Display/Columns/Middle").position.x;
	Right = gameNode.get_node("Display/Columns/Right").position.x;
	
	var invaderZone = gameNode.get_node("Display/InvaderZone/");
	InvaderZoneStart = invaderZone.get_node("TopLeft").position.y;
	InvaderZoneEnd = invaderZone.get_node("BottomRight").position.y;
	InvaderZoneHeight = abs(InvaderZoneEnd - InvaderZoneStart);
	
	RowHeight = InvaderZoneHeight/7;

func height_to_row(height: int) -> int:
	var progress = abs(height) /  int(RowHeight);
	var currentRow = InvaderZoneEnd - (progress * RowHeight);
	return currentRow;
	
	