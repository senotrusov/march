# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require rails-timeago
#= require leaflet-src
#
#= require_self
#= require_tree .


String.prototype.truncate = (min = 30, max = 35) ->
  string = $.trim(this).replace(/[\s]+/g, ' ')

  if string.length <= min
    return string

  else
    truncated = string.match(/// ^.{0,#{min}}[\S]* ///)[0]

    if truncated.length > max
      return string.substr(0, max) + '&hellip;'
      
    else
      return $.trim(truncated) + '&hellip;'


# TODO: oninput, onpropertychange
@nextTick = (func) -> setTimeout func, 0

@timeoutSet = (timeout, func) -> setTimeout func, timeout
@intervalSet = (interval, func) -> setInterval func, interval

$(document).ready ->
  $('#notice, #alert').each ->
    message = $(this)
    setTimeout (-> message.slideUp 'fast'), 10000


$.detect = (array, callback) ->
  for element in array
    return element if callback(element)
  false
