module main

import net.websocket
import vweb
import db.sqlite

struct Account {
	id int [primary; nonnull]
pub mut:
	pseudo string
	password string
	salt string
}

struct App {
	vweb.Context
pub mut:
	title string
}

const (
	websocket_port = 8080
	port = 8888
)

fn init_databases() sqlite.DB {
	db := sqlite.connect("chat") or {
		panic(err)
	}

	sql db {
		create table Account
	}

	return db
}

fn main() {
	mut websocket_server := websocket.new_server(.ip, websocket_port, "")
	mut app := App{title: "Chat"}

	app.handle_static("public", true)

	spawn vweb.run(app, port)

	websocket_server.on_connect(client_connected)!

	websocket_server.on_message(fn (mut c websocket.Client, msg &websocket.Message) ! {
		message := msg.payload.bytestr()
		if message.trim_space().is_blank() {
			return
		}
		println(message)
	})

	websocket_server.listen() or {
		panic("Error while listening : $err")
	}
}

["/"]
pub fn (mut app App) index() vweb.Result {
	cookie := app.get_cookie("session") or {
		return app.redirect("/login")
	}
	return $vweb.html()
}

["/login"]
pub fn (mut app App) page_login() vweb.Result {
	app.get_cookie("session") or {
		return $vweb.html()
	}
	return app.redirect("/")
}

fn client_connected(mut c websocket.ServerClient) !bool {
	if c.resource_name == "/login" || c.resource_name == "/register" {
		return false
	}
	println("New websocket connection : ${c.client.conn.peer_addr()!}")
	return true
}