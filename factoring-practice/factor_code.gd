extends Node

var rng = RandomNumberGenerator.new()
@onready var textbox = $Control/TextEdit
@onready var label = $Control/Label
@onready var submit = $Control/Button
@onready var correct_label = $Control/Label2
@onready var win_audio = $win_audio
@onready var loss_audio = $loss_audio

var answer = 0
var got_correct = false
var start = 0
var got_incorrect = false

func _ready():
	pick_numbers()
	
	
func pick_numbers():
	var c1 = 0
	var c2 = 0
	var possible_a = [1,1,1,1,2,2,2,3,3,3,4,4,5,5,5,6,6,7]
	var a = possible_a[rng.randi_range(0,len(possible_a)-1)]
	var orig_a = a
	if(a == 4):
		c1 = [2,4][rng.randi_range(0,1)]
		c2 = 4/c1
		a = c1
	else:
		c1 = a
		c2 = 1
	var f1 = rng.randi_range(1,10)
	var f2 = rng.randi_range(1,10)
	if(orig_a == 1): orig_a = ""
	var problem = [orig_a, c1*f2+c2*f1,f1*f2]
	if(c1 == 1): c1 = ""
	if(c2 == 1): c2 = ""
	label.text = "Factor: "+str(problem[0])+"x²+"+str(problem[1])+"x+"+str(problem[2])
	answer = "("+str(c1)+"x+"+str(f1)+")("+str(c2)+"x+"+str(f2)+")"
	print(answer)
	
func _on_button_pressed() -> void:
	textbox.text = textbox.text.replace(" ","")
	if(answer == textbox.text):
		got_correct = true
		win_audio.play()
		RenderingServer.set_default_clear_color("276221")
		textbox.text = ""
		pick_numbers()
	else:
		got_incorrect = true
		loss_audio.play()
		RenderingServer.set_default_clear_color("630000")
		

func _process(delta: float) -> void:
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

func is_prime(n: int) -> bool:
	if n < 2:
		return false
	if n == 2:
		return true
	if n % 2 == 0:
		return false

	var i = 3
	while i * i <= n:
		if n % i == 0:
			return false
		i += 2
	return true
