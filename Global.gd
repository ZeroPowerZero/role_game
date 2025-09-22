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

#Const for messages 
const RAJA_MESSAGE := "CONGRATS, YOU WERE THE RAJA AND GOT 1000 POINTS"
const SIPAHI_MESSAGE := "YOU HAD A EASY ROUND AS THE SIPAHI AND GOT 700 POINTS"
const WAZIR_WIN_MASSAGE := "YOU FOUND THE CHOR, AND GOT 800 POINTS"
const WAZIR_LOSS_MESSAGE := "YOU WERE WRONG ... SO NO POINTS FOR YOU"
const CHOR_LOSS_MESSAGE := "YOU GOT CAUGHT SO NOTHING FOR YOU HERE"
const CHOR_WIN_MESSAGE := "CONGRATS , WAZIR DIDN'T FIND YOU, ENJOY THE LOOT"

const MESSAGES_WAZIR_WON ={RAJA:RAJA_MESSAGE,CHOR:CHOR_LOSS_MESSAGE,WAZIR:WAZIR_WIN_MASSAGE,SIPAHI:SIPAHI_MESSAGE}
const MESSAGES_WAZIR_LOST={RAJA:RAJA_MESSAGE,CHOR:CHOR_WIN_MESSAGE,WAZIR:WAZIR_LOSS_MESSAGE,SIPAHI:SIPAHI_MESSAGE}
func get_message(wazir_won:bool)->String:
		return MESSAGES_WAZIR_WON[player_role] if wazir_won else MESSAGES_WAZIR_LOST[player_role]
	
const CHOR_WIN_SCORE=1100

# Dictionary of roles description
const ROLE_MESSAGES := {
	RAJA: "You are the RAJA. Your job is to ask the WAZIR to identify the CHOR.",
	WAZIR: "You are the WAZIR . The RAJA will ask you to guess who the CHOR is.",
	CHOR: "You are the CHOR . Try to stay hidden and avoid being guessed by the WAZIR.",
	SIPAHI: "You are the SIPAHI . You have no special task except to play your role honestly."
}
#Game Player
var player_id:int # The unique ID of the Player 
var player_name: String = "" # The Name of the Player
var player_names: Array[String] = [] #Name of the Players in the Game
var roles: Array[String] = [RAJA,WAZIR,CHOR,SIPAHI] #Roles in the Game (Warning its Shuffled !Never Assume Index)
var is_host: bool = false # Is this instance the Host
var player_role : String #The role of the player
const score_per_role={RAJA:1000,WAZIR:800,SIPAHI:700,CHOR:0}

#Networking 
var latency:float = 0.4 #TODO Latency of the network 

# Resource variables :

#Path of images of card  
var lobby_image_list = ["res://assets/fox.jpg","res://assets/rabbit.jpg","res://assets/lion.jpg","res://assets/horse.jpg"]
#Color of each card 
var lobby_color_list=["#006b3722", "#f6cf4941","#ff00004a","#a764db4a"]
# Note : Keep the path and the color at the same index  
#Card image 
var cards={RAJA:"res://assets/Raja.png",WAZIR:"res://assets/Wazir.png",CHOR:"res://assets/Chor.png",SIPAHI:"res://assets/Sipahi.png"}


#Game variables :
var chit_list=[] # Stores the roles of the player after each roll
var score=0 #Score of the player
var results = {0:0,1:0,2:0,3:0} #Store dictionaries in the format {id:point}
var round_count=0 #Total rounds per game 
var current_round=0 #Current round

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
func update_results(updated_result):
	print(player_name," updated its results")
	for id in results:
		results[id]+=updated_result[id]
	current_round+=1
	score = results[player_id]
	game.score_label.text= "score : "+ str(score)

#to let host know everyone has drawn his chits
var done = 0

# Called by each peer when they finish drawing their chit
@rpc("any_peer","call_local","reliable")
func drawn_chits_no():
	done += 1
	# Only the host should check this
	if done >= player_names.size():
		# All players have drawn
		game.show_raja_button()
		done = 0  # Reset for next round
# to reset the data on back
func reset():
	player_names=[]
	current_round=0
	score=0
	results = {0:0,1:0,2:0,3:0}
	chit_list=[]
	
