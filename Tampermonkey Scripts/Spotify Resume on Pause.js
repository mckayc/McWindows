// ==UserScript==
// @name         Spotify-Fix_Ad-Pause
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Unpauses Spotify web when it gets stuck after an ad plays
// @author       various
// @match        https://*.spotify.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    setInterval(function () {

        var nowplaying = document.getElementsByClassName("now-playing")[0].getAttribute("aria-label"); // Find out the currently playing song or ad in the "now playing" section of Spotify
        console.log(`Now Playing = ${nowplaying}`);
        var playing_ad = document.title.startsWith("Advertisement") || nowplaying.includes("Advertisement") || nowplaying === ""; // Find out the current state of Spotify; what is listed in the document/tab
        console.log(`Document Title = ${document.title}`);

        console.log(`'Playing_Ad' state = ${playing_ad}`); // states true/false for if the state is "Playing_Ad"

        var date, formattedTime;
         date = new Date();
         formattedTime = date.toISOString();
        console.log(formattedTime);

        if (playing_ad) {
            console.log("State detected as being paused after ad. Attempting to press the Pause button to resume playing media.");

            var buttons = document.getElementsByClassName("player-controls__buttons")[0];
            var b = buttons.childNodes[2].childNodes[0];
            var playPauseButton = document.querySelector("button[title='Play'], button[title='Pause']");

            if (b != null) {
                playPauseButton.click();
                console.log("Play/Pause Button Clicked.");
            }
        }
    }, 5000); // Set time for how often you want to check the state of a paused ad

})();