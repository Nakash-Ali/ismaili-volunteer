const { argv } = require("yargs")
const Ajv = require("ajv")

const ajv = new Ajv()

function setupConfig(schema) {
	var parsedConfig = {}

	try {
		parsedConfig = JSON.parse(Buffer.from(argv.config, 'base64').toString('utf8'))
	} catch (e) {
		throw new Error(`un-parseable config! ${argv.config}`)
	}

	if (!ajv.validate(schema, parsedConfig)) {
		throw new Error(`config does not conform to schema! ${parsedConfig}`)
	}

	return parsedConfig
}

function setupTimeout(timeout) {
	timeout = parseInt(timeout, 10)
	if (isNaN(timeout) || timeout <= 0 || timeout > 120 * 1000) {
		console.error('timeout must be a non-negative integer less than 2 minutes (in milliseconds)')
		process.exit(1)
	}
	const pid = setTimeout(() => { process.exit(1) }, timeout)
	return () => clearTimeout(pid)
}

function logEncodedObj(obj) {
	const buff = Buffer.from(JSON.stringify(obj), 'utf8').toString('base64')
	console.log(buff)
}

module.exports = {
	setupConfig,
	setupTimeout,
	logEncodedObj
}
