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
// Note 2; This script basically disables the ability for the user to select the repeat mode. It will basically be off. 

(function() {
    'use strict';
    setInterval(function () {

        // Find out the currently playing song or ad in the "now playing" section of Spotify
        // - OLD CODE - var nowplaying = document.getElementsByClassName("now-playing")[0].getAttribute("aria-label");
        // - Old, extra class name. Worked in Windows but not mac   -   var nowplaying = document.getElementsByClassName("EWsF13IcnfuEu2no9Pxe tjwF5PJ3oBgTZ38aoRuK")[0].getAttribute("aria-label");
        var nowplaying = document.getElementsByClassName("EWsF13IcnfuEu2no9Pxe")[0].getAttribute("aria-label");
        console.log(`Now Playing = ${nowplaying}`);

        // Find out the current state of Spotify; what is listed in the document/tab - Set to true if on Advertisement
        var playing_ad = document.title.startsWith("Advertisement") || nowplaying.includes("Advertisement");
        console.log(`Document Title = ${document.title}`);
        console.log(`- Playing_Ad state = ${playing_ad}`); // states true/false for if the state is "Playing_Ad"

        // Find out the state of the repeat button
        var repeatButtonState = document.getElementsByClassName("__1BGhJvHnvqYTPyG074")[0].getAttribute("aria-label");
        console.log(`- Repeat Button State = ${repeatButtonState}`); // Results = "Enable repeat", "Enable repeat one", "Disable repeat" - Disable repeat is the state that only repeats one

        // Find out if Spotify is in a Pause or Play state to enable continuous play
        var PlayPausedState = document.getElementsByClassName("gro_tSi7cwspepH0as03")[0].getAttribute("aria-label");
        console.log(`- Play/Paused state = ${PlayPausedState}`) // Results = "Pause", and "Play" - "Play" means that is is currently paused
      
        // Change repeat button if set to repeat one OR if Spotify is in a paused state (note this is just a test to see if this will fix the issue of Spotify removing the currently playing song if it has been in a paused state for a long time)
        if (repeatButtonState === "Disable repeat" || PlayPausedState === "Play") {
            document.getElementsByClassName('__1BGhJvHnvqYTPyG074')[0].click();
            console.log("Repeat button pressed to disallow repeating of a single song or to prevent Spotify from removing the song if being paused too long.");
        }       

        // Find out if Spotify is in a Pause or Play state to enable continuous play
        if (playing_ad) {
            console.log("Ad is being played. The repeat button will be pressed until Spotify is no longer in an ad playing state.");
            document.getElementsByClassName('__1BGhJvHnvqYTPyG074')[0].click();
            console.log("Repeat button pressed to exit ad playing state.");
        }
        
    }, 5000); // Set time for how often you want to check the state of a paused ad

})();
