const Ajv = require('ajv')
const puppeteer = require('puppeteer')

const SCHEMA = {
	$schema: 'http://json-schema.org/draft-07/schema#',
	title: 'Config',
	type: 'object',
	properties: {
		webpageUrl: {
			description: 'Full url for the webpage to load',
			type: 'string',
			format: 'uri',
		},
	},
	required: ['webpageUrl'],
}

module.exports = function(req, res) {
	const ajv = new Ajv()
	const valid = ajv.validate(SCHEMA, req.body)
	if (valid === true) {
		;(async () => {
			const browser = await puppeteer.launch({
				args: ['--no-sandbox', '--disable-setuid-sandbox'],
			})
			const page = await browser.newPage()
			const pageResponse = await page.goto(req.body.webpageUrl, {
				timeout: 20000,
				waitUntil: 'networkidle0',
			})
			if (Math.floor(pageResponse.status() / 100) !== 2) {
				return res.status(400).json({
					error: 'failed to load page',
				})
			}
			const pngFile = await page.screenshot({
				fullPage: true,
				omitBackground: true,
			})
			res.type('png')
			res.send(pngFile)
			return res
		})()
	} else {
		return res.status(400).json({
			error: 'invalid config',
			config_errors: ajv.errors,
		})
	}
}
