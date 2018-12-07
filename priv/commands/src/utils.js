const Ajv = require("ajv")
const ajv = new Ajv()

function setupConfig(schema, raw) {
	var parsedConfig = {}

	try {
		parsedConfig = JSON.parse(Buffer.from(raw, 'base64').toString('utf8'))
	} catch (e) {
		throw new Error(`un-parseable config! ${raw}`)
	}

	if (!ajv.validate(schema, parsedConfig)) {
		throw new Error(`config does not conform to schema! ${parsedConfig}`)
	}

	return parsedConfig
}

function setupSuicideTimeout(timeout) {
	timeout = parseInt(timeout, 10)
	if (isNaN(timeout) || timeout <= 0 || timeout > 120 * 1000) {
		console.error('timeout must be a non-negative integer less than 2 minutes (in milliseconds)')
		process.exit(1)
	}

	const pid = setTimeout(function() {
		process.exit(1)
	}, timeout)

	return function() {
		clearTimeout(pid)
	}
}

function logEncodedObj(obj) {
	const buff = Buffer.from(JSON.stringify(obj), 'utf8').toString('base64')
	console.log(buff)
}

async function launchBrowser(puppeteer) {
	return puppeteer.launch({args: ['--no-sandbox', '--disable-setuid-sandbox']})
}

async function launchPage(browser, webpageUrl) {
	const page = await browser.newPage()
	const response = await page.goto(webpageUrl, {
		timeout: 6000,
		waitUntil: 'networkidle0'
	})
	if (Math.floor(response.status() / 100) !== 2) {
		throw new Error('failed to load page!')
	}
	return page
}

module.exports = {
	setupConfig,
	setupSuicideTimeout,
	logEncodedObj,
	launchBrowser,
	launchPage
}
