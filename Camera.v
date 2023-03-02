module main

struct Camera {
	origin Vec3
	lower_left_corner Vec3
	horizontal Vec3
	vertical Vec3
}
fn create_camera(origin Vec3) Camera {

	aspect_ratio := 16.0 / 9.0
	viewport_height := 2.0
	viewport_width := aspect_ratio * viewport_height
	focal_length := 1.0

	horizontal := Vec3{viewport_width, 0.0, 0.0}
	vertical := Vec3{0.0, viewport_height, 0.0}
	lower_left_corner := origin.minus_vec(horizontal.div(2)).minus_vec(vertical.div(2)).minus_vec(Vec3{0, 0, focal_length})
	return Camera{origin, lower_left_corner, horizontal, vertical}
}

fn (this Camera) get_ray(u f64, v f64) Ray {
	return Ray{this.origin, this.lower_left_corner.plus(this.horizontal.mul(u)).plus(this.vertical.mul(v)).minus_vec(this.origin)}
}

