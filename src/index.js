import './main.css'
import { Elm } from './Main.elm'
import * as serviceWorker from './serviceWorker'

import { pixelate } from './dots'

const canvas = document.getElementById('measure-canvas')

const flags = {
  dotConfig: {
    ...pixelate({
      text: 'joe thel',
      width: 150,
      resolution: 3,
    }),
    frameLength: 10,
    cutoffPercentage: 100,
  },
  mainDotConfig: {
    ...pixelate({
      text: 'joe',
      width: Math.floor(Math.min(window.innerWidth * 0.8, window.innerHeight * 0.9)),
      resolution: 15,
    }),
    frameLength: 40,
    cutoffPercentage: 50,
  },
}

Elm.Main.init({
  node: document.getElementById('root'),
  flags,
})

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister()
