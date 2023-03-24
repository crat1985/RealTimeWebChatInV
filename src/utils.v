module main

import rand

const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'.split('')

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
	if length < 1 {
		return error('0 forbidden')
	}
	mut final := ''
	for _ in 0 .. length {
		final += rand.element(characters) or { return err }
	}
	return final
}

fn (mut app App) get_account() !Account {
	cookie := app.get_cookie('session') or { return error("") }
	if cookie.len != token_len {
		return error("")
	}
	account := app.get_account_by_token(cookie)
	if account.id == 0 {
		app.set_cookie(name: "session", value: "")
		return error("")
	}
	return account
}

fn (mut app App) is_connected() bool {
	cookie := app.get_cookie('session') or {
		return false
	}
	if cookie.len != token_len {
		app.set_cookie(name: "session", value: "")
		return false
	}
	if app.get_account_by_token(cookie).id == 0 {
		app.set_cookie(name: "session", value: "")
		return false
	}
	return true
}