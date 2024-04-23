module main

import x.vweb
import encoding.base64
import json

@['/controller/users'; get]
pub fn (app &App) controller_get_all_user(mut ctx Context) vweb.Result {
	// token := app.get_cookie('token') or { '' }
	token := ctx.get_custom_header('token') or { '' }

	if !auth_verify(token) {
		ctx.res.set_status(.bad_request)
		return ctx.text('Not valid token')
	}

	response := app.service_get_all_user() or {
		ctx.res.set_status(.bad_request)
		return ctx.text('${err}')
	}
	return ctx.json(response)
}

@['/controller/user'; get]
pub fn (app &App) controller_get_user(mut ctx Context) vweb.Result {
	// token := app.get_cookie('token') or { '' }
	token := ctx.get_custom_header('token') or { '' }

	if !auth_verify(token) {
		ctx.res.set_status(.bad_request)
		return ctx.text('Not valid token')
	}

	jwt_payload_stringify := base64.url_decode_str(token.split('.')[1])

	jwt_payload := json.decode(JwtPayload, jwt_payload_stringify) or {
		ctx.res.set_status(.bad_request)
		return ctx.text('jwt decode error')
	}

	user_id := jwt_payload.sub

	response := app.service_get_user(user_id.int()) or {
		ctx.res.set_status(.bad_request)
		return ctx.text('${err}')
	}
	return ctx.json(response)
}

@['/controller/user/create'; post]
pub fn (app &App) controller_create_user(mut ctx Context, username string, password string) vweb.Result {
	if username == '' {
		ctx.res.set_status(.bad_request)
		return ctx.text('username cannot be empty')
	}
	if password == '' {
		ctx.res.set_status(.bad_request)
		return ctx.text('password cannot be empty')
	}
	app.service_add_user(username, password) or {
		ctx.res.set_status(.bad_request)
		return ctx.text('error: ${err}')
	}
	return ctx.ok('User created successfully')
}
