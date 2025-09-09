extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var ip_input = $VBoxContainer/IPInput
@onready var info_label = $VBoxContainer/InfoLabel

const PORT = 9999


func _ready():
	info_label.text = ""

func _on_host_button_pressed() -> void:
	Global.player_name = name_input.text.strip_edges()
	Global.is_host = true


	var peer = ENetMultiplayerPeer.new()
	if peer.create_server(PORT) != OK:
		info_label.text = "Failed to start server!"
		return
	
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://game.tscn")

func _on_join_button_pressed() -> void:
	Global.player_name = name_input.text.strip_edges() 
	Global.is_host = false


	var ip = ip_input.text.strip_edges()
	if ip == "":
		ip = "127.0.0.1"

	var peer = ENetMultiplayerPeer.new()
	if peer.create_client(ip, PORT) != OK:
		info_label.text = "Failed to connect to host!"
		return

	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://game.tscn")
