module main

import math
import strconv

struct Ray {
	origin Vec3
	dir Vec3
}


fn (this Ray) at(t f64) Vec3 {
	return this.origin.plus(this.dir.mul(t))
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
		material Material
}
fn (mut this HitRecord) set_face_normal(r Ray, outward_normal Vec3) {
	this.front_face = r.dir.dot(outward_normal) < 0
	this.normal = if this.front_face { outward_normal } else { outward_normal.negate() }
}
type Hittable = Sphere | Triangle

fn (this Hittable) hit(r Ray, t_min f64, t_max f64, mut rec &HitRecord) bool {
	return match this {
		Sphere { this.hit(r, t_min, t_max, mut &rec) }
		Triangle { this.hit(r, t_min, t_max, mut &rec) }
	}
}

fn (this []Hittable) hit(r Ray, t_min f64, t_max f64) (bool, HitRecord) {
	mut temp_rec := HitRecord{}
	mut hit_anything := false
	mut closest_so_far := t_max
	mut result_record := temp_rec

	for object in this {
		if object.hit(r, t_min, closest_so_far, mut &temp_rec) {
			hit_anything = true
			closest_so_far = temp_rec.t
			result_record = temp_rec
		}
	}

	return hit_anything, result_record
}

fn (this []Hittable) color(r Ray, depth i32) Vec3 {
	// If we've exceeded the ray bounce limit, no more light is gathered.
	if depth <= 0 { return Vec3{} }

	mut hit, rec := this.hit(r, 0, math.inf(1))
	return if hit {
		scatter_result := rec.material.scatter(r, rec)
		if scatter_result.foo {
			this.color(scatter_result.scattered, depth - 1).mul_vec(scatter_result.attenuation)
		} else {
				Vec3{1, 0, 0}
		}
	} else {
		unit_direction := r.dir.unit_vector()
		t := 0.5 * (unit_direction.y + 1.0)
			Vec3{1.0, 1.0, 1.0}.mul(1.0-t).plus(Vec3{0.5, 0.7, 1.0}.mul(t))
	}
}
