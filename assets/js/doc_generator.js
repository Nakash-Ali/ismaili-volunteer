/* eslint-disable */

const FORCED_DELAY = 300

window.docGenerator = function docGenerator(button, templatePath, defaultData, defaultOutputFilename) {
	const $button = $(button)
	const templateContentPromise = fetchTemplate(templatePath)
	const generateAndSave = generateWithPromise(templateContentPromise)
	
	$button.text('Setting up generator...')
	$button.attr('class', 'btn disabled btn-primary text-white')
		
	window.setTimeout(() => {
		templateContentPromise
			.then((templateContent) => {
				handleButton($button, generateAndSave.bind(null, defaultData, defaultOutputFilename))
				$button.text('Generate document')
				$button.attr('class', 'btn btn-primary text-white')
				return templateContent
			})
			.catch((error) => {
				$button.text('Failed to setup generator!')
				$button.attr('class', 'btn disabled btn-danger text-white')
				throw error
			})
	}, FORCED_DELAY * 3)

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

function handleButton($button, promiseAction) {
	$button.on('click', (ev) => {
		ev.preventDefault()
		ev.stopPropagation()
		$button.text('Generating document...!')
		$button.attr('class', 'btn disabled btn-primary text-white')
		window.setTimeout(() => {
			promiseAction()
				.then(() => {
					$button.text('Generation success! Click to generate another')
					$button.attr('class', 'btn btn-success text-white')
				})
				.catch(() => {
					$button.text('Generation failed, try again?')
					$button.attr('class', 'btn btn-primary text-white')
				})
		}, FORCED_DELAY)
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
