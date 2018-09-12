#!/bin/sh
':' //; exec "$(command -v nodejs || command -v node)" "$0" "$@"

"use strict";

process.stdin.on('end', () => { process.exit(1) })
process.on('unhandledRejection', up => { throw up })

import "@babel/polyfill";

import { writeFileSync } from "fs"
import puppeteer from "puppeteer"
import sizeOf from "image-size"
import { setupConfig, setupTimeout, logEncodedObj } from "../utils"
import schema from "./schema.js"

async function saveImages(imgConfigs) {
	const browser = await puppeteer.launch()
	const imgAwaits = imgConfigs.map(async conf => {
		const page = await browser.newPage()
		const response = await page.goto(conf.webpageUrl, {
			timeout: 3000,
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
