extends Control

onready var trade = $Tabs/Trade
onready var upgrade = $Tabs/Upgrade

func set_cash(cash : int):
	# TODO: Add a way to pass cash amount into the trade screen
	upgrade.set_cash_amount(cash)
