const nodeResolve = require('rollup-plugin-node-resolve')
const commonJs = require('rollup-plugin-commonjs')
const babel = require('rollup-plugin-babel')

const FILE_NAMES = [
	'app',
	'error',
	'form_submit',
	'old_browsers',
	'smooth',
	'doc_generator',
	'iframe_resizer'
]

function buildConfig(name) {
	return {
		input: `./js/${name}.js`,
		output: {
			name,
			file: `../priv/static/js/${name}.js`,
			format: 'iife',
			globals: { jquery: '$' },
		},
		external: ['jquery'],
		plugins: [
			nodeResolve({
				module: true,
				jsnext: false,
				main: true,
				browser: true,
				extensions: [
					'.js', '.json'
				],
				preferBuiltins: false
			}),
			commonJs(),
			babel({
				exclude: 'node_modules/**'
			})
		]
	}
}

module.exports = FILE_NAMES.map(buildConfig)
