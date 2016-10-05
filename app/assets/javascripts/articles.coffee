# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Articles
listenArticles = ->
  for e in document.querySelectorAll('[data-article]')
    do (e) ->
      e.clickHandler = ->
        loadArticle(e)
      e.addEventListener 'click', e.clickHandler

  e = document.querySelector('#close-icon')
  e.clickHandler = ->
    history.pushState {}, "", Routes.root_path
    closeArticle()
  e.addEventListener 'click', e.clickHandler

loadArticle = (article) ->
  unless article.classList.contains('active')
    setActiveArticle article

    group = article.getAttribute('data-article-group')
    document.querySelector('body').setAttribute 'data-active-group', group

    show = document.querySelector("#show")
    show.querySelector(".title").innerHTML = article.innerHTML

    loader = show.querySelector(".loader")
    loader.classList.add 'active'

    content = show.querySelector(".content")
    content.innerHTML = null
    content.classList.remove 'active'

    tag = article.getAttribute('data-article')
    if article.historyBack
      article.historyBack = false
    else
      history.pushState {tag: tag}, "", Routes.direct_to_path(tag: tag)

    xhr = new XMLHttpRequest()
    xhr.open 'GET', Routes.article_path(tag: tag)
    xhr.send(null)

    xhr.onreadystatechange = ->
      DONE = 4
      OK = 200
      if xhr.readyState == DONE
        if xhr.status == OK
          data = xhr.responseText
        else
          console.log('Error: ' + xhr.status)
          data = "<p class='error'>M'enfin ! Ya quelque chose qui à bouché le machin et du coup ça n'a pas fonctionné. Mais ne t'inquiètes donc pas comme ça, c'est juste une affaire de quelques réglage, voilà tout.</p>"
          content.innerHTML = "Error"

        content.innerHTML = data
        listenTargets()
        listenRating()
        executeScripts()
        loader.classList.remove 'active'
        content.classList.add 'active'

closeArticle = ->
  document.querySelector('body').removeAttribute 'data-active-group'
  document.querySelector("#show .content").innerHTML = null
  clearActiveArticle()


listenTargets = ->
  for e in document.querySelectorAll('[data-article-target]')
    do (e) ->
      e.clickHandler = ->
        document.querySelector("[data-article=#{ e.getAttribute('data-article-target') }]").click()
      e.addEventListener 'click', e.clickHandler

listenRating = ->
  for e in document.querySelectorAll('[data-rating]')
    do (e) ->
      e.clickHandler = ->
        e.classList.add 'checked'
        for f in document.querySelectorAll("[data-rating=#{ e.getAttribute('data-rating') }]")
          f.classList.add 'disabled'
          f.removeEventListener 'click', f.clickHandler
        sendRating e
      e.addEventListener 'click', e.clickHandler

sendRating = (e) ->
  xhr = new XMLHttpRequest()
  xhr.open 'POST', Routes.ratings_path()
  xhr.setRequestHeader 'X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  xhr.setRequestHeader 'Content-type', 'application/x-www-form-urlencoded'
  xhr.send("rating[tag]=#{ e.getAttribute('data-rating') }&rating[value]=#{ e.getAttribute('data-rating-value') }")

executeScripts = ->
  eval(scr.innerHTML) for scr in document.querySelectorAll('script')

clearActiveArticle = ->
  e.classList.remove('active') for e in document.querySelectorAll('[data-article].active')

setActiveArticle = (article) ->
  clearActiveArticle()
  article.classList.add 'active'

directTo = (tag, historyBack = false) ->
    direct_to = document.querySelector("[data-article=#{ tag }")
    if direct_to
      direct_to.historyBack = historyBack
      direct_to.click()



# Main
document.addEventListener 'DOMContentLoaded', ->
  listenArticles()
  directTo document.querySelector("#articles").getAttribute('data-d'), true

window.onpopstate = (e) ->
  if e.state && e.state.tag
    directTo e.state.tag, true
  else
    closeArticle()
