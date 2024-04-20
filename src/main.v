module main

import x.vweb
import databases
import os

const (
	port = 8082
)

pub struct Context {
    vweb.Context
pub mut:
    // In the context struct we store data that could be different
    // for each request. Like a User struct or a session id
    user       User
    session_id string
}

pub struct App {
	vweb.StaticHandler
pub:
    // In the app struct we store data that should be accessible by all endpoints.
    // For example, a database or configuration values.
    secret_key string
}


pub fn (app App) before_request(mut ctx Context) {
	println('[web] before_request: ${ctx.req.method} ${ctx.req.url}')
}

fn main() {
	mut db := databases.create_db_connection() or { panic(err) }

	sql db {
		create table User
		create table Product
	} or { panic('error on create table: ${err}') }

	db.close() or { panic(err) }

	mut app := &App{}
	app.serve_static('/favicon.ico', 'src/assets/favicon.ico')!
	// makes all static files available.
	app.mount_static_folder_at(os.resource_abs_path('.'), '/')!

	vweb.run[App, Context](mut app, port)
}

pub fn (mut app App) index() vweb.Result {
	title := 'VWEB App'

	return $vweb.html()
}
