module main

import net.websocket
import vweb
import db.sqlite
import crypto.sha256

struct Account {
	id int [nonnull; primary]
pub mut:
	username string [nonnull]
	password string [nonnull]
	salt     string [nonnull]
	token    string [nonnull]
}

struct App {
	vweb.Context
pub mut:
	title string
	db    sqlite.DB
}

const (
	websocket_port = 8080
	port           = 8888
)

pub fn (app &App) before_request() {
	println('New vweb connection : ${app.ip()}')
}

fn main() {
	mut websocket_server := websocket.new_server(.ip, websocket_port, '')
	mut app := App{
		title: 'Chat'
	}

	app.init_databases()

	app.handle_static('src/public', true)

	spawn vweb.run(app, port)

	websocket_server.on_connect(client_connected) or { panic(err) }

	websocket_server.on_message(fn (mut _ websocket.Client, msg &websocket.Message) ! {
		message := msg.payload.bytestr()
		if message.trim_space().is_blank() {
			return
		}
		println(message)
	})

	websocket_server.listen() or { panic('Error while listening : ${err}') }
}

['/']
pub fn (mut app App) index() vweb.Result {
	cookie := app.get_cookie('session') or {
		return app.redirect('/login')
	}
	account := app.get_account_by_token(cookie)
	if account.id == 0 {
		return app.redirect('/login')
	}
	username := account.username
	return $vweb.html()
}

['/login']
pub fn (mut app App) page_login() vweb.Result {
	cookie := app.get_cookie('session') or { return $vweb.html() }
	if app.get_account_by_token(cookie).id == 0 {
		return $vweb.html()
	}
	return app.redirect('/')
}

['/login'; post]
pub fn (mut app App) post_login(username string, password string) vweb.Result {
	account := app.get_account_by_username(username) or {
		eprintln(err)
		return app.redirect('/login')
	}
	if account.id == 0 {
		return app.redirect('/login?err=Bad username or password !')
	}
	if sha256.hexhash(account.salt + sha256.hexhash(password)) == account.password {
		app.set_cookie(name: 'session', value: account.token)
		return app.redirect('/')
	} else {
		return app.redirect('/login?err=Bad username or password !')
	}
}

['/register']
pub fn (mut app App) page_register() vweb.Result {
	cookie := app.get_cookie('session') or { return $vweb.html() }
	if app.get_account_by_token(cookie).id == 0 {
		return $vweb.html()
	}
	return app.redirect('/')
}

['/register'; post]
pub fn (mut app App) post_register(username string, password string) vweb.Result {
	if app.account_exists(username) {
		return app.redirect('/register?err=Account already exists !')
	}
	if is_username_valid(username) && password.len >= 8 {
		account := app.insert_account(username, password) or {
			return app.redirect('/register?err=${err}')
		}
		app.set_cookie(name: 'session', value: account.token)
		return app.redirect('/')
	}
	return app.redirect('/register?err=Username must begin by a letter and contain only letters, numbers and underscores and password must be at least 8 characters long')
}

fn client_connected(mut c websocket.ServerClient) !bool {
	if c.resource_name == '/' {
		println('New websocket connection : ${c.client.conn.peer_addr()!}')
		return true
	}
	return false
}
