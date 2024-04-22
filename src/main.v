module main

import x.vweb
import databases
import os

const (
	port = 8082
)

pub struct Context {
    vweb.Context

}

pub struct App {
	vweb.StaticHandler
}


pub fn (app &App) before_request(mut ctx Context) {
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

pub fn (app &App) index() vweb.Result {
	title := 'VWEB App'

	return $vweb.html()
}
