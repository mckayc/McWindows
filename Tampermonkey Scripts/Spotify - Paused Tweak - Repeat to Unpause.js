// ==UserScript==
// @name         Spotify-Fix_Ad-Pause_Repeat-to-resume
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Unpauses Spotify web when it gets stuck after an ad plays
// @author       various
// @match        https://*.spotify.com/*
// @grant        none
// ==/UserScript==

// 2021-08-28 - Note; This script disables ads in spotify and allows continuous play of music. This script works in conjuntion with an ad blocker such as uBlock Origin

(function() {
    'use strict';
    setInterval(function () {

        // Find out the currently playing song or ad in the "now playing" section of Spotify
        // - OLD CODE - var nowplaying = document.getElementsByClassName("now-playing")[0].getAttribute("aria-label");
        var nowplaying = document.getElementsByClassName("EWsF13IcnfuEu2no9Pxe tjwF5PJ3oBgTZ38aoRuK")[0].getAttribute("aria-label");
        console.log(`Now Playing = ${nowplaying}`);

        // Find out the current state of Spotify; what is listed in the document/tab - Set to true if on Advertisement
        var playing_ad = document.title.startsWith("Advertisement") || nowplaying.includes("Advertisement");
        console.log(`Document Title = ${document.title}`);
        console.log(`'Playing_Ad' state = ${playing_ad}`); // states true/false for if the state is "Playing_Ad"

        // Find out the state of the repeat button
        var repeatButtonState = document.getElementsByClassName("__1BGhJvHnvqYTPyG074")[0].getAttribute("aria-label");
        console.log(`Repeat Button State = ${repeatButtonState}`); // Results = "Enable repeat", "Enable repeat one", "Disable repeat" - Disable repeat is the state that only repeats one

       // Change repeat button if set to repeat one
        if (repeatButtonState === "Disable repeat") {
            document.getElementsByClassName('__1BGhJvHnvqYTPyG074')[0].click();
            console.log("Repeat button pressed to disallow repeating of a single song.");
        }       

        // Find out if Spotify is in a Pause or Play state to enable continuous play
        if (playing_ad) {
            console.log("Ad is being played. The repeat button will be pressed until Spotify is no longer in an ad playing state.");
            document.getElementsByClassName('__1BGhJvHnvqYTPyG074')[0].click();
            console.log("Repeat button pressed to exit ad playing state.");
        }
        
    }, 5000); // Set time for how often you want to check the state of a paused ad

})();