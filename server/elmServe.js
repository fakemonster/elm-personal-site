const express = require('express')
const path = require('path')
const fs = require('fs')

const to = filepath => path.join(__dirname, filepath)
const sendFile = filepath => (req, res) => res.sendFile(filepath)

const mainCss = fs
  .readdirSync(to('../build/static/css'))
  .find(f => f.match(/^main.*css$/))

module.exports = app => {
  app.use(express.static(to('../build')))
  app.get('/static/css/main.css', sendFile(path.join(to(`../build/static/css/${mainCss}`))))
  app.get('*', sendFile(path.join(to('../build/index.html'))))

  return app
}
