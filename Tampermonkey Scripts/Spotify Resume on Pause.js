// ==UserScript==
// @name         Spotify-uBlock-Origin-Ad_Pause-Fix
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Fixes spotify getting stuck on "Advertisement" when ublock origin is in use
// @author       anonymous
// @match        https://*.spotify.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    setInterval(function () {

        var is_stuck = document.title.startsWith("Advertisement") || document.title == null;
        console.log(`'Is Stuck' state = ${is_stuck}`);
        console.log(`Document Title = ${document.title}`);
        console.log("Now Playing =");
        var result = document.getElementsByClassName("_3773b711ac57b50550c9f80366888eab-scss ellipsis-one-line")[0].innerHTML;
        console.log(result);


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
    }, 5000);

})();