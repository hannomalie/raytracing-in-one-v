module main

import os

fn main() {
	// Image
	aspect_ratio := 16.0 / 9.0
	image_width := 400
	image_height := (image_width / aspect_ratio).str().int()

	// Camera
	viewport_height := 2.0
	viewport_width := aspect_ratio * viewport_height
	focal_length := 1.0
	origin := Vec3{0, 0, 0}
	horizontal := Vec3{viewport_width, 0, 0}
	vertical := Vec3{0, viewport_height, 0}

	lower_left_corner := origin.minus_vec(horizontal.div(2)).minus_vec(vertical.div(2)).minus_vec(Vec3{0, 0, focal_length})

	mut file := os.open_file('./image.ppm', 'w')!

	// Render
	file.write_string('P3\n${image_width} ${image_height}\n255\n')!

	for j := image_height - 1; j > 0; j-- {
		println('Scanlines remaining: ${j}')

		for i in 0 .. image_width {
			u := i.str().f64() / (image_width-1)
			v := j.str().f64() / (image_height-1)
			r := Ray{origin, lower_left_corner.plus(horizontal.mul(u)).plus(vertical.mul(v).minus_vec(origin))}
			pixel_color := r.color(Sphere{Vec3{0,0,-1}, 0.5})

			file.write_string('${pixel_color.to_color_line()}\n')!
		}
	}

	println('Finished rendering')
}
