module main

import rand

fn random_double() f64 {
	return rand.f64()
}

fn random_double_in_range(min f64, max f64) f64 {
	return min + (max - min) * random_double()
}

fn clamp(x f64, min f64, max f64) f64 {
	return if x < min {
		min
	} else if x > max {
		max
	} else {
		x
	}
}
