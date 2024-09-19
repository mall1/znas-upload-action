const puppeteer = require('puppeteer')

const uploadUrl = process.env.UPLOAD_URL
const uploadFile = process.env.UPLOAD_FILE

;(async () => {
  try {
    const browser = await puppeteer.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    })
    const page = await browser.newPage()

    try {
      // Try to open the URL
      console.log(`Navigating to ${uploadUrl}`)
      await page.goto(uploadUrl, { waitUntil: 'networkidle2', timeout: 60000 }) // 60s timeout for loading
    } catch (error) {
      console.error(`Failed to open URL: ${uploadUrl}`)
      console.error(`File to upload: ${uploadFile}`)
      console.error(`Error: ${error.message}`)
      await browser.close()
      return
    }

    try {
      // Select the file input element and upload the file
      console.log('Looking for file input element...')
      const fileInput = await page.$('input[type=file]')
      if (!fileInput) {
        throw new Error('File input element not found')
      }

      console.log(`Uploading file: ${uploadFile}`)
      await fileInput.uploadFile(uploadFile)
    } catch (error) {
      console.error(`Error while uploading the file: ${error.message}`)
      await browser.close()
      return
    }

    try {
      // Find and click the upload button
      console.log('Looking for upload button...')
      const uploadButton = await page.$(
        'button.el-button--primary.el-button--small'
      )
      if (!uploadButton) {
        throw new Error('Upload button not found')
      }

      console.log('Clicking upload button...')
      await uploadButton.click()
    } catch (error) {
      console.error(`Error while clicking the upload button: ${error.message}`)
      await browser.close()
      return
    }

    // Wait for upload to complete
    try {
      console.log('Waiting for upload to complete...')
      await page.waitForFunction(
        () => document.querySelector('div').innerText.includes('已完成'),
        { timeout: 1800000 } // 30-minute timeout for the upload process
      )
      console.log('Upload completed successfully.')
    } catch (error) {
      console.error(
        `Upload did not complete within the expected time: ${error.message}`
      )
    }

    await browser.close()
  } catch (error) {
    console.error(`An unexpected error occurred: ${error.message}`)
  }
})()
