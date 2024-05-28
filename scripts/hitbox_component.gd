extends Area2D

@export var health_component : HealthComponent

func damage(amount):
	if(health_component):
		return health_component.take_damage(amount)
