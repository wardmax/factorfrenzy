extends Node

var rng = RandomNumberGenerator.new()
@onready var textbox = $Control/TextEdit
@onready var label = $Control/Label
@onready var submit = $Control/Button

var answer = 0
func _ready():
	pick_numbers()
	
func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("enter")):
		textbox.text = textbox.text.replace(" ","")
		if(answer == textbox.text):
			print("YAY")
			textbox.text = ""
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


func _on_button_pressed() -> void:
	textbox.text = textbox.text.replace(" ","")
	if(answer == textbox.text):
		
			print("YAY")
			textbox.text = ""
			pick_numbers()
