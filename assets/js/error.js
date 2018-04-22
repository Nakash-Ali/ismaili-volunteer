const $ = window.$
const $err = $('#error-container')
const errorEmail = 'hrontario@iicanada.net'

class FormError extends Error {}

function parseQueryString() {
	return location.search.substring(1).split('&').reduce((accum, curr) => {
		const p = curr.split('=')
		const key = decodeURIComponent(p[0])
		if (key && key.length > 0) {
			accum[key] = decodeURIComponent(p[1])
		}
		return accum
	}, {})
}

function parseEncodedErrorValue(string) {
	return JSON.parse(atob(string))
}

function parseErrors() {
	const parsed = {}
	const qsObj = parseQueryString()
	Object.keys(qsObj).forEach((key) => {
		if (qsObj[key] !== undefined && qsObj[key] !== 'undefined') {
			parsed[key] = parseEncodedErrorValue(qsObj[key])
		}
	})
	return parsed
}

function baseErrorCard(content, type = 'danger') {
	return $(`<div class="card border-${type} text-${type} mb-5 font-family-sans-serif">${content}</div>`)
}

function changesetErrorCard(key, errorsList) {
	const errorType = 'warning'
	const errorsListHTML = errorsList.map(err => `<li class="">${err}</li>`)
	return baseErrorCard(`
		<div class="card-header bg-${errorType} text-white">
			Form Error
		</div>
		<div class="card-body">
			<h4 class="card-title">"${key}" has the following errors</h4>
			<ul class="m-0">
				${errorsListHTML.join('\n')}
			</ul>
		</div>
		`, errorType)
}

function handlePublicChangesetErrors(obj) {
	const errorsHTML = Object.keys(obj).map(key => changesetErrorCard(key, obj[key]))
	$err.append(errorsHTML)
}

function handleSystemChangesetErrors(obj) {
	const errorType = 'danger'
	const errorSubject = encodeURIComponent('System Error on form!')
	const errorBody = btoa(JSON.stringify(obj))
	$err.append(baseErrorCard(`
		<div class="card-header bg-${errorType} text-white">
			System Error
		</div>
		<div class="card-body">
			<h4 class="card-title">It seems like the form was misconfigured! Please contact an <a href="mailto:${errorEmail}?subject=${errorSubject}&body=${errorBody}">administrator</a>.</h4>
			<p class="mb-1">Be sure to include the following error code in your email!</p>
			<code class="mb-0 text-${errorType}"><strong>${errorBody}</strong></code>
		</div>
		`, errorType))
}

function handleErrors(obj) {
	const errorType = 'danger'
	const errorSubject = encodeURIComponent('Error on submit!')
	const errorBody = btoa(JSON.stringify(obj))
	$err.append(baseErrorCard(`
		<div class="card-header bg-${errorType} text-white">
			${obj.component} Error
		</div>
		<div class="card-body">
			<h4 class="card-title">${obj.message}. Go <a href="javascript:window.history.back()">back</a>?</h4>
			<p class="mb-1">Or, contact an <a href="mailto:${errorEmail}?subject=${errorSubject}&body=${errorBody}">administrator</a>. Be sure to include the following error code in your email!</p>
			<code class="mb-0 text-${errorType}"><strong>${errorBody}</strong></code>
		</div>
		`, errorType))
}

function trackErrorWithSentry(errorType, errorObj) {
	if (window.Raven !== undefined && typeof window.Raven.context === 'function') {
		try {
			window.Raven.context({
				extra: errorObj
			}, () => {
				throw new FormError(errorType)
			})
		} catch (e) {
			console.warn('Tried to log submission error with Raven, should have succeeded. Check Sentry for more details...')
		}
	}
}

const handlers = {
	errors: handleErrors,
	system_errors: handleSystemChangesetErrors,
	public_errors: handlePublicChangesetErrors,
}

function run() {
	const errors = parseErrors()
	Object.keys(handlers).forEach(key => {
		if (errors[key] !== undefined) {
			trackErrorWithSentry(key, errors[key])
			handlers[key](errors[key])
		}
	})
}

run()
