// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Polyfills
//
// Important things that some browsers may not have
import "url-search-params-polyfill"

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

window.setQueryParam = function(key, value) {
	const params = new URLSearchParams(window.location.search)
	params.set(key, value)
	window.location.search = params.toString();
}
