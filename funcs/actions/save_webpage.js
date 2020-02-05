const log = require('npmlog')
const Ajv = require('ajv')
const puppeteer = require('puppeteer')
const external_storage = require('../utils/external_storage')

const SCHEMA = {
	$schema: 'http://json-schema.org/draft-07/schema#',
	title: 'Config',
	type: 'object',
	properties: {
		webpage_url: {
			description: 'Full url for the webpage to load',
			type: 'string',
			format: 'uri',
		},
		output_scope: {
			description: 'Scope for objects',
			type: 'string',
		},
		output_format: {
			description: 'Output format',
			type: 'string',
			enum: ['png', 'pdf'],
		},
		output_hash: {
			description: 'Hashed filename of the object',
			type: 'string',
		},
	},
	required: ['webpage_url', 'output_scope', 'output_format', 'output_hash'],
}

const PAGE_TO_FORMAT = {
	png: async function(page) {
		return page.screenshot({
			fullPage: true,
			omitBackground: true,
		})
	},
	pdf: async function(page) {
		return page.pdf({
			pageRanges: '',
			displayHeaderFooter: false,
			printBackground: true,
			format: 'letter',
			margin: {
				top: '3cm',
				right: '1cm',
				bottom: '3cm',
				left: '1cm',
			},
		})
	},
}

async function generate_content(webpage_url, output_format) {
	const browser = await puppeteer.launch({
		args: ['--no-sandbox', '--disable-setuid-sandbox'],
	})
	const page = await browser.newPage()
	const page_response = await page.goto(webpage_url, {
		timeout: 20000,
		waitUntil: 'networkidle0',
	})
	if (Math.floor(page_response.status() / 100) !== 2) {
		return res.status(400).json({
			error: 'failed to load page',
		})
	}
	return PAGE_TO_FORMAT[output_format](page)
}

module.exports = function(req, res) {
	const ajv = new Ajv()
	const valid = ajv.validate(SCHEMA, req.body)
	if (valid === true) {
		log.info('save_webpage', `processing request with params '%j'`, req.body)
		;(async () => {
			const url = await external_storage.exists_or_save(
				req.body.output_scope,
				req.body.output_format,
				req.body.output_hash,
				() => generate_content(req.body.webpage_url, req.body.output_format),
			)
			return res.status(200).json({
				url: url,
			})
		})()
	} else {
		log.info('save_webpage', `invalid request with params '%j'`, req.body)
		return res.status(400).json({
			error: 'invalid config',
			config_errors: ajv.errors,
		})
	}
}
