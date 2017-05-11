# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#comaction_mission_id").select2
    theme: "bootstrap"
  $("#comaction_person_id").select2
    theme: "bootstrap"
  #---------------------------------------------------
  el  = ("#comaction_start_time_#{i}i" for i in[1..6])
  ele  = ("#comaction_end_time_#{i}i" for i in[1..6])
  closures  = []
  for i in [0..5]
    closures[i] = do (i) ->
      $(el[i]).on 'change', ->
        $(ele[i]).val($(el[i]).val())
  #---------------------------------------------------
  $("input[type=checkbox]").on 'click', ->
    if ($('input').is(':checked'))
      $(el[0]).parent().parent().parent().fadeIn("slow")
    else
      $(el[0]).parent().parent().parent().fadeOut("slow")
