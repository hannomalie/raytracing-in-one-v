module main

import math

fn test_hit_happens() {
	material_center := LambertianMaterial{Vec3{0.7, 0.3, 0.3}}
	triangle := Triangle{Vec3{-1,-1,-1}, Vec3{1,-1,-1}, Vec3{0,1,-1}, material_center}
	ray := Ray{Vec3{
		x: 0.0
		y: 0.0
		z: 0.0
	}, Vec3{
		x: 0.0
		y: 0.0
		z: -1.0
	}}

	mut hit_record := HitRecord{}
	hit := triangle.hit(ray, 0, math.inf(1), mut &hit_record)
	assert hit == true
}
fn test_hit_doesnt_happen() {
	material_center := LambertianMaterial{Vec3{0.7, 0.3, 0.3}}
	triangle := Triangle{Vec3{-1,-1,-1}, Vec3{1,-1,-1}, Vec3{0,1,-1}, material_center}
	ray := Ray{Vec3{
		x: 0.0
		y: 0.0
		z: 0.0
	}, Vec3{
		x: -1.0
		y: 1.0
		z: -1.0
	}.unit_vector()}

	mut hit_record := HitRecord{}
	hit := triangle.hit(ray, 0, math.inf(1), mut &hit_record)
	assert hit == false
}
