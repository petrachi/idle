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
          data = "M'enfin ! Ya quelque chose qui à bouché le machin et du coup ça a pas marché pile poil. Ne t'inquiètes donc pas comme ça, c'est juste une affaire de quelques réglage, voilà tout."
          content.innerHTML = "Error"

        content.innerHTML = data
        loader.classList.remove 'active'
        content.classList.add 'active'


clearActiveArticle = ->
  [].forEach.call document.querySelectorAll('[data-article].active'), (e) ->
    e.classList.remove 'active'

setActiveArticle = (article) ->
  clearActiveArticle()
  article.classList.add 'active'


# Main
document.addEventListener 'DOMContentLoaded', ->
  listenArticles()
