#!/bin/sh
':' //; exec "$(command -v nodejs || command -v node)" "$0" "$@"

'use strict'

process.stdin.on('end', () => {
	process.exit(1)
})
process.on('unhandledRejection', up => {
	throw up
})

const { writeFileSync } = require('fs')
const { argv } = require('yargs')
const puppeteer = require('puppeteer')
const sizeOf = require('image-size')
const {
	setupConfig,
	setupSuicideTimeout,
	logEncodedObj,
	launchBrowser,
	launchPage,
} = require('../utils')
const schema = require('./schema.js')

async function saveImages(imgConfigs) {
	const browser = await launchBrowser(puppeteer)
	const imgAwaits = imgConfigs.map(async conf => {
		const page = await launchPage(browser, conf.webpageUrl)
		const pngFile = await page.screenshot({
			fullPage: true,
			omitBackground: true,
		})
		writeFileSync(conf.outputPath, pngFile)
		logEncodedObj(sizeOf(pngFile))
	})
	await Promise.all(imgAwaits)
	await browser.close()
}

const config = setupConfig(schema, argv.config)
const cancelSuicideTimeout = setupSuicideTimeout(30000)

saveImages(config).then(cancelSuicideTimeout)
