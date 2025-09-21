# Global.gd
extends Node
#References to the Nodes 
var lobby # The reference to the lobby scene
var game # The reference to the Game scene

#Const for Role Names (Spelling issues ke liye )
const RAJA="Raja"
const WAZIR="Wazir"
const CHOR="Chor"
const SIPAHI="Sipahi"

const CHOR_WIN_SCORE=1000
#Game Player
var player_id:int # The unique ID of the Player 
var player_name: String = "" # The Name of the Player
var player_names: Array[String] = [] #Name of the Players in the Game
var roles: Array[String] = [RAJA,WAZIR,CHOR,SIPAHI] #Roles in the Game (Warning its Shuffled !Never Assume Index)
var is_host: bool = false # Is this instance the Host
var player_role : String #The role of the player

var score_per_role={RAJA:1000,WAZIR:800,SIPAHI:700,CHOR:0}
#Networking 
var latency:float = 0.1 #TODO Latency of the network 

# Lobby variables :

#Path of images of card  
var lobby_image_list = ["res://assets/fox.jpg","res://assets/rabbit.jpg","res://assets/lion.jpg","res://assets/horse.jpg"]
#Color of each card 
var lobby_color_list=["#006b3722", "#f6cf4941","#ff00004a","#a764db4a"]
# Note : Keep the path and the color at the same index  

#Game variables :
var chit_list=[] # Stores the roles of the player after each roll
var score=0 #Score of the player
var results=[] #Store dictionaries in the format {id:point}
var round=0

#RPCs : 

#Added the player list in this instance and updates the Lobby GUI
@rpc("any_peer","reliable","call_local")
func add_player(p_name:String):
	print(player_name," added ",p_name)
	player_names.append(p_name)
	lobby.update_lobby()
	
#Client request the updated player list 
func update_using_host():
	print(player_name," wants to update")
	#Tell the host to updated the list of all the players
	update_player_list.rpc_id(1)
	
@rpc("any_peer","reliable")
func update_player_list():
	print(player_name," tries to update")
	#Telling all the players to update there playerlist 
	set_player_list.rpc(player_names)

#Updates the playerlist for this instance
@rpc("authority","reliable")
func set_player_list(updated_player_names:Array):
	print(player_name," updated player_names to : ",updated_player_names)
	player_names=updated_player_names
	lobby.update_lobby()

#Updates the chit_list for this instance
@rpc("call_remote","reliable")
func update_chit_list(list:Array):
	print(player_name," updated its chit_list")
	chit_list=list
	
#Updates the chit_list for this instance
@rpc("any_peer","call_local","reliable")
func update_results(updated_result:Dictionary):
	print(player_name," updated its results")
	results = updated_result
	round+=1
	score += results[player_id]
	game.score_label.text= "score : "+ str(score)

#to let host know everyone has drawn his chits
var done = 0

# Called by each peer when they finish drawing their chit
@rpc("any_peer","call_local")
func drawn_chits_no():
	done += 1
	# Only the host should check this
	if done >= player_names.size():
		# All players have drawn
		game.show_raja_button()
		done = 0  # Reset for next round
