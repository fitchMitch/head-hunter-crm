# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#comaction_mission_id, #comaction_person_id").select2
    theme: "bootstrap"
  #---------------------------------------------------
  qs = (key) ->
    key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&") # escape RegEx meta chars
    match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"))
    match && decodeURIComponent(match[1].replace(/\+/g, " "))
  #---------------------------------------------------
  $("#comaction_is_dated ").on 'click', ->
    if($("#comaction_is_dated:checked").val()=="1")
      d = new Date()
      $("#comaction_start_time_1i").val(d.getFullYear())
      $("#comaction_start_time_2i").val(d.getMonth()+1)
      $("#comaction_start_time_3i").val(d.getDate())
      $("#comaction_start_time_4i").val(d.getHours())
      $("#comaction_start_time_5i").val(d.getMinutes())

      $("#comaction_end_time_1i").val(d.getFullYear())
      $("#comaction_end_time_2i").val(d.getMonth()+1)
      $("#comaction_end_time_3i").val(d.getDate())
      $("#comaction_end_time_4i").val(d.getHours()+1)
      $("#comaction_end_time_5i").val(d.getMinutes())
  #---------------------------------------------------
  el  = ("#comaction_start_time_#{i}i" for i in[1..6])
  ele  = ("#comaction_end_time_#{i}i" for i in[1..6])
  closures  = []
  for i in [0..5]
    closures[i] = do (i) ->
      $(el[i]).on 'change', ->
        if(i != 3)
          $(ele[i]).val($(el[i]).val())
        else
          hour = parseInt($(el[i]).val(), 10) + 1
          hour = "0" + hour if hour < 10
          $(ele[i]).val(hour.toString())
  #---------------------------------------------------
  $("input[type=checkbox]").on 'click', ->
    if ($('input').is(':checked'))
      $(el[0]).parent().parent().parent().fadeIn("slow")
    else
      $(el[0]).parent().parent().parent().fadeOut("slow")

  $("#comaction_person_id, #comaction_status , #comaction_action_type , #comaction_mission_id").on 'change', ->
    t = $("#comaction_person_id option:selected").text() + " - "
    t += $("#comaction_mission_id option:selected").text()
    $("#comaction_name").val(t)

  $("#comaction_end_time_3i,#comaction_end_time_2i,#comaction_end_time_1i").hide()
  $(".status-frame").popover()
