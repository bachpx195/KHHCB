{defer, dispatch} = Turbolinks

#JQuery + Tubolinks
handleEvent = (eventName, handler) ->
  document.addEventListener(eventName, handler, false)

translateEvent = ({from, to}) ->
  handler = (event) ->
    event = dispatch(to, target: event.target, cancelable: event.cancelable, data: event.data)
    event.preventDefault() if event.defaultPrevented
  handleEvent(from, handler)

translateEvent from: "turbolinks:click", to: "page:before-change"
translateEvent from: "turbolinks:request-start", to: "page:fetch"
translateEvent from: "turbolinks:request-end", to: "page:receive"
translateEvent from: "turbolinks:before-cache", to: "page:before-unload"
translateEvent from: "turbolinks:render", to: "page:update"
translateEvent from: "turbolinks:load", to: "page:change"
translateEvent from: "turbolinks:load", to: "page:update"

loaded = false
handleEvent "DOMContentLoaded", ->
  defer ->
    loaded = true
handleEvent "turbolinks:load", ->
  if loaded
    dispatch("page:load")

jQuery?(document).on "ajaxSuccess", (event, xhr, settings) ->
  if jQuery.trim(xhr.responseText).length > 0
    dispatch("page:update")


#CKEditor + Turbolinks
jQuery(document).on('turbolinks:load', (e)->
    $('textarea.ckeditor').each(->
      if $(this).css('visibility') != 'hidden'
        # console.log(this)
        CKEDITOR.replace(this)
    )
)