module main

import x.vweb
import encoding.base64
import json

@['/controller/products'; get]
pub fn (mut app App) controller_get_all_products(mut ctx Context) vweb.Result {
	token := ctx.req.header.get_custom('token') or { '' }

	if !auth_verify(token) {
		ctx.res.set_status(.bad_request)
		return ctx.text('Not valid token')
	}

	// jwt_payload_stringify := base64.url_decode_str(token.split('.')[1])

	// jwt_payload := json.decode(JwtPayload, jwt_payload_stringify) or {
	// 	app.set_status(501, '')
	// 	return app.text('jwt decode error')
	// }

	// user_id := jwt_payload.sub

	response := app.service_get_all_products() or {
		ctx.res.set_status(.bad_request)
		return ctx.text('${err}')
	}
	return ctx.json(response)
	// return app.text('response')
}

@['/controller/product/create'; post]
pub fn (mut app App) controller_create_product(mut ctx Context, product_name string) vweb.Result {
	if product_name == '' {
		ctx.res.set_status(.bad_request)
		return ctx.text('product name cannot be empty')
	}

	token := ctx.req.header.get_custom('token') or { '' }

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

	app.service_add_product(product_name, user_id.int()) or {
		ctx.res.set_status(.bad_request)
		return ctx.text('error: ${err}')
	}
	return ctx.ok('product created successfully')
}
