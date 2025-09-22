extends Control
func set_info(id:int =Global.player_id,p_name:String=Global.player_name):
	$VBoxContainer/HBoxContainer/Name.text = p_name
	var texture = load(Global.lobby_image_list[id])
	$VBoxContainer/TextureRect.texture = texture
	$ColorRect.color=Global.lobby_color_list[id]
