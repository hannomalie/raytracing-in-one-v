module main

import math

struct Triangle {
	a Vec3
	b Vec3
	c Vec3
	material Material
}

fn (this Triangle) hit(r Ray, t_min f64, t_max f64, mut rec &HitRecord) bool {

	v0 := this.a
	v1 := this.b
	v2 := this.c

	// compute the plane's normal
	v0v1 := v1.minus_vec(v0)
	v0v2 := v2.minus_vec(v0)
	// no need to normalize
	normal := v0v1.cross(v0v2)
	area2 := normal.length()

	// Step 1: finding P

	// check if the ray and plane are parallel.
	n_dot_ray_direction := normal.dot(r.dir)
	// they are parallel, so they don't intersect!
	if math.abs(n_dot_ray_direction) < math.epsilon { return false }

	// compute d parameter using equation 2
	d := normal.negate().dot(v0)

	// compute t (equation 3)
	t := -(normal.dot(r.origin) + d) / n_dot_ray_direction

	// check if the triangle is behind the ray
	if t < t_min { return false } // the triangle is behind us
	if t > t_max { return false } // the triangle is out of range

	// compute the intersection point using equation 1
	intersection_point := r.at(t)//r.origin + r.dir.mul(t)

	// Step 2: inside-outside test
	// C is vector perpendicular to triangle's plane

	// edge 0
	edge0 := v1.minus_vec(v0)
	vp0 := intersection_point.minus_vec(v0)
	mut cross := edge0.cross(vp0)
	if normal.dot(cross) < 0 { return false } // P is on the right side

	// edge 1
	edge1 := v2.minus_vec(v1)
	vp1 := intersection_point.minus_vec(v1)
	cross = edge1.cross(vp1)
	if normal.dot(cross) < 0 { return false } // P is on the right side

	// edge 2
	edge2 := v0.minus_vec(v2)
	vp2 := intersection_point.minus_vec(v2)
	cross = edge2.cross(vp2)
	if normal.dot(cross) < 0 { return false } // P is on the right side

	rec.t = t
	rec.p = r.at(rec.t)

	n_x := this.a.y * this.b.z - this.a.z * this.b.y
	n_y := this.a.z * this.b.x - this.a.x * this.b.z
	n_z := this.a.x * this.b.y - this.a.y * this.b.x

	outward_normal := rec.p.minus_vec(Vec3{n_x, n_y, n_z})
	rec.set_face_normal(r, outward_normal)
	rec.material = this.material

	return true // this ray hits the triangle
}
