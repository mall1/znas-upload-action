
const puppeteer = require('puppeteer');

const uploadUrl = process.env.UPLOAD_URL;
const uploadFile = process.env.UPLOAD_FILE;

(async () => {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();

  await page.goto(uploadUrl);

  const fileInput = await page.$('input[type=file]');
  await fileInput.uploadFile(uploadFile);

  const uploadButton = await page.$('button.el-button--primary.el-button--small');
  await uploadButton.click();

  await page.waitForFunction(
    () => document.querySelector('div').innerText.includes('已完成'),
    { timeout: 1800000 }
  );

  await browser.close();
})();
