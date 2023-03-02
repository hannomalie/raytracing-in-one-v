module main

import os

fn main() {
	// Image
	aspect_ratio := 16.0 / 9.0
	image_width := 400
	image_height := (image_width / aspect_ratio).str().int()
	samples_per_pixel := i8(20)

	// World
	world := [
		Hittable(Sphere{Vec3{0,0,-1}, 0.5}),
		Sphere{Vec3{0,-100.5,-1}, 100}
	]

	// Camera
	cam := create_camera(Vec3{0,0,0})

	mut file := os.open_file('./image.ppm', 'w')!

	// Render
	file.write_string('P3\n${image_width} ${image_height}\n255\n')!

	for j := image_height - 1; j > 0; j-- {
		println('Scanlines remaining: ${j}')

		for i in 0 .. image_width {

			resulting_color := if samples_per_pixel == 1 {
				u := (i + f64(0.5)) / (image_width-1)
				v := (j + f64(0.5)) / (image_height-1)
				r := cam.get_ray(u, v)
				pixel_color := world.color(r)
				pixel_color.to_color(1)
			} else {
				mut pixel_color := Vec3{0, 0, 0}

				for s := 0; s < samples_per_pixel; s++ {
					u := (i + random_double()) / (image_width-1)
					v := (j + random_double()) / (image_height-1)
					r := cam.get_ray(u, v)
					pixel_color = pixel_color.plus(world.color(r))
				}

				pixel_color.to_color(samples_per_pixel)
			}

			file.write_string('${resulting_color.x.str().int()} ${resulting_color.y.str().int()} ${resulting_color.z.str().int()} \n')!
		}
	}

	println('Finished rendering')
}
