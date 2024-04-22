module main

import x.vweb

@['/test']
pub fn (app &App) testboom () vweb.Result {
	title := 'BOOM SHAKE'
	return $vweb.html()
}
