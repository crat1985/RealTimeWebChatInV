module main

fn is_username_valid(username string) bool {
	for index, c in username {
		if index == 0 && !c.is_letter() {
			return false
		}
		if c.is_alnum() || c.ascii_str() == "_" {
			continue
		}
		return false
	}
	return true
}