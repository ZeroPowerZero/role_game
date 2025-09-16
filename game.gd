extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	
	print(get_multiplayer_authority())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_set_role_pressed() -> void:
	pass # Replace with function body.
