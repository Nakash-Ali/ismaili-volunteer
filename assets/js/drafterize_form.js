window.drafterizeForm = function(draftContentKey) {
	const draftContent = JSON.parse(atob(window[draftContentKey]))
	addAllDraftContent(draftContent)
}

function addAllDraftContent(draftContent) {
	Object.keys(draftContent).forEach(fieldId => {
		const draftValue = draftContent[fieldId]
		addDraftValue(fieldId, draftValue, document)
	})
}

function addDraftValue(fieldId, draftValue, documentEl) {
	const selectorToFuncs = {
		[`trix-editor[input="${fieldId}"]`]: addDraftValueToTrixEditor,
		[`#${fieldId}`]: addDraftValueToInputValue,
	}

	Object.keys(selectorToFuncs).reduce((alreadyFound, currSelector) => {
		if (alreadyFound) {
			return alreadyFound
		}
		const $el = $(currSelector)
		if ($el.length > 0) {
			const func = selectorToFuncs[currSelector]
			$el.toArray().map(element => func(element, draftValue))
			return true
		}
		return false
	}, false)
}

// function addDraftValueToElementById(element, draftValue) {
// 	if (element.nodeName === "SELECT") {
// 		addDraftValueToInputValue(element, draftValue)
// 	}
// 	else if (element.nodeName === "INPUT") {
// 		const inputType = element.getAttribute("type")
// 		if (inputType === "text") {
// 			addDraftValueToInputValue(element, draftValue)
// 		}
// 		else if (inputType === "number") {
// 			addDraftValueToInputValue(element, draftValue)
// 		}
// 		else if (inputType === "date") {
// 			addDraftValueToInputValue(element, draftValue)
// 		}
// 	}
// }

function addDraftValueToTrixEditor(element, draftValue) {
	if (
		element.editor
			.getDocument()
			.toString()
			.replace(/\s/g, '') === ''
	) {
		element.editor.setSelectedRange([0, 0])
		element.editor.insertString(draftValue)
	}
}

function addDraftValueToInputValue(input, draftValue) {
	if (input.value === '' && !input.disabled) {
		input.value = draftValue
	}
}
