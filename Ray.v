module main

struct Ray {
	point Vec3
	dir Vec3
}


fn (this Ray) at(t f64) Vec3 {
	return this.point.plus(this.dir.mul(t))
}
fn (this Ray) color() Vec3 {
	unit_direction := this.dir.unit_vector()
	t := 0.5 * (unit_direction.y + 1.0)
	a := Vec3{1.0, 1.0, 1.0}.mul((1.0 - t))
	b := Vec3{0.5, 0.7, 1.0}.mul(t)
	return a.plus(b)
}
