const puppeteer = require('puppeteer')

const uploadUrl = process.env.UPLOAD_URL
const uploadFile = process.env.UPLOAD_FILE

;(async () => {
  try {
    const browser = await puppeteer.launch({ headless: true })
    const page = await browser.newPage()

    try {
      // Try to open the URL
      await page.goto(uploadUrl, { waitUntil: 'networkidle2', timeout: 60000 }) // 60s timeout for loading
    } catch (error) {
      // If URL cannot be opened, log the error with the URL and file name
      console.error(`Failed to open URL: ${uploadUrl}`)
      console.error(`File to upload: ${uploadFile}`)
      console.error(`Error: ${error.message}`)
      await browser.close()
      return
    }

    const fileInput = await page.$('input[type=file]')
    await fileInput.uploadFile(uploadFile)

    const uploadButton = await page.$(
      'button.el-button--primary.el-button--small'
    )
    await uploadButton.click()

    await page.waitForFunction(
      () => document.querySelector('div').innerText.includes('已完成'),
      { timeout: 1800000 } // 30-minute timeout for the upload process
    )

    await browser.close()
  } catch (error) {
    // Log any other errors that might occur
    console.error(`An unexpected error occurred: ${error.message}`)
  }
})()
