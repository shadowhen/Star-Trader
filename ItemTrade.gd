extends HBoxContainer

class_name ItemTrade

enum Cargo {
	FOOD,
	CLOTHES,
	WATER
}

signal trade_amount(cargo_type, currency, amount)
export (Cargo) var _cargo_type = Cargo.FOOD
var price = 0 setget _set_price

onready var price_label = $"Price"

func _set_price(new_price):
	price = new_price
	price_label.text = str(price)


func _on_Buy_pressed():
	emit_signal("trade_amount", _cargo_type, 0, 1)


func _on_Sell_pressed():
	emit_signal("trade_amount", _cargo_type, 0, -1)


static func get_cargo_str(cargo_type):
	match cargo_type:
		Cargo.FOOD:
			return "food"
		Cargo.CLOTHES:
			return "clothes"
		Cargo.WATER:
			return "water"
		_:
			return "unknown"
