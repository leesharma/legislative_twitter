// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-te-1.4.0
//= require jquery_nested_form
//= require jquery-ui/datepicker
//= require geocomplete/jquery.geocomplete
//= require foundation
//= require turbolinks
//= require_tree .



var ready;
ready = function() {
    // todo: only put this on pages that need it
    $(document).foundation();
    // jQuery Text Editor
    $('.jqte-test').jqte();
    // jQuery Datepicker
    $('.datepicker').datepicker({
        dateFormat: "yy-mm-dd"  // to be read by the database
    });
    // jQuery GeoComplete
    $('.geocomplete').geocomplete();
    // Toggles admin-only buttons
    $('#admin-toggle').click(function() {
        $('.admin').toggle(600);
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);