extends Node

var rng = RandomNumberGenerator.new()
@onready var textbox = $Control/TextEdit
@onready var label = $Control/Label
@onready var submit = $Control/Button
@onready var correct_label = $Control/Label2
@onready var win_audio = $win_audio
@onready var loss_audio = $loss_audio
@onready var options_menu = $Control/CheckBox

var popup_options = 0

var answers = []
var got_correct = false
var start = 0
var got_incorrect = false
var possible_a = [1]


func _ready():
	textbox.keep_editing_on_text_submit = true
	get_and_display_new_problem()
	
func get_options():
	popup_options.hide_on_item_selection = false
	print(popup_options.get_item_text(1))
		
func get_and_display_new_problem():
	#(c1x + f1)(c2x+f2)
	var gcf = 1
	var c1 = 0
	var c2 = 0
	if(len(get_tree().get_first_node_in_group("options_scene").get_possible_a()) >0):
		possible_a = get_tree().get_first_node_in_group("options_scene").get_possible_a()
	else:
		possible_a = [1]
	print(possible_a)
	var a = possible_a[rng.randi_range(0,len(possible_a)-1)]
	
	if(get_tree().get_first_node_in_group("options_scene").include_gcf()):
		gcf = rng.randi_range(1,3)
	
	if(a == 4):
		c1 = [2,4][rng.randi_range(0,1)]
		c2 = 4/c1
		a = c1
		print(c1,c2)
	else:
		c1 = a
		c2 = 1
		
	#pick constants in linear factors
	var f1 = rng.randi_range(1,10)
	var f2 = rng.randi_range(1,10)
	#ensure no extra gcf
	if(c1 != 1):
		while(f1%c1 == 0 or c1%f1 == 0): f1 = rng.randi_range(1,10)
	if(c2 != 1):
		while(f2%c2 == 0 or c2%f2 == 0):f2 = rng.randi_range(1,10)
	
	build_problem(gcf,a,c1,c2,f1,f2)
	build_answers(gcf,a,c1,c2,f1,f2)
	
	print(answers[0])

func build_problem(gcf,a,c1,c2,f1,f2):
	var a_value = gcf*a
	var b_value = gcf*c1*f2+c2*f1
	var c_value = gcf*f1*f2
	if(a_value==1):
		label.text = "Factor: x²+"+str(b_value)+"x+"+str(c_value)
	else:
		label.text = "Factor: "+str(gcf*a)+"x²+"+str(b_value)+"x+"+str(c_value)
	
func build_answers(gcf,a,c1,c2,f1,f2):
	if(gcf == 1): gcf = ""
	if(c1 == 1): c1 = ""
	if(c2 == 1): c2 = ""
	answers = [str(gcf)+"("+str(c1)+"x+"+str(f1)+")("+str(c2)+"x+"+str(f2)+")",
				str(gcf)+"("+str(c2)+"x+"+str(f2)+")("+str(c1)+"x+"+str(f1)+")"]



#UI pieces ===============================
func _on_button_pressed() -> void:
	check_answer()
		
func check_answer():
	textbox.text = textbox.text.replace(" ","")
	if(textbox.text in answers):
		got_correct = true
		win_audio.play()
		RenderingServer.set_default_clear_color("276221")
		textbox.text = ""
		get_and_display_new_problem()
	else:
		got_incorrect = true
		loss_audio.play()
		RenderingServer.set_default_clear_color("630000")
	textbox.caret_column = textbox.text.length()

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_text_submit")):
		check_answer()
	if(start > .8):
		start = 0
		got_correct = false
		got_incorrect = false
	if(got_correct):
		start += delta
		RenderingServer.set_default_clear_color("276221")
	elif(got_incorrect):
		start += delta
		RenderingServer.set_default_clear_color("630000")
	else:
		RenderingServer.set_default_clear_color("4d4d4d")


func _on_problem_options_pressed() -> void:
	$problem_options.visible = !$problem_options.visible


func _on_refresh_pressed() -> void:
	get_and_display_new_problem()
