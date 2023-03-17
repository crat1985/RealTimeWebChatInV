module main

import db.sqlite
import rand
import crypto.sha256

fn (mut app App) init_databases() {
	app.db = sqlite.connect('chat') or { panic(err) }

	sql app.db {
		create table Account
	}
}

fn (mut app App) get_account_by_username(username string) !Account {
	account := sql app.db {
		select from Account where username == username
	} or {
		return Account{id: 0}
	}
	
	if account.len > 1 {
		return error("Multiple accounts with same username ! This should never happen")
	}
	return account[0]
}

fn (mut app App) get_account_by_id(id int) Account {
	return sql app.db {
		select from Account where id == id limit 1
	}
}

fn (mut app App) account_exists(username string) bool {
	if app.get_account_by_username(username) or {
		eprintln(err)
		return false
	}.id == 0 {
		return false
	}
	return true
}

fn (mut app App) insert_account(username string, clear_password string) !Account {
	if app.account_exists(username) {
		return error("Account already exists !")
	}

	salt := rand.ascii(8)

	mut token := ""

	for {
		token = rand.ascii(256)

		_ := sql app.db {
			select from Account where token == token
		} or {
			break
		}
	}

	account := Account{
		username: username
		password: sha256.hexhash(salt+sha256.hexhash(clear_password))
		salt: salt
		token: token
	}

	sql app.db {
		insert account into Account
	}

	return app.get_account_by_username(username)
}

fn (mut app App) get_account_by_token(token string) Account {
	return sql app.db {
		select from Account where token == token limit 1
	}
}