extends BaseTargetProjectile

func hit_target():
	super.hit_target()
	$particles.emitting = false

