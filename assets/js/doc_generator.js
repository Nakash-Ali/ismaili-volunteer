/* eslint-disable */

window.docGenerator = function docGenerator(button, templatePath, defaultDataEncoded, defaultOutputFilename, appearance) {
	const $button = $(button)
	const defaultData = JSON.parse(atob(defaultDataEncoded))
	const templateContentPromise = fetchTemplate(templatePath)
	const generateAndSave = generateWithPromise(templateContentPromise)
	
	$button.text(appearance.setup.text)
	$button.attr('class', appearance.setup.class)
		
	templateContentPromise
		.then((templateContent) => {
			handleButton($button, generateAndSave.bind(null, defaultData, defaultOutputFilename), appearance)
			$button.text(appearance.ready.text)
			$button.attr('class', appearance.ready.class)
			return templateContent
		})
		.catch((error) => {
			$button.text(appearance.setup_fail.text)
			$button.attr('class', appearance.setup_fail.class)
			throw error
		})

	return generateAndSave
}

function fetchTemplate(template) {
	return new Promise((resolve, reject) => {
		JSZipUtils.getBinaryContent(template, (error, templateContent) => {
			if (error) {
				reject(error)
			}
			resolve(templateContent)
		})
	})
}

function handleButton($button, promiseAction, appearance) {
	$button.on('click', (ev) => {
		ev.preventDefault()
		ev.stopPropagation()
		$button.text(appearance.generating.text)
		$button.attr('class', appearance.generating.class)
		promiseAction()
			.then(() => {
				$button.text(appearance.done.text)
				$button.attr('class', appearance.done.class)
			})
			.catch(() => {
				$button.text(appearance.generating_fail.text)
				$button.attr('class', appearance.generating_fail.class)
			})
	})
}

function generateWithPromise(templateContentPromise) {
	return function generateAndSave(data, filename) {
		return templateContentPromise.then((templateContent) => {
			const zip = new JSZip(templateContent)
			const doc = new docxtemplater().loadZip(zip)
			doc.setData(data)

			try {
				doc.render()
				const out = doc
					.getZip()
					.generate({
						type: 'blob',
						mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
					})
				saveAs(out, `${filename}.docx`)
			} catch (error) {
				const strError = JSON.stringify({
					message: error.message,
					name: error.name,
					stack: error.stack,
					properties: error.properties,
				})
				console.error(strError)
				throw error
			}
		})
	}
}
