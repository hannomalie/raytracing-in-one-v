module main

import math

struct Vec3 {
	x f64
	y f64
	z f64
}
fn (this Vec3) negate() Vec3 {
	return Vec3{ x: -this.x, y: -this.y, z: -this.z}
}
fn (this Vec3) minus_vec(v Vec3) Vec3 {
	return Vec3{ x: this.x - v.x, y: this.y - v.y, z: this.z -  v.z}
}
fn (this Vec3) get(index int) f64 {
	return match index {
		1 { this.x }
		2 { this.y }
		3 { this.z }
		else { panic("Passed index must be 0, 1 or 2, but is $index") }
	}
}

fn (this Vec3) plus(v Vec3) Vec3 {
	return Vec3{ x: this.x + v.x, y: this.y + v.y, z: this.z + v.z}
}
fn (this Vec3) mul(v f64) Vec3 {
	return Vec3{ x: this.x * v, y: this.y * v, z: this.z * v}
}
fn (this Vec3) mul_vec(v Vec3) Vec3 {
	return Vec3{ x: this.x * v.x, y: this.y * v.y, z: this.z * v.z}
}
fn (this Vec3) div(v f64) Vec3 {
	return Vec3{ x: this.x / v, y: this.y / v, z: this.z / v}
}
fn (this Vec3) length() f64 {
	return math.sqrt(this.length_squared())
}
fn (this Vec3) length_squared() f64 {
	return this.x*this.x + this.y*this.y + this.z*this.z
}


fn (this Vec3) println_custom() {
	println("${this.x} ${this.y} ${this.z}")
}

fn (this Vec3) dot(v Vec3) f64 {
	return this.x * v.x + this.y * v.y + this.z * v.z
}
fn (this Vec3) cross(v Vec3) Vec3 {
	return Vec3{
		x: this.y * v.z - this.z * v.y,
		y: this.z * v.x - this.x * v.z,
		z: this.x * v.y - this.y * v.x
	}
}
fn (this Vec3) unit_vector() Vec3 {
	return this.div(this.length())
}
fn (this Vec3) reflect(n &Vec3) Vec3 {
	return this.minus_vec(n.mul(2 * this.dot(n)))
}

fn (this Vec3) to_color(samples_per_pixel i8) Vec3 {
	return if samples_per_pixel == 1 {
		// Write the translated [0,255] value of each color component.
		r := math.sqrt(this.x)
		g := math.sqrt(this.y)
		b := math.sqrt(this.z)

		// Write the translated [0,255] value of each color component.
			Vec3{
			clamp(r, 0.0, 0.999),
			clamp(g, 0.0, 0.999),
			clamp(b, 0.0, 0.999)
		}.mul(255.999)
	} else {
		// Divide the color by the number of samples.
		scale := 1.0 / f64(samples_per_pixel)
		r_scaled := math.sqrt(this.x * scale)
		g_scaled := math.sqrt(this.y * scale)
		b_scaled := math.sqrt(this.z * scale)

		// Write the translated [0,255] value of each color component.
		Vec3{
			clamp(r_scaled, 0.0, 0.999),
			clamp(g_scaled, 0.0, 0.999),
			clamp(b_scaled, 0.0, 0.999)
		}.mul(255.999)
	}
}

fn random_vec() Vec3 {
	return Vec3 {random_double(), random_double(), random_double() }
}

fn random_vec_in_range(min f64, max f64) Vec3 {
	return Vec3 {random_double_in_range(min,max), random_double_in_range(min,max), random_double_in_range(min,max) }
}
fn random_in_unit_sphere() Vec3 {
	for 0 != 1 {
		p := random_vec_in_range(-1,1)
		if p.length_squared() >= 1 { continue }
		return p
	}
	panic("Not able to find a random vector on a unit sphere")
}
fn random_unit_vector() Vec3 {
	return random_in_unit_sphere().unit_vector()
}
fn random_in_hemisphere(normal Vec3) Vec3 {
	in_unit_sphere := random_in_unit_sphere()
	in_same_hemisphere_as_normal := in_unit_sphere.dot(normal) > 0.0
	return if in_same_hemisphere_as_normal {
		in_unit_sphere
	} else {
		in_unit_sphere.negate()
	}
}
fn (this Vec3) near_zero() bool {
	s := 1e-8
	return (math.abs(this.x) < s) && (math.abs(this.y) < s) && (math.abs(this.z) < s)
}
