class_name ExpBar extends ProgressBar

#region Variables

var current_exp :int= 0: set = set_exp
var level :int= 1: set = set_level
var Exp_Data_Table :Dictionary= {}

const EXP_DATA_BASE = ("res://UI/Experience Bar-Coin/ExpDataBase/ExpDataBase.json")
const MAX_LEVEL :int= 5

#endregion


func _ready() -> void:
	Exp_Data_Table = get_exp_data()
	set_exp(0)
	
func get_exp_data() -> Dictionary:
	var file = FileAccess.open(EXP_DATA_BASE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data
	
func get_needed_exp_amount(level) -> int:
	if Exp_Data_Table.has(str(level)):
		return Exp_Data_Table[str(level)]["needed_exp"]
	else:
		push_error("Exp Data Table has no str(level) in it.")
		return 000
	
func set_exp(new_exp: int):
	current_exp = new_exp
	
	print(str(new_exp) + " gained. Current exp: " +str(current_exp))

	var needed_exp :int= get_needed_exp_amount(level)
	if current_exp > needed_exp and level < MAX_LEVEL:
		level += 1
		current_exp -= needed_exp
		
	elif level == MAX_LEVEL:
		current_exp = 0
	value = current_exp
func set_level(new_level: int):
	level = new_level
	%Level.text = "Level: " + str(level)


	
