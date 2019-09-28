import { Controller } from "stimulus"
import dayjs from "dayjs"

const LOCAL_DATE_FORMAT = "dddd, D MMMM YYYY"
const LOCAL_TIME_FORMAT = "h:mm A"

function localDate(dt) {
	return `${dt.format(LOCAL_DATE_FORMAT)}`
}

function localDateTime(dt) {
	return `${localDate(dt)} at ${dt.format(LOCAL_TIME_FORMAT)}`
}

export default class extends Controller {
	static targets = []

	connect() {
		const dt = dayjs(this.data.get("iso"))
		const type = this.data.get("type")

		if (dt.isValid() === false) {
			throw new Error(dt)
		}

		if (type === "local") {
			this.element.textContent = localDateTime(dt)
		}
		else {
			throw new Error(type)
		}
	}
}
