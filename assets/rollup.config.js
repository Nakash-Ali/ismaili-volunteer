const nodeResolve = require('rollup-plugin-node-resolve')
const commonJs = require('rollup-plugin-commonjs')
const babel = require('rollup-plugin-babel')

const FILE_NAMES = ['app', 'drafterize_form', 'stimulus']

function buildConfig(name) {
	return {
		input: `./js/${name}.js`,
		output: {
			name,
			file: `../priv/static/js/${name}.js`,
			format: 'iife',
		},
		plugins: [
			nodeResolve({
				mainFields: ['browser', 'module', 'main'],
				extensions: ['.js', '.json'],
				preferBuiltins: false,
			}),
			babel({
				exclude: 'node_modules/**',
			}),
			commonJs(),
		],
	}
}

module.exports = FILE_NAMES.map(buildConfig)
