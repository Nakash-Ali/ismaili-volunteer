#!/bin/sh
':' //; exec "$(command -v nodejs || command -v node)" "$0" "$@"

"use strict";

process.stdin.on('end', () => { process.exit(1) })
process.on('unhandledRejection', up => { throw up })

const puppeteer = require("puppeteer")
const { argv } = require("yargs")
const { setupConfig, setupSuicideTimeout, launchBrowser, launchPage } = require("../utils")
const schema = require("./schema.js")

async function savePDFs(pdfConfigs) {
	const browser = await launchBrowser(puppeteer)
	const pdfAwaits = pdfConfigs.map(async conf => {
		const page = await launchPage(browser, conf.webpageUrl)
		const pdfFile = await page.pdf({
			path: conf.outputPath,
			pageRanges: '',
			displayHeaderFooter: false,
			printBackground: true,
			format: 'letter',
			margin: {
				top: '3cm',
				right: '1cm',
				bottom: '3cm',
				left: '1cm'
			}
		})
	})
	await Promise.all(pdfAwaits)
	await browser.close()
}

const config = setupConfig(schema, argv.config)
const cancelSuicideTimeout = setupSuicideTimeout(30000)

savePDFs(config)
	.then(cancelSuicideTimeout)
