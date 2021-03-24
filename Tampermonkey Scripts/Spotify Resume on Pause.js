// ==UserScript==
// @name         Spotify-Fix_Ad-Pause
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  Unpauses Spotify web when it gets stuck after an ad plays
// @author       various
// @match        https://*.spotify.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    setInterval(function () {

        // Post a note to show in the console so show how often the script is checking.
        console.log(`Checking Song / Ad Status`);

        // If you want Spotify to play continuously and never pause, set to "y", otherwise set to anything else
        // Note; this will force play; even if you manually pause it. Default set to "n"
        var continuousPlay = "n"

        // Find out the currently playing song or ad in the "now playing" section of Spotify
        // - OLD CODE - var nowplaying = document.getElementsByClassName("now-playing")[0].getAttribute("aria-label");
        var nowplaying = document.getElementsByClassName("_116b05d7721c9dfb84bb69e8f4fc5e01-scss")[0].getAttribute("aria-label");
        console.log(`Now Playing = ${nowplaying}`);

        // Find out the current state of Spotify; what is listed in the document/tab - Set to true if on Advertisement
        var playing_ad = document.title.startsWith("Advertisement") || nowplaying.includes("Advertisement");
        console.log(`Document Title = ${document.title}`);
        console.log(`'Playing_Ad' state = ${playing_ad}`); // states true/false for if the state is "Playing_Ad"

        // Find out if Spotify is in a Pause or Play state to enable continuous play
        var paused = document.getElementsByClassName("_82ba3fb528bb730b297a91f46acd37a3-scss")[0].getAttribute("aria-label");
        console.log(`Paused state = ${paused}`)
        console.log(`Continuous Play is set to = ${continuousPlay}`)

        // Display a time stamp for statistical purposes
        var date, formattedTime;
         date = new Date();
         formattedTime = date.toISOString();
        console.log(formattedTime);

        if ((playing_ad) || (paused === "Play" && continuousPlay === "y")) {
            console.log("State detected as being paused. Attempting to press the Pause button to resume playing media.");

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