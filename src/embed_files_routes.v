module main

import vweb

const (
	favicon    = $embed_file('src/public/favicon.ico', .zlib)
	client_js  = $embed_file('src/public/client.js', .zlib)
	index_js   = $embed_file('src/public/index.js', .zlib)
	client_css = $embed_file('src/public/client.css', .zlib)
	style_css  = $embed_file('src/public/style.css', .zlib)
)

['/favicon.ico']
pub fn (mut app App) favicon() vweb.Result {
	return app.ok(favicon.to_string())
}

['/client.js']
pub fn (mut app App) client_js() vweb.Result {
	app.add_header('Content-Type', 'text/js')
	return app.ok(client_js.to_string())
}

['/index.js']
pub fn (mut app App) index_js() vweb.Result {
	app.add_header('Content-Type', 'text/js')
	return app.ok(index_js.to_string())
}

['/client.css']
pub fn (mut app App) client_css() vweb.Result {
	app.add_header('Content-Type', 'text/css')
	return app.ok(client_css.to_string())
}

['/style.css']
pub fn (mut app App) style_css() vweb.Result {
	app.add_header('Content-Type', 'text/css')
	return app.ok(style_css.to_string())
}
