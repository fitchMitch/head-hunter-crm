# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#comaction_mission_id, #comaction_person_id").select2
    theme: "bootstrap"
  #---------------------------------------------------
  # qs = (key) ->
  #   key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&") # escape RegEx meta chars
  #   match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"))
  #   match && decodeURIComponent(match[1].replace(/\+/g, " "))
  #---------------------------------------------------
  el  = ("#comaction_start_time_#{i}i" for i in[1..6])
  ele  = ("#comaction_end_time_#{i}i" for i in[1..6])
  closures  = []
  frameze = "frameze"

  #---------------------------------------------------
  $("#comaction_end_time_3i,#comaction_end_time_2i,#comaction_end_time_1i").hide()
  $(".status-frame").popover({delay: { "show": 300, "hide": 150 }})
  unless $('input').is(':checked')
    $(el[0]).parent().parent().parent().fadeOut()
    $("#comaction_is_dated").parent().addClass(frameze)

  #---------------------------------------------------
  # Events
  #---------------------------------------------------
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
  $("#comaction_is_dated").on 'click', ->
    if ($('input').is(':checked'))
      $(el[0]).parent().parent().parent().fadeIn("slow")
      $(this).parent().removeClass(frameze)
    else
      $(el[0]).parent().parent().parent().fadeOut("slow")
      $(this).parent().addClass(frameze)
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



  # -------------------------
  # Label for comaction name
  # -------------------------
  $("#comaction_person_id, #comaction_status , #comaction_action_type , #comaction_mission_id").on 'change', ->
    t = $("#comaction_person_id option:selected").text() + " - "
    t += $("#comaction_mission_id option:selected").text()
    $("#comaction_name").val(t)
  # -------------------------
  # Modal
  # -------------------------
  $('#myModal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget) # Button that triggered the modal
    recipient = button.data('whenever') # Extract info from data-* attributes
    # // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
    # // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
    setTimeout ()->
      $("#comaction_is_dated").val("1")
    , 400
    modal = $(this)
    modal.find('.modal-body input').val(recipient)
    pushed_date = recipient.split("-").map (x) -> parseInt(x,10).toString()
    $("#comaction_start_time_1i").val(pushed_date[0])
    $("#comaction_start_time_2i").val(pushed_date[1])
    $("#comaction_start_time_3i").val(pushed_date[2])
    $("#comaction_end_time_1i").val(pushed_date[0])
    $("#comaction_end_time_2i").val(pushed_date[1])
    $("#comaction_end_time_3i").val(pushed_date[2])
    undefined



  #---------------------------------------------------
  undefined
