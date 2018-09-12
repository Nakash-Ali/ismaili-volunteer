#!/bin/sh
':' //; exec "$(command -v nodejs || command -v node)" "$0" "$@"

"use strict";

process.stdin.on('end', () => { process.exit(1) })
process.on('unhandledRejection', up => { throw up })

const { writeFileSync } = require("fs")
const puppeteer = require("puppeteer")
const sizeOf = require("image-size")
const { setupConfig, setupTimeout, logEncodedObj } = require("../utils")
const schema = require("./schema.js")

async function saveImages(imgConfigs) {
	const browser = await puppeteer.launch({args: ['--no-sandbox', '--disable-setuid-sandbox']})
	const imgAwaits = imgConfigs.map(async conf => {
		const page = await browser.newPage()
		const response = await page.goto(conf.webpageUrl, {
			timeout: 6000,
			waitUntil: 'networkidle0'
		})
		if (Math.floor(response.status() / 100) !== 2) {
			throw new Error('failed to load page!')
		}
		const pngFile = await page.screenshot({
			fullPage: true,
			omitBackground: true
		})
		writeFileSync(conf.outputPath, pngFile)
		logEncodedObj(sizeOf(pngFile))
	})
	await Promise.all(imgAwaits)
	await browser.close()
}

const config = setupConfig(schema)
const done = setupTimeout()

saveImages(config)
	.then(done)
