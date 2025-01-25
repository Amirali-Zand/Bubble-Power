extends Area2D

@export var moveSpeed = 50
@export var health = 2
@export var towardsPlayer = true
var invincible = false
var canAttack = true
var player
var weapon

static var projectileScene  = preload("res://projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player")
	weapon = Weapon.create_enemy_weapon(Enums.WeaponType.shotgun, {})
	add_child(weapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#move(delta)
	if Input.is_action_pressed("p1_shoot"):
		debug_damage()

func takeDamage(damage: float) -> void:
	if invincible:
		return
	invincible = true
	$invincibleDelay.start()
	health -= damage
	if (health <= 0):
		die()
		
func die() -> void:
	queue_free()

func debug_damage() -> void:
	weapon.attack(Vector2(player.position.x - position.x, player.position.y - position.y))


func move(delta: float) -> void:
	var direction = Vector2(player.position.x - position.x, player.position.y - position.y)
	direction = direction/direction.length()
	direction = direction * moveSpeed * delta
	if (!towardsPlayer):
		direction *= -1
	position.x += direction.x
	position.y += direction.y
	
func _on_invincible_delay_timeout() -> void:
	invincible = false


func _on_body_entered(body: Node2D) -> void:
	takeDamage(body.damage)
	body.queue_free()


func _on_attack_delay_timeout() -> void:
	canAttack = true
