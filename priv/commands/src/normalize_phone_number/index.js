#!/bin/sh
':' //; exec "$(command -v nodejs || command -v node)" "$0" "$@"

"use strict";

process.stdin.on('end', () => { process.exit(1) })
process.on('unhandledRejection', up => { throw up })

const { argv } = require("yargs")
const { setupConfig, logEncodedObj } = require("../utils")
const schema = require("./schema.js")
const PNF = require('google-libphonenumber').PhoneNumberFormat
const phoneUtil = require('google-libphonenumber').PhoneNumberUtil.getInstance()

const config = setupConfig(schema, argv.config)

function normalizeNumbers(rawConfigs) {
	return rawConfigs.map((config) => {
		let number = null

		try {
			number = phoneUtil.parse(config.number, config.region)
		} catch(e) {
			return {
				valid: false,
				error: {
					code: e.code,
					message: e.message
				}
			}
		}

		const region = phoneUtil.getRegionCodeForNumber(number)

		if (phoneUtil.isValidNumberForRegion(number, region) === true) {
			return {
				valid: true,
				number: phoneUtil.format(number, PNF[config.format]),
				region,
			}
		}
		else {
			return {
				valid: false,
				error: {
					code: undefined,
					message: "Invalid phone number for region"
				}
			}
		}
	})
}

logEncodedObj(
	normalizeNumbers(config)
)
