// ==UserScript==
// @name        duckduckgo theme
// @include https://*.duckduckgo.com/*
// @include https://duckduckgo.com/*
// @version     1
// ==/UserScript==
var color = [
  //title
  "9={{replace accent_cyan "#" ""}}",
  //visited title
  "aa={{replace accent_purple "#" ""}}",
  //content Background
  "7={{replace bg_primary "#" ""}}",
  //result info color
  "8={{replace accent_blue "#" ""}}",
  //header Background
  "j={{replace fg_primary "#" ""}}",
  //url
  "x={{replace accent_cyan "#" ""}}",
  //result item Background
  "21={{replace fg_primary "#" ""}}",
];

function allColorsInCookies() {
  for (var i = 0; i < color.length; i++) {
    if(!document.cookie.includes(color[i]))
        return false;
  }
  return true;
};

if (!allColorsInCookies()) {
  document.cookie = ""
  for (var i = 0; i < color.length; i++) {
    document.cookie = color[i];
  }
  location.reload();
}
