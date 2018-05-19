#!/usr/bin/env node

const config = require('./setup')('./do_webpage_screenshot_schema.json')

const { writeFileSync } = require('fs')
const puppeteer = require('puppeteer')
const sizeOf = require('image-size')

function logFileSize(obj) {
	const buff = Buffer.from(JSON.stringify(obj), 'utf8').toString('base64')
	console.log(buff)
}

async function saveImages(imgConfigs) {
	const browser = await puppeteer.launch()
	const imgAwaits = imgConfigs.map(async conf => {
		const page = await browser.newPage()
		const response = await page.goto(conf.webpageUrl, {
			timeout: 3000,
			waitUntil: 'networkidle0'
		})
		if (Math.floor(response.status() / 100) !== 2) {
			throw new Error("failed to load page!")
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

saveImages(config)
