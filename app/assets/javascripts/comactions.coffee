# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:load ready", ->
  $("input.datepicker").datepicker()
  $("#comaction_company_id, #comaction_person_id").select2
    theme: "bootstrap"
