extends Control

signal upgrade_ship

onready var trade = $Tabs/Trade
onready var upgrade = $Tabs/Upgrade
onready var jobs = $Tabs/Jobs

func update_info(planet):
	jobs.setup(planet)
	
	trade.clean()
	trade.setup()

func set_cash(cash : int):
	# TODO: Add a way to pass cash amount into the trade screen
	upgrade.set_cash_amount(cash)


func _on_HideButton_pressed():
	#update_info()
	hide()


func _on_Upgrade_upgrade():
	emit_signal("upgrade_ship")
