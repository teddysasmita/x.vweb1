module main

import x.vweb

@['/test']
pub fn (mut app App) testboom () vweb.Result {
	title := 'BOOM SHAKE'
	return $vweb.html()
}
