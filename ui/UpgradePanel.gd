extends Control

signal upgrade

export(String) var cash_amount_text_prefix

onready var _ship_texture_rect = $Container/LeftSide/ShipTextureRect
onready var _cash_amount_label = $Container/RightSide/VBoxContainer/CashAmount

func set_ship_texture(texture : Texture) -> void:
	_ship_texture_rect.texture = texture

func set_cash_amount(cash_amount : int) -> void:
	_cash_amount_label.text = cash_amount_text_prefix + " " + str(cash_amount)

func _on_UpgradeButton_pressed():
	emit_signal("upgrade")
