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

fn (this Vec3) to_color_line() string {
	adjusted := this.mul(255.999)
	return "${adjusted.x.str().int()} ${adjusted.y.str().int()} ${adjusted.z.str().int()}"
}
