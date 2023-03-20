module main

import math

struct Sky {
	color_top Vec3 = Vec3{1.0, 1.0, 1.0}
	color_bottom Vec3 = Vec3{0.5, 0.7, 1.0}
}

fn (this Sky) shade(r Ray) Vec3 {
	unit_direction := r.dir.unit_vector()
	t := 0.5 * (unit_direction.y + 1.0)
	return this.color_top.mul(1.0-t).plus(this.color_bottom.mul(t))
}
