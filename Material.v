module main

interface Material {
	scatter(r_in &Ray, rec &HitRecord) ScatterResult
}

struct LambertianMaterial {
	albedo Vec3
}

struct ScatterResult {
	hit_record HitRecord
    attenuation Vec3
	scattered Ray
	foo bool
}
fn (this LambertianMaterial) scatter(r_in &Ray, rec &HitRecord) ScatterResult {
	mut scatter_direction := rec.normal.plus(random_unit_vector())

	// Catch degenerate scatter direction
	if scatter_direction.near_zero() { scatter_direction = rec.normal }

	scattered := Ray{rec.p, scatter_direction}
	return ScatterResult{rec, this.albedo, scattered, true}
}

struct Metal {
	albedo Vec3
}
fn (this Metal) scatter(r_in &Ray, rec &HitRecord) ScatterResult {
	reflected := r_in.dir.unit_vector().reflect(rec.normal)
	scattered := Ray{rec.p, reflected}
	attenuation := this.albedo
	return ScatterResult{rec, attenuation, scattered, scattered.dir.dot(rec.normal) > 0}
}
