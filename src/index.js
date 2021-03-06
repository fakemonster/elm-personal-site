import './main.css'
import { Elm } from './Main.elm'

import { pixelate } from './dots'

const canvas = document.getElementById('measure-canvas')

const oneOf = opts => opts[Math.floor(Math.random() * opts.length)]

const flags = {
  dotConfig: {
    ...pixelate({
      text: 'joe thel',
      width: 150,
      resolution: oneOf([2, 3, 10, 20]),
    }),
    frameLength: 10,
    cutoffPercentage: 100,
  },
  mainDotConfig: {
    ...pixelate({
      text: 'hey',
      width: Math.floor(Math.min(window.innerWidth * 0.8, window.innerHeight * 1.4)),
      resolution: 15,
    }),
    frameLength: 80,
    cutoffPercentage: 80,
  },
}

Elm.Main.init({
  node: document.getElementById('root'),
  flags,
})
