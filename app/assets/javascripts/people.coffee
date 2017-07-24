# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
  $("#job_company_id").select2
    theme: "bootstrap"

  $("#job_no_end").bind 'click', ->
    if $("#job_no_end:checked").length == 1
      $('.job_end_date').fadeOut()
    else
      $('.job_end_date').fadeIn()

#Initialization
  $("#job_start_date_3i").val("1")
  $("#job_end_date_3i").val("28")
  $("#job_start_date_3i, #job_end_date_3i").hide()
  $('.job_end_date').fadeOut()
  $("#job_no_end").prop('checked', true);
