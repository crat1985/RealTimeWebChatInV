module main

import net.websocket
import vweb
import db.sqlite
import log
import time
import os

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
	logger log.Log
}

const (
	websocket_port = 8080
	port           = 8000
	token_len      = 256
)

pub fn (mut app App) before_request() {
	app.info('New vweb connection from ${app.ip()} : ${app.req.method} ${app.req.url}')
}

fn (mut app App) setup_logger() {
	if !os.exists("logs") {
		os.mkdir("logs") or {
			app.info("Cannot create log directory `logs`")
		}
	}

	app.logger.set_level(.debug)

	app.logger.set_full_logpath("./logs/log_${time.now().ymmdd()}")
	app.logger.log_to_console_too()
}

fn (mut app App) info(msg string) {
	app.logger.info(msg)

	app.logger.flush()
}

fn (mut app App) warn(msg string) {
	app.logger.warn(msg)

	app.logger.flush()
}

fn (mut app App) fatal(msg string) {
	app.logger.fatal(msg)
}

fn main() {
	mut websocket_server := websocket.new_server(.ip, websocket_port, '')
	mut app := App{
		title: 'Chat'
	}

	app.setup_logger()

	defer {
		app.logger.close()
	}

	app.init_databases()

	spawn vweb.run(app, port)

	websocket_server.on_connect(app.client_connected) or {
		app.fatal(err.msg())
	}

	websocket_server.on_message(message_received)

	websocket_server.listen() or { app.fatal('Error while listening : ${err}') }
}

fn (mut app App) client_connected(mut c websocket.ServerClient) !bool {
	if c.resource_name == '/' {
		app.info('New websocket connection : ${c.client.conn.peer_addr()!}')
		return true
	}
	return false
}

fn message_received(mut _ websocket.Client, msg &websocket.Message) ! {
	// TODO handle message
}
