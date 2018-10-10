// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require_tree .
//= require decidim
//

$(document).ready(function() {
  $('.section-heading').eq(1).css({"border-bottom": "10px solid #fff16e"});
  $('.section-heading').eq(2).css({"border-bottom": "10px solid #33e986"});
  $('.section-heading').eq(4).css({"border-bottom": "10px solid #fff16e"});
  $('.section-heading').eq(5).css({"border-bottom": "10px solid #33e986"});
});
