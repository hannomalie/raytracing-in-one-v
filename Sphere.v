module main

import math

struct Sphere {
	center Vec3
	radius f64 = 1
	material Material
}

fn (this Sphere) hit(r Ray, t_min f64, t_max f64) ?&HitRecord {
	oc := r.origin.minus_vec(this.center)
	a := r.dir.length_squared()
	half_b := oc.dot(r.dir)
	c := oc.length_squared() - (this.radius * this.radius)

	discriminant := (half_b * half_b) - (a * c)
	if discriminant < 0 { return none }

	sqrtd := math.sqrt(discriminant)

	// Find the nearest root that lies in the acceptable range.
	mut root := (-half_b - sqrtd) / a
	if root < t_min || t_max < root {
		root = (-half_b + sqrtd) / a
		if root < t_min || t_max < root {
			return none
		}
	}

	mut rec := &HitRecord{}
	rec.t = root
	rec.p = r.at(rec.t)
	outward_normal := rec.p.minus_vec(this.center).div(this.radius)
	rec.set_face_normal(r, outward_normal)
	rec.material = this.material

	return rec
}
