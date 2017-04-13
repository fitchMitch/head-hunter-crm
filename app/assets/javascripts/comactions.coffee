# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:load ready", ->

  $("#comaction_mission_id").select2
    theme: "bootstrap"
  $("#comaction_person_id").select2
    theme: "bootstrap"

  el  = ("#comaction_start_time_#{i}i" for i in[1..6])
  ele  = ("#comaction_end_time_#{i}i" for i in[1..6])

  $("input[type=checkbox]").on 'click', ->
    if !($('input').is(':checked'))
      $(el[0]).parent().parent().parent().fadeOut("slow")
    else
      $(el[0]).parent().parent().parent().fadeIn("slow")

  $(el[0]).on 'change', ->
    $(ele[0]).val($(el[0]).val())

  $(el[1]).on 'change', ->
    $(ele[1]).val($(el[1]).val())

  $(el[2]).on 'change', ->
    $(ele[2]).val($(el[2]).val())

  $(el[3]).on 'change', ->
    $(ele[3]).val($(el[3]).val())

  $(el[4]).on 'change', ->
    $(ele[4]).val($(el[4]).val())

  $(el[5]).on 'change', ->
    $(ele[5]).val($(el[5]).val())
