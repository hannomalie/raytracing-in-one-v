module main

import math

struct Sphere {
	center Vec3
	radius f64 = 1
}
fn (this Sphere) hit(r Ray, t_min f64, t_max f64, mut rec &HitRecord) bool {
	oc := r.point.minus_vec(this.center)
	a := r.dir.length_squared()
	half_b := oc.dot(r.dir)
	c := oc.length_squared() - (this.radius * this.radius)

	discriminant := (half_b * half_b) - (a * c)
	if discriminant < 0 { return false }

	sqrtd := math.sqrt(discriminant)

	// Find the nearest root that lies in the acceptable range.
	mut root := (-half_b - sqrtd) / a
	if root < t_min || t_max < root {
		root = (-half_b + sqrtd) / a
		if root < t_min || t_max < root {
			return false
		}
	}

	rec.t = root
	rec.p = r.at(rec.t)
	outward_normal := rec.p.minus_vec(this.center).div(this.radius)
	rec.set_face_normal(r, outward_normal)

	return true
}

fn (this []Hittable) hit(r Ray, t_min f64, t_max f64, mut rec &HitRecord) bool {
	mut temp_rec := HitRecord{}
	mut hit_anything := false
	mut closest_so_far := t_max

	for object in this {
		if object.hit(r, t_min, closest_so_far, mut temp_rec) {
			hit_anything = true
			closest_so_far = temp_rec.t
			rec = temp_rec
		}
	}

	return hit_anything
}
