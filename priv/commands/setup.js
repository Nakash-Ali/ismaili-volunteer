const argv = require('yargs').argv
const ajv = new require('ajv')()

module.exports = function setup(schema_path, timeout = 30000) {
	timeout = parseInt(timeout)
	if (isNaN(timeout) || timeout <= 0 || timeout > 120 * 1000) {
		console.error('timeout must be a non-negative integer less than 2 minutes (in milliseconds)')
		process.exit(1)
	}
	
	setTimeout(() => { process.exit(1) }, timeout)
	process.stdin.on('end', () => { process.exit(1) })
	process.on('unhandledRejection', up => { throw up })
	
	const schema = require(schema_path)
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
