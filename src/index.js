import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

Elm.Main.init({
  node: document.getElementById('root')
});

registerServiceWorker();


window.onload = function () {
  document.getElementById("refreshCacheButton").onclick = function() {
    window.location.reload();
  }
}