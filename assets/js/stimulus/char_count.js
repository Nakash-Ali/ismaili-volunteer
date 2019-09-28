import { Controller } from "stimulus"
import throttle from "lodash.throttle"

export default class extends Controller {
	connect() {
		this.$this = $(this.element)
		this.$input = $(`#${this.data.get("inputId")}`)

		this.inputIsInvalidAlready = this.$input.hasClass(this.data.get("inputInvalidClass"))
		this.prevCharCount = this.$input.val().length

		this.check()
		this.checkThrottled = throttle(this.check.bind(this), 300)

		this.$input.on("input", this.checkThrottled)
	}

	disconnect() {
		this.$input.off("input", this.checkThrottled)
	}

	check() {
		const currCharCount = this.$input.val().length
		const delta = this.data.get("max") - currCharCount
		const word = Math.abs(delta) === 1 ? "character" : "characters"

		if (delta > 0) {
			window.requestAnimationFrame(() => this.$this.text(`${delta} ${word} remaining`))
		} else if (delta === 0) {
			window.requestAnimationFrame(() => this.$this.text(`no ${word} remaining`))
		} else if (delta < 0) {
			window.requestAnimationFrame(() => this.$this.text(`${Math.abs(delta)} ${word} extra`))
		} else {
			throw new Error("oh dear!");
		}

		if (this.prevCharCount === currCharCount) {
			return
		} else if (currCharCount > this.data.get("max")) {
			if (this.inputIsInvalidAlready === false) {
				window.requestAnimationFrame(() => {
					this.$this.addClass(this.data.get("thisInvalidClass")).removeClass(this.data.get("thisValidClass"))
					this.$input.addClass(this.data.get("inputInvalidClass"))
				})
			}
		} else if (currCharCount <= this.data.get("max")) {
			if (this.prevCharCount <= this.data.get("max")) {
				return
			} else if (this.prevCharCount > this.data.get("max") && this.inputIsInvalidAlready === false) {
				window.requestAnimationFrame(() => {
					this.$this.addClass(this.data.get("thisValidClass")).removeClass(this.data.get("thisInvalidClass"))
					this.$input.removeClass(this.data.get("inputInvalidClass"))
				})
			}
		} else {
			throw new Error("oh dear!")
		}

		this.prevCharCount = currCharCount
	}
}
