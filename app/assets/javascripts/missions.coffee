# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->

  make_name = ->
    t = "Mission "
    t += $("#mission_company_id option:selected").text()
    t += " "
    $("#mission_name").val(t)

  # -----------------------
  # make_name()

  $("#mission_company_id, #mission_person_id").select2
    theme: "bootstrap"

  $("#mission_company_id, #mission_person_id").attr('selectedIndex', 0);

  $("#mission_person_id").on 'change', ->
    make_name()

  contact_selector = $("#mission_person_id")
  $("#mission_company_id").on 'change', ->
    make_name()

    $.ajax(
      'update_default_representative/',
      type: 'GET'
      dataType: 'JSON'
      data: {company_id: $("#mission_company_id").val() }
      async: false
      error: (xhr,status, error) ->
        console.error('AJAX Error: ' + status + error)
      success: (response) ->
        console.log response.name
        console.log response.contact_id
        contact_selector.val(response.contact_id).trigger('change')
    )

  $("#q_status_eq").on 'change', ->
    $("#mission_search").submit()
