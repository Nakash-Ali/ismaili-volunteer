import { Controller } from "stimulus"

const OPPOSITE = {
	"disable": "enable",
	"enable": "disable"
}

export default class extends Controller {
	static targets = [
		"checkbox",
		"toDisable",
		"toClear",
	]

	connect() {
		this.toggle(null)
	}

	toggle(_event) {
		if ($(this.checkboxTarget).prop("checked") === true) {
			this[this.data.get("whenTrue")]();
		} else {
			this[OPPOSITE[this.data.get("whenTrue")]]();
		}
	}

	enable() {
		$(this.toDisableTargets).prop("disabled", false).removeClass("disabled")
	}

	disable() {
		if (this.data.get("clearOnDisable") === "true") {
			$(this.toClearTargets).val("")
		}
		$(this.toDisableTargets).prop("disabled", true).addClass("disabled")
	}
}
