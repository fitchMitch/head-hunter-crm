# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
  $("#job_company_id").select2
    theme: "bootstrap"

  $("#job_no_end").bind 'change', ->
    if @checked
      $('.job_end_date').fadeToggle()
    else
      $('.job_end_date').fadeIn()
