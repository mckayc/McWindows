// ==UserScript==
// @name         Spotify-Pause-Fix
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Fixes spotify getting stuck after playing a few songs
// @author       anonymous
// @match        https://*.spotify.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    setInterval(function () {
console.log("Checking if active state is on an AD.");

        var is_stuck = document.title.startsWith("Advertisement");

        if (is_stuck) {
console.log("AD Detected. Attempting to press the Pause button to bypass the add and resume playing.");

            var buttons = document.getElementsByClassName("player-controls__buttons")[0];
            var b = buttons.childNodes[2].childNodes[0];
            var playPauseButton = document.querySelector("button[title='Play'], button[title='Pause']");

            if (b != null) {
                playPauseButton.click();
console.log("Play/Pause Button Clicked.");

            }

        }
    }, 1000);

})();