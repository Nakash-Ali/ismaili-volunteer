import "@stimulus/polyfills"
import { Application } from "stimulus"

import CharCountController from "./stimulus/char_count"
import FilepickerController from "./stimulus/filepicker"
import TemporalController from "./stimulus/temporal"
import ToggleController from "./stimulus/toggle"

const application = Application.start()

application.register("char-count", CharCountController)
application.register("filepicker", FilepickerController)
application.register("temporal", TemporalController)
application.register("toggle", ToggleController)
