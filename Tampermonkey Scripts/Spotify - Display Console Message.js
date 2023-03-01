// ==UserScript==
// @name         Spotify-Display Console Message
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Unpauses Spotify web when it gets stuck after an ad plays
// @author       various
// @match        https://*.spotify.com/*
// @match        http://*.spotify.com/*
// @grant        none
// ==/UserScript==

// 2021-08-28 - Note; This script disables ads in spotify and allows continuous play of music. This script works in conjuntion with an ad blocker such as uBlock Origin
// Note 2; This script basically disables the ability for the user to select the repeat mode. It will basically be off. 
console.log("Grr. I don't know why this is not working.")

console.log("This is a console log.")
unsafeWindow.console.log("This is a unsafewindow console log.")
GM_log("This is an example of GM_log")
window.log("<This is a window log>");

(function() {
    'use strict';
    setInterval(function () {


        console.log("This is a console log.");
        unsafeWindow.console.log("This is a unsafewindow console log.");
        GM_log("This is an example of GM_log");
        window.log("<This is a window log>");
        alert("this is an alert");

        
    }, 5000); // Set time for how often you want to check the state of a paused ad

})();
