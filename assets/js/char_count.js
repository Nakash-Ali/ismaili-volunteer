const throttle = require('lodash.throttle')
const AUTO_SELECTOR = '[data-char-count="true"]'

window.inputCharCount = function inputCharCount(inputEl, countEl, opts) {
	const $inputEl = $(inputEl)
	const $countEl = $(countEl)

	function check() {
		const currCharCount = $inputEl.val().length

		window.requestAnimationFrame(function() {
			$countEl.text(`${opts.maxCharCount - currCharCount} ${opts.charCountText}`)
		})

		window.requestAnimationFrame(function() {
			if (currCharCount > opts.maxCharCount) {
				$inputEl.addClass(opts.inputErrorClass)

				$countEl.removeClass(opts.countUnerrorClass)
				$countEl.addClass(opts.countErrorClass)
			} else {
				$inputEl.removeClass(opts.inputErrorClass)

				$countEl.removeClass(opts.countErrorClass)
				$countEl.addClass(opts.countUnerrorClass)
			}
		})
	}

	$inputEl.on("input", throttle(check, 300))

	check()
}

$(AUTO_SELECTOR).each(function(index) {
	const $countEl = $(this)
	const opts = $countEl.data()
	inputCharCount(opts.inputEl, $countEl, opts)
})
