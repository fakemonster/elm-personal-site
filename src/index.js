import './main.css'
import { Elm } from './Main.elm'
import * as serviceWorker from './serviceWorker'

import { pixelate } from './dots'

const canvas = document.getElementById('measure-canvas')

const randomInt = () =>
  Math.floor(Math.random() * (2 ** 32) - 2 ** 31)

const flags = {
  ...pixelate({ text: 'joe', width: 500 }),
}

console.log(flags)

Elm.Main.init({
  node: document.getElementById('root'),
  flags,
})

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister()
