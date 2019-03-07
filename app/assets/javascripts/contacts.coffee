$(document).on "turbolinks:load", ->
  $("#person_is_client").on 'click', ->
    if $("#person_is_client:checked").length == 1
      $('.person_cv_docx').fadeOut()
    else
      $('.person_cv_docx').fadeIn()
