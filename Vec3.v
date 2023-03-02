module main

import math

struct Vec3 {
	x f64
	y f64
	z f64
}
fn (this Vec3) minus() Vec3 {
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

fn (this Vec3) to_color(samples_per_pixel i8) Vec3 {
	return if samples_per_pixel == 1 {
		// Write the translated [0,255] value of each color component.
		this.mul(255.999)
	} else {
		// Divide the color by the number of samples.
		scale := 1.0 / f64(samples_per_pixel)
		r_scaled := this.x * scale
		g_scaled := this.y * scale
		b_scaled := this.z * scale

		// Write the translated [0,255] value of each color component.
		Vec3{
			clamp(r_scaled, 0.0, 0.999),
			clamp(g_scaled, 0.0, 0.999),
			clamp(b_scaled, 0.0, 0.999)
		}.mul(255.999)
	}
}
