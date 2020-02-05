const puppeteer = require('puppeteer')
const auth = require('basic-auth')

const ACTIONS = {
	normalize_phone_number: require('./actions/normalize_phone_number'),
	sanitize_html: require('./actions/sanitize_html'),
	save_webpage: require('./actions/save_webpage'),
}

exports.process = (req, res) => {
	// Enable CORS requests
	res.set('Access-Control-Allow-Origin', '*')
	if (req.method === 'OPTIONS') {
		res.set('Access-Control-Allow-Methods', '*')
		res.set('Access-Control-Allow-Headers', '*')
		res.set('Access-Control-Max-Age', '3600')
		return res.sendStatus(204)
	}

	// Validate credentials
	let expected_name = 'ots'
	let expected_pass = 'ots'
	if (
		typeof process.env.K_SERVICE === 'string' &&
		process.env.K_SERVICE.length > 0
	) {
		expected_name = process.env.FUNCS_BASIC_AUTH_NAME
		expected_pass = process.env.FUNCS_BASIC_AUTH_PASS
	}
	const credentials = auth(req)
	if (
		!credentials ||
		credentials.name !== expected_name ||
		credentials.pass !== expected_pass
	) {
		return res.status(401).json({
			error: 'invalid auth',
		})
	}

	if (
		req.body &&
		typeof req.body.action === 'string' &&
		Object.keys(ACTIONS).includes(req.body.action)
	) {
		return ACTIONS[req.body.action](req, res)
	} else {
		return res.status(400).json({
			error: 'invalid action',
		})
	}
}
