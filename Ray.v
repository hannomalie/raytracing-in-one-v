module main

import math
import strconv

struct Ray {
	point Vec3
	dir Vec3
}


fn (this Ray) at(t f64) Vec3 {
	return this.point.plus(this.dir.mul(t))
}
fn (this Ray) color(hittable Hittable) Vec3 {
	mut rec := &HitRecord{}
	if hittable.hit(this, 0, strconv.double_plus_infinity, mut rec) {
		return Vec3{rec.normal.x+1, rec.normal.y+1, rec.normal.z+1}.mul(0.5)
	}

	unit_direction := this.dir.unit_vector()
	t := 0.5 * (unit_direction.y + 1.0)
	return Vec3{1.0, 1.0, 1.0}.mul(1.0-t).plus(Vec3{0.5, 0.7, 1.0}.mul(t))
}
struct HitRecord {
	mut:
		p Vec3
		normal Vec3
		t f64
		front_face bool
}
fn (mut this HitRecord) set_face_normal(r Ray, outward_normal Vec3) {
	this.front_face = r.dir.dot(outward_normal) < 0
	this.normal = if this.front_face { outward_normal } else { outward_normal.negate() }
}
interface Hittable {
	hit(r Ray, t_min f64, t_max f64, mut rec &HitRecord) bool
}
