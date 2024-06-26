// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.timeago
//= require turbolinks
//= require foundation
//= require details.polyfill
//= require_tree .

$(function(){ $(document).foundation(); });


$(document).ready(function () {
    $('#PCL').sortable({
        axis: 'y',
        dropOnEmpty: false,
        handle: '.handle',
        cursor: 'ns-resize',
        items: 'li',
        opacity: 0.4,
        scroll: true,
        update: function () {
            $.ajax({
                type: 'post',
                data: $('#PCL').sortable('serialize'),
                dataType: 'script',
                complete: function () {
                    $('#PCL').effect('highlight');
                },
                url: $(this).data('url')
            });
        }
    });
});