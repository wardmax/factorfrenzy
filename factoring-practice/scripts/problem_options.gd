extends Control

var largest_a = 7
var checked_a = [true]

func _ready():
	#fill all with false
	var fill_falses = []
	fill_falses.resize(largest_a-1)
	fill_falses.fill(false)
	checked_a.append_array(fill_falses)
	$"vbox1/1".button_pressed = true
	#connect all check boxes
	for cb in $vbox1.get_children():
		if cb is CheckBox:
			cb.toggled.connect(_on_any_checkbox_toggled.bind(cb))
	get_possible_a()

func get_options():
	pass

func _on_any_checkbox_toggled(pressed: bool, which: CheckBox) -> void:
	if pressed:
		checked_a[int(which.text)-1] = true
	else:
		checked_a[int(which.text)-1] = false

func get_possible_a():
	var pop_a =[]
	for i in range(len(checked_a)):
		if(checked_a[i]):
			pop_a.append(i+1)
	return pop_a
	
func include_gcf():
	return $vbox2/gcf.button_pressed
	
#quick select for checkboxes===================
func _on_all_pressed() -> void:
	for cb in $vbox1.get_children():
		if cb is CheckBox:
			cb.button_pressed = true

func _on_none_pressed() -> void:
	for cb in $vbox1.get_children():
		if cb is CheckBox:
			cb.button_pressed = false

func _on_prime_pressed() -> void:
	for cb in $vbox1.get_children():
		if cb is CheckBox:
			if(is_prime(int(cb.text))):
				cb.button_pressed = true
		
func is_prime(n: int) -> bool:
	if n <= 1:
		return false		
	if n == 2:
		return true
	if n % 2 == 0:
		return false

	var limit = int(sqrt(n))
	for i in range(3, limit + 1, 2):
		if n % i == 0:
			return false
	return true


func _on_close_pressed() -> void:
	self.visible = false
