module.exports = {
	$schema: 'http://json-schema.org/draft-07/schema#',
	title: 'Config',
	type: 'array',
	items: {
		title: 'Phone numbers',
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
	},
}
