extends Spatial

var player = preload("res://mobs/players/boombots/Z1-E7/Z1E7.tscn")

func _ready():
	$GroundFloor.connect("generation_finished", self, "place_player")

func place_player():
	get_tree().get_nodes_in_group("first_room")[0].place_player(player.instance())
