module main

import math

struct Ray {
	point Vec3
	dir Vec3
}


fn (this Ray) at(t f64) Vec3 {
	return this.point.plus(this.dir.mul(t))
}
fn (this Ray) color() Vec3 {
	mut t := hit_sphere(Vec3{0,0,-1}, 0.5, this)
	if t > 0.0 {
		n := this.at(t).minus_vec(Vec3{0,0,-1}).unit_vector()
		return Vec3{n.x+1, n.y+1, n.z+1}.mul(0.5)
	}

	unit_direction := this.dir.unit_vector()

	t = 0.5 * (unit_direction.y + 1.0)
	return Vec3{1.0, 1.0, 1.0}.mul(1.0-t).plus(Vec3{0.5, 0.7, 1.0}.mul(t))
}
fn hit_sphere(center Vec3, radius f64, r Ray) f64 {
	oc := r.point.minus_vec(center)
	a := r.dir.length_squared()
	half_b := oc.dot(r.dir)
	c := oc.length_squared() - (radius * radius)
	discriminant := (half_b * half_b) - (a * c)

	if discriminant < 0 {
		return -1.0
	} else {
		return (-half_b - math.sqrt(discriminant) ) / a
	}
}
