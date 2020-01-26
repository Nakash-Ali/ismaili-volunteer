const Ajv = require('ajv')
const PNF = require('google-libphonenumber').PhoneNumberFormat
const phoneUtil = require('google-libphonenumber').PhoneNumberUtil.getInstance()

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
		let number = null

		try {
			number = phoneUtil.parse(req.body.number, req.body.region)
		} catch (e) {
			return res.status(400).json({
				error: 'invalid phone number',
				code: e.code,
				message: e.message,
			})
		}

		const region = phoneUtil.getRegionCodeForNumber(number)

		if (phoneUtil.isValidNumberForRegion(number, region) === true) {
			return res.status(200).json({
				number: phoneUtil.format(number, PNF[req.body.format]),
				region: region,
			})
		} else {
			return res.status(400).json({
				error: 'invalid phone number for region',
			})
		}
	} else {
		return res.status(400).json({
			error: 'invalid config',
			config_errors: ajv.errors,
		})
	}
}
