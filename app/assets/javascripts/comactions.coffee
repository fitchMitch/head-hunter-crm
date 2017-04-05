# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:load ready", ->
  $("input.datepicker").datepicker()

  $("#comaction_mission_id, #comaction_person_id").select2
    theme: "bootstrap"

  $(".comaction_is_dated").bind 'change', ->
    el = $('#comaction_due_date_1i')
    el.parent().fadeToggle()
