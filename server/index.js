const express = require('express')
const elmServe = require('./elmServe')
const httpsUpgrade = require('./httpsUpgrade')

process.env.PORT = process.env.PORT || '3000'
const app = express()

const info = console.info

if (process.env.DEPLOYED === 'true') {
  info('Running in deployment mode...')
  info(`-- ${httpsUpgrade.description}`)
  app.set('trust proxy', true)
  app
    .use(httpsUpgrade)
}

elmServe(app)
  .listen(process.env.PORT, () => info('lets do it'))
