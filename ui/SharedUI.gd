extends Control

signal upgrade_ship

onready var trade = $Tabs/Trade
onready var upgrade = $Tabs/Upgrade
onready var jobs = $Tabs/Jobs
onready var info_now = $InfoNow

func _ready():
	PlayerData.connect("money_update", self, "_on_PlayerData_money_update")

func _process(delta):
	if visible:
		if Input.is_key_pressed(KEY_1):
			$Tabs.current_tab = 0
		if Input.is_key_pressed(KEY_2):
			$Tabs.current_tab = 1
		if Input.is_key_pressed(KEY_3):
			$Tabs.current_tab = 2
		if Input.is_key_pressed(KEY_ESCAPE):
			hide()

func update_info(planet):
	jobs.setup(planet)
	
	trade.clean()
	trade.setup()
	
	info_now.update_info()

func set_cash(cash : int):
	# TODO: Add a way to pass cash amount into the trade screen
	upgrade.set_cash_amount(cash)


func _on_HideButton_pressed():
	#update_info()
	hide()


func _on_Upgrade_upgrade():
	emit_signal("upgrade_ship")


func _on_PlayerData_money_update(value):
	trade.clean()
	trade.setup()


func _on_Jobs_job_taken():
	trade.setup_info()
