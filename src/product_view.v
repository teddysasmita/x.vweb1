module main

import x.vweb

@['/products'; get]
pub fn (app App) products(mut ctx Context) vweb.Result {
	token := ctx.get_cookie('token') or {
		ctx.res.set_status(.bad_request)
		return ctx.text('${err}')
	}

	products := get_products(token) or {
		ctx.res.set_status(.bad_request)
		return ctx.text('Failed to fetch data from the server. Error: ${err}')
	}

	user := get_user(token) or {
		ctx.res.set_status(.bad_request)
		return ctx.text('Failed to fetch data from the server. Error: ${err}')
	}

	return $vweb.html()
}
