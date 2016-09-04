# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Articles
listenArticles = ->
  [].forEach.call document.querySelectorAll('[data-article]'), (e) ->
    e.clickHandler = ->
      loadArticle(e)
    e.addEventListener 'click', e.clickHandler


loadArticle = (article) ->
  [].forEach.call document.querySelectorAll('[data-article].active'), (e) ->
    e.classList.remove 'active'
  article.classList.add 'active'


  group = article.getAttribute('data-article-group')
  document.querySelector('body').setAttribute 'data-active-group', group
  show = document.querySelector("#show")
  show.innerHTML = "Loading"


# Main
document.addEventListener 'DOMContentLoaded', ->
  listenArticles()
