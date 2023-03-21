module main

import net.websocket
import vweb
import db.sqlite

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
	port           = 8000
	token_len      = 256
)

pub fn (mut app App) before_request() {
	println('New vweb connection : ${app.ip()}')
}

fn main() {
	mut websocket_server := websocket.new_server(.ip, websocket_port, '')
	mut app := App{
		title: 'Chat'
	}

	app.init_databases()

	spawn vweb.run(app, port)

	websocket_server.on_connect(client_connected) or { panic(err) }

	websocket_server.on_message(message_received)

	websocket_server.listen() or { panic('Error while listening : ${err}') }
}

fn client_connected(mut c websocket.ServerClient) !bool {
	if c.resource_name == '/' {
		println('New websocket connection : ${c.client.conn.peer_addr()!}')
		return true
	}
	return false
}

fn message_received(mut _ websocket.Client, msg &websocket.Message) ! {
	// TODO handle message
}
