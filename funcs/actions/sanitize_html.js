const log = require('npmlog')
const Ajv = require('ajv')
const sanitize = require('sanitize-html')

const SCHEMA = {
	$schema: 'http://json-schema.org/draft-07/schema#',
	title: 'Config',
	type: 'object',
	properties: {
		html: {
			type: 'string',
		},
	},
	required: ['html'],
}

const SANITIZE_CONFIG = {
	parser: {
		decodeEntities: true,
		lowerCaseTags: true,
		lowerCaseAttributeNames: true,
		recognizeCDATA: true, // TODO: test this out!
		recognizeSelfClosing: true,
	},
	allowedTags: [
		'a',
		'abbr',
		'b',
		'blockquote',
		'br',
		'caption',
		'cite',
		'code',
		'dd',
		'dfn',
		'div',
		'dl',
		'dt',
		'em',
		'hr',
		'i',
		'kbd',
		'li',
		'li',
		'mark',
		'nl',
		'ol',
		'p',
		'pre',
		'q',
		's',
		'small',
		'strike',
		'strong',
		'sub',
		'sup',
		'time',
		'ul',
		'var',
	],
	disallowedTagsMode: 'discard',
	allowedAttributes: {
		'*': ['lang', 'title'],
		a: ['href', 'name', 'rel'],
		abbr: ['title'],
		blockquote: ['title'],
		dfn: ['title'],
		q: ['cite'],
		time: ['datetime', 'pubdate'],
		img: ['src'],
	},
	selfClosing: [
		'img',
		'br',
		'hr',
		'area',
		'base',
		'basefont',
		'input',
		'link',
		'meta',
	],
	allowedSchemes: ['http', 'https', 'mailto'],
	allowedSchemesByTag: {},
	allowedSchemesAppliedToAttributes: ['href', 'src', 'cite'],
	allowProtocolRelative: false,
	transformTags: {
		a: function(tagName, attribs) {
			attribs['rel'] = 'noopener noreferrer nofollow'
			return {
				tagName,
				attribs,
			}
		},
	},
}

// TODO: collapse extra whitespace
// Regex.replace(~r/^\s*(?:<br\s*\/?\s*>)+|(?:<br\s*\/?\s*>)+\s*$/, html, "")

module.exports = function(req, res) {
	const ajv = new Ajv()
	const valid = ajv.validate(SCHEMA, req.body)
	if (valid === true) {
		log.info('sanitize_html', `processing request with params '%j'`, req.body)
		return res.status(200).json({
			html: sanitize(req.body.html, SANITIZE_CONFIG),
		})
	} else {
		log.info('sanitize_html', `invalid request with params '%j'`, req.body)
		return res.status(400).json({
			error: 'invalid config',
			config_errors: ajv.errors,
		})
	}
}
