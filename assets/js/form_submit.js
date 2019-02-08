require('parsleyjs')

const $ = window.jQuery
const $form = $('form[data-form-marker]').eq(0)
const form = $form[0]

function simpleHash(str) {
	let hash = 0
	if (str.length === 0) {
		return hash
	}
	for (let i = 0; i < str.length; i += 1) {
		const char = str.charCodeAt(i)
		hash = (hash << 5) - hash + char
		hash = hash & hash // Convert to 32bit integer
	}
	return hash
}

function makeID(len = 8) {
	const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	return new Array(len)
		.fill(0)
		.map(_ => possible.charAt(Math.floor(Math.random() * possible.length)))
		.join('')
}

function formAction() {
	return window.__FORM_SUBMIT_URL__
}

function formMethod() {
	return 'POST'
}

function formInput(key, value) {
	return $(`<input type="hidden" readonly name="${key}" value="${value}">`)[0]
}

function formCC(config) {
	return (config.cc || []).map(email => formInput('cc[]', email))
}

function additionalInputs(config) {
	const frag = document.createDocumentFragment()
	formCC(config).forEach(input => frag.appendChild(input))
	frag.appendChild(formInput('submission_id', makeID()))
	frag.appendChild(formInput('approved', config.approved))
	frag.appendChild(formInput('organizer', config.organizer))
	frag.appendChild(formInput('organizer_email', config.organizer_email))
	frag.appendChild(formInput('listing_id', config.listing_id))
	frag.appendChild(formInput('this_id', simpleHash(config.basename)))
	return frag
}

function submitBtnClassStr(...names) {
	return ['btn', 'btn-lg', ...names].join(' ')
}

function submitButton() {
	return $form.find('input#submit[type="submit"]')
}

function setErrorState() {
	// submitButton()
	// $submit[0].className = submitBtnClassStr('btn-warning', 'text-white')
}

function setLoadingState() {
	submitButton()
		.attr('disabled', 'disabled')
		.attr('value', 'Applying... this may take a few moments (don\'t refresh!)')
}

const parsedConfig = JSON.parse(atob(window.__FORM_DATA__))

if (Object.keys(parsedConfig) === 0) {
	throw new Error('incomplete config')
}

if (!form) {
	throw new Error('cannot find form')
}

const instance = $form.parsley({
	errorClass: 'is-invalid',
	successClass: 'is-valid',
	errorsContainer: function errorsContainer(el) {
		return el.$element.closest('.form-group')
	},
	errorsWrapper: '<div class="feedback-container col-sm-8 offset-4"></div>',
	errorTemplate: '<div class="invalid-feedback mt-2q" style="display: inherit;"></div>'
})

instance.on('form:error', function formOnError() {
	this.element.className += ' was-validated'
	setErrorState()
})

form.onsubmit = function onsubmit(ev) {
	if (!instance.isValid()) {
		ev.preventDefault()
		return false
	}
	form.appendChild(additionalInputs(parsedConfig))
	form.action = formAction()
	form.method = formMethod()
	setLoadingState()
	return true
}
