module main

import x.vweb
import net.http

@['/controller/auth'; post]
pub fn (app &App) controller_auth(mut ctx Context, username string, password string) vweb.Result {
	response := app.service_auth(username, password) or {
		ctx.res.set_status(http.Status.bad_request)
		return ctx.text('error: ${err}')
	}

	return ctx.json(response)
}
