class_name ExpCoin extends Pickup

@export var xp_amount :int= 0


func on_pickup():
	ExperienceBar.current_exp += xp_amount
	print(ExperienceBar.current_exp)
