/* global Modernizr, ga */

const oldBrowsers = '#old-browsers'
const functions = Object.keys(Modernizr)

function show(target) {
	if (typeof target === 'string') {
		target = document.querySelector(target)
	}
	if (target.style.display !== 'block') {
		target.style.display = 'block'
		ga('send', 'event', 'Old Browsers', 'trigger')
	}
}

functions.forEach(name => {
	Modernizr.on(name, result => (result === false ? show(oldBrowsers) : null))
})
