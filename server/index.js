const express = require('express')
const elmServe = require('./elmServe')

process.env.PORT = process.env.PORT || '3000'
const app = express()

elmServe(app)
  .listen(process.env.PORT, () => console.info('lets do it'))
