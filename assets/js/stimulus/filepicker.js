/* global FilestackClient */

import { Controller } from "stimulus"

const OPPOSITE = {
	"default": "pick",
	"pick": "default"
}

export default class extends Controller {
	static targets = [
		"input",
		"img",
		"defaultBtn",
		"pickBtn",
	]

	connect() {
		this.$input = $(this.inputTargets)
		this.$img = $(this.imgTargets)
		this.$defaultBtn = $(this.defaultBtnTarget)
		this.$pickBtn = $(this.pickBtnTarget)

		this.picker = FilestackClient.picker({
			uploadInBackground: false,
			fromSources: ["local_file_system", "url", "imagesearch", "facebook", "instagram", "googledrive"],
			accept: ["image/*"],
			maxFiles: 1,
			onUploadDone: (result) => {
				if (result.filesUploaded.length === 1) {
					this.useImage("pick", result.filesUploaded[0].url);
				} else if (result.filesUploaded.length === 0) {
					console.log("error uploading file!");
				} else if (result.filesUploaded.length > 1) {
					console.log("more than 1 file uploaded!");
				} else {
					throw new Error("filepicker fatal error");
				}
			},
		});

		this.$defaultBtn.on("click", (e) => {
			e.preventDefault();
			this.useImage("default", this.data.get("defaultImg"));
		})

		this.$pickBtn.on("click", (e) => {
			e.preventDefault();
			this.picker.open();
		})
	}

	useImage(source, url) {
		this.$input.val(url);
		this.$img.attr("src", url);
		this[`$${source}Btn`].addClass("active");
		this[`$${OPPOSITE[source]}Btn`].removeClass("active");
	}
}
