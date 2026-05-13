class_name Upgrade_Manager
extends Node3D

var init = true
var min_target_flavors = 2
var max_target_flavors = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bread4.make_inactive()
	$Bread3.make_inactive()
	
	$Raccoon.make_inactive()
	$Raccoon3.make_inactive()
	init_bread()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if init:
		$SauceMachine.init_machine(0)
		$SauceMachine2.init_machine(1)
		$SauceMachine3.init_machine(2)
		$SauceMachine4.init_machine(3)
		init = false



func good_sandwich_event():
	get_parent().good_sandwich_event()
	$SandwichCounter.addSandwich()
	pass
	
func bad_sandwich_event():
	get_parent().bad_sandwich_event()
	pass
	
func init_bread():
	$Bread.min_target_flavors = min_target_flavors
	$Bread.max_target_flavors = max_target_flavors

	$Bread2.max_target_flavors = max_target_flavors
	$Bread2.min_target_flavors = min_target_flavors

	$Bread3.max_target_flavors = max_target_flavors
	$Bread3.min_target_flavors = min_target_flavors

	$Bread4.max_target_flavors = max_target_flavors
	$Bread4.min_target_flavors = min_target_flavors

	
	$Raccoon.min_target_flavors = min_target_flavors
	$Raccoon.max_target_flavors = max_target_flavors
	#$Racoon. randomize_target()
	$Raccoon2.max_target_flavors = max_target_flavors
	$Raccoon2.min_target_flavors = min_target_flavors
	#$Racoon2. randomize_target()
	$Raccoon3.max_target_flavors = max_target_flavors
	$Raccoon3.min_target_flavors = min_target_flavors
	#$Racoon3. randomize_target()
	$Raccoon4.max_target_flavors = max_target_flavors
	$Raccoon4.min_target_flavors = min_target_flavors
	#$Racoon4. randomize_target()
	
func startUpgradeTime():
	get_parent().startUpgradeTime()
	
func startUpgradeLights():
	if not $Bread3.is_active:
		$Bread3_light.light_energy = 10
	if not $Bread4.is_active:
		$Bread4_light.light_energy = 10
	if not $Raccoon3.is_active:
		$Bread3_light2.light_energy = 10
	if not $Raccoon.is_active:
		$Bread4_light2.light_energy = 10
	if not $SauceMachine.is_active:
		$SauceMachine_light.light_energy = 10
	if not $SauceMachine2.is_active:
		$SauceMachine2_light.light_energy = 10
	if not $SauceMachine3.is_active:
		$SauceMachine3_light.light_energy = 10
	if not $SauceMachine4.is_active:
		$SauceMachine4_light.light_energy = 10
	
func stopUpgradeTime():
	$Bread4_light.light_energy = 0
	$Bread3_light.light_energy = 0
	$Bread4_light2.light_energy = 0
	$Bread3_light2.light_energy = 0
	$SauceMachine_light.light_energy = 0
	$SauceMachine2_light.light_energy = 0
	$SauceMachine4_light.light_energy = 0
	$SauceMachine3_light.light_energy = 0
	
