const jump = require('jump.js')

function onclick(el) {
	let offset = parseInt(el.getAttribute('data-smooth-offset'), 10)
	if (isNaN(offset)) {
		offset = 0
	}
	const target = document.querySelector(el.hash)
	return function handler(ev) {
		ev.preventDefault()
		jump(target, {
			duration: 600,
			offset,
		})
	}
}

window
	.jQuery('a[data-smooth]')
	.toArray()
	.forEach(el => {
		el.onclick = onclick(el)
	})
