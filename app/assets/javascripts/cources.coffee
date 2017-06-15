# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("#addCource").on "click", (event) ->
    page = parseInt($("#page").val())
    type = parseInt($("#type").val())
    page = page + 1
    $.ajax(
      type: 'GET'
      dataType: 'html'
      url: '/cources/ajax'
      data: {page: page, type: type}
      error: (jqXHR, textStatus, errorThrown) ->
        $("#cource").append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $("#cource-list").append "#{data}"
        $("#page").val(page)
    )
  event.preventDefault()
