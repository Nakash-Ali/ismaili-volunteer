// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import "popper.js"
import "bootstrap/js/dist/button"
import "bootstrap/js/dist/dropdown"
import "iframe-resizer/js/iframeResizer.contentWindow.js"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import queryString from "query-string"

window.putQueryInLocation = function(key, value) {
	const parsed = queryString.parse(window.location.search)
	parsed[key] = value
	const stringified = queryString.stringify(parsed);
	window.location.search = stringified;
}

window.putHashInLocation = function(value) {
	window.location.hash = value
}
