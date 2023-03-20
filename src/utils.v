module main

import rand

const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'.split("")

fn is_username_valid(username string) bool {
	for index, c in username {
		if index == 0 && !c.is_letter() {
			return false
		}
		if c.is_alnum() || c.ascii_str() == '_' {
			continue
		}
		return false
	}
	return true
}

fn rand_printable_ascii(length int) !string {
	if length<1 {
		return error("0 forbidden")
	}
	mut final := ""
	for _ in 0..length {
		final += rand.element(characters) or {return err}
	}
	return final
}