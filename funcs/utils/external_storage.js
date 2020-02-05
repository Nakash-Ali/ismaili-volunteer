const log = require('npmlog')
const path = require('path')
const { Storage } = require('@google-cloud/storage')
const storage = new Storage()

// NOTE: To actually use this and not mock it, run it with:
// GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/legacy_credentials/alizain@feerasta.net/adc.json

const BUCKET =
	process.env.FUNCS_GENERATED_CONTENT_BUCKET || 'local-ots-generated-content'

const MIME_TYPE = {
	png: 'image/png',
	pdf: 'application/pdf',
}

function generate_file_path(output_scope, output_format, output_hash) {
	return path.join(output_scope, `${output_hash}.${output_format}`)
}

function generate_public_url(bucket, path) {
	return `https://${bucket}.storage.googleapis.com/${path}`
}

async function exists(bucket, file_path) {
	const result = await storage
		.bucket(bucket)
		.file(file_path)
		.exists()
	return result[0]
}

async function save(bucket, file_path, content, content_type) {
	const result = await storage
		.bucket(bucket)
		.file(file_path)
		.save(content, { resumable: false, contentType: content_type })
	return true
}

async function exists_or_save(
	output_scope,
	output_format,
	output_hash,
	generate_fn,
) {
	const file_path = generate_file_path(output_scope, output_format, output_hash)
	const file_exists = await exists(BUCKET, file_path)
	if (file_exists === false) {
		log.info(
			'external_storage',
			`file path '%s' does not exist, generating now`,
			file_path,
		)
		const content = await generate_fn()
		await save(BUCKET, file_path, content, MIME_TYPE[output_format])
	}
	const public_url = generate_public_url(BUCKET, file_path)
	log.info('external_storage', `returning public url of '%s'`, public_url)
	return public_url
}

module.exports = {
	exists_or_save,
}
