const log = require('npmlog')
const Ajv = require('ajv')
const PNF = require('google-libphonenumber').PhoneNumberFormat
const phone_util = require('google-libphonenumber').PhoneNumberUtil.getInstance()

const SCHEMA = {
	$schema: 'http://json-schema.org/draft-07/schema#',
	title: 'Config',
	type: 'object',
	properties: {
		number: {
			type: 'string',
		},
		format: {
			type: 'string',
			enum: ['E164', 'INTERNATIONAL'],
		},
		region: {
			type: 'string',
		},
	},
	required: ['number', 'format'],
}

module.exports = function(req, res) {
	const ajv = new Ajv()
	const valid = ajv.validate(SCHEMA, req.body)
	if (valid === true) {
		log.info(
			'normalize_phone_number',
			`processing request with params '%j'`,
			req.body,
		)

		let number = null

		try {
			number = phone_util.parse(req.body.number, req.body.region)
		} catch (e) {
			log.info(
				'normalize_phone_number',
				`invalid phone number of '%s'`,
				req.body.number,
			)
			return res.status(400).json({
				error: 'invalid phone number',
				code: e.code,
				message: e.message,
			})
		}

		const region = phone_util.getRegionCodeForNumber(number)

		if (phone_util.isValidNumberForRegion(number, region) === true) {
			return res.status(200).json({
				number: phone_util.format(number, PNF[req.body.format]),
				region: region,
			})
		} else {
			log.info(
				'normalize_phone_number',
				`invalid phone number of '%s' for region '%s'`,
				req.body.number,
				region,
			)
			return res.status(400).json({
				error: 'invalid phone number for region',
			})
		}
	} else {
		log.info(
			'normalize_phone_number',
			`invalid request with params '%j'`,
			req.body,
		)
		return res.status(400).json({
			error: 'invalid config',
			config_errors: ajv.errors,
		})
	}
}
