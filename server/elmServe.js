const express = require('express')
const path = require('path')

const to = filepath => path.join(__dirname, filepath)
const sendFile = filepath => (req, res) => res.sendFile(filepath)

module.exports = app => {
  app.use(express.static(to('../build')))
  app.get('*', sendFile(path.join(to('../build/index.html'))))

  return app
}
