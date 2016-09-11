# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Articles
listenArticles = ->
  [].forEach.call document.querySelectorAll('[data-article]'), (e) ->
    e.clickHandler = ->
      loadArticle(e)
    e.addEventListener 'click', e.clickHandler

  e = document.querySelector('#close-icon')
  e.clickHandler = ->
    document.querySelector('body').removeAttribute 'data-active-group'
    document.querySelector("#show .content").innerHTML = null
    clearActiveArticle()
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


    xhr = new XMLHttpRequest()
    xhr.open 'GET', Routes.article_path(tag: article.getAttribute('data-article'))
    xhr.send(null)

    xhr.onreadystatechange = ->
      DONE = 4
      OK = 200
      if xhr.readyState == DONE
        if xhr.status == OK
          data = xhr.responseText
        else
          console.log('Error: ' + xhr.status)
          data = "<p class='error'>M'enfin ! Ya quelque chose qui à bouché le machin et du coup n'a pas fonctionné. Mais ne t'inquiètes donc pas comme ça, c'est juste une affaire de quelques réglage, voilà tout.</p>"
          content.innerHTML = "Error"

        content.innerHTML = data
        listenTargets()
        listenRating()
        loader.classList.remove 'active'
        content.classList.add 'active'

listenTargets = ->
  [].forEach.call document.querySelectorAll('[data-article-target]'), (e) ->
    e.clickHandler = ->
      document.querySelector("[data-article=#{ e.getAttribute('data-article-target') }]").click()
    e.addEventListener 'click', e.clickHandler

listenRating = ->
  [].forEach.call document.querySelectorAll('[data-rating]'), (e) ->
    e.clickHandler = ->
      e.classList.add 'checked'
      [].forEach.call document.querySelectorAll("[data-rating=#{ e.getAttribute('data-rating') }]"), (f) ->
        f.classList.add 'desactivated'
        f.removeEventListener 'click', f.clickHandler
      sendRating e
    e.addEventListener 'click', e.clickHandler

sendRating = (e) ->
  xhr = new XMLHttpRequest()
  xhr.open 'POST', Routes.ratings_path()
  xhr.setRequestHeader 'X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  xhr.setRequestHeader 'Content-type', 'application/x-www-form-urlencoded'
  xhr.send("rating[tag]=#{ e.getAttribute('data-rating') }&rating[value]=#{ e.getAttribute('data-rating-value') }")

clearActiveArticle = ->
  [].forEach.call document.querySelectorAll('[data-article].active'), (e) ->
    e.classList.remove 'active'

setActiveArticle = (article) ->
  clearActiveArticle()
  article.classList.add 'active'


# Main
document.addEventListener 'DOMContentLoaded', ->
  listenArticles()

  # for redirect via url
  # document.querySelector("[data-article=the_thorns_s_predator]").click()