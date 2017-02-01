class window.MultEngine
  this.initialize = (options) ->
    options.draw_modulo = options.draw_modulo ? true
    new MultEngine options.svg, options.table, options.modulo, options.draw_modulo

  constructor: (@svg_elt, @table, @modulo, @draw_modulo) ->
    this.initSvg()

  initSvg: ->
    circle = document.createElementNS("http://www.w3.org/2000/svg", "circle")
    circle.setAttribute 'cx', 0
    circle.setAttribute 'cy', 0
    circle.setAttribute 'r', 40

    @svg_elt.setAttribute 'viewBox', '-50 -50 100 100' unless @svg_elt.hasAttribute 'viewBox'
    @svg_elt.appendChild circle


  setModulo: (modulo) ->
    @modulo = modulo
    @modulo_drawn = false
    @table_drawn = false
    this

  setTable: (table) ->
    @table = table
    @table_drawn = false

    this


  calcModulo: ->
    @modulo_points = for i in [0..@modulo - 1]
      angle = i * Math.PI * 2 / @modulo
      x: Math.sin(angle), y: -Math.cos(angle)

  clearModulo: ->
    for elt in @modulo_elts
      @svg_elt.removeChild elt.circle
      @svg_elt.removeChild elt.text

    @modulo_elts = null

  drawModulo: ->
    this.clearModulo() if @modulo_elts

    @modulo_elts = for i in [0..@modulo - 1]
      point = @modulo_points[i]

      circle = document.createElementNS("http://www.w3.org/2000/svg", "circle")
      circle.setAttribute 'cx', point.x * 40
      circle.setAttribute 'cy', point.y * 40
      circle.setAttribute 'r', 0.5

      text = document.createElementNS("http://www.w3.org/2000/svg", "text")
      text.setAttribute 'x', point.x * 43 - Math.abs(point.x * 0.625) - 0.625
      text.setAttribute 'y', point.y * 42.5 + 0.75
      text.textContent = i

      circle: circle, text: text

    for elt in @modulo_elts
      @svg_elt.appendChild elt.circle
      @svg_elt.appendChild elt.text

    @modulo_drawn = true

  clearTable: ->
    for elt in @table_elts
      @svg_elt.removeChild elt.line

    @table_elts = null

  drawTable: ->
    this.clearTable() if @table_elts

    @table_elts = for i in [1..@modulo - 1]
      angle = @table * i * Math.PI * 2 / @modulo
      start_point = @modulo_points[i]
      end_point =
        x: Math.sin(angle),
        y: -Math.cos(angle)

      line = document.createElementNS("http://www.w3.org/2000/svg", "line")
      line.setAttribute 'x1', start_point.x * 40
      line.setAttribute 'y1', start_point.y * 40
      line.setAttribute 'x2', end_point.x * 40
      line.setAttribute 'y2', end_point.y * 40

      start_point: start_point, end_point: end_point, line: line

    for elt in @table_elts
      @svg_elt.appendChild elt.line

    @table_drawn = true



  toSvg: ->
    this.calcModulo()
    this.drawModulo() if @draw_modulo && !@modulo_drawn
    this.drawTable() unless @table_drawn
    this

  animate: (options = {}, callback) ->
    options.loop = options.loop ? false
    if options.loop
      loop_modulo = @modulo
      loop_table = @table

    options.modulo = options.modulo ? @modulo
    options.table = options.table ? @table
    options.speed = options.speed ? 1.0

    steps = 300 / options.speed
    step_count = 0

    modulo_step = (options.modulo - @modulo) / steps
    table_step = (options.table - @table) / steps


    that = this

    animation = ->
      that.setModulo(that.modulo + modulo_step) unless modulo_step == 0
      that.setTable(that.table + table_step) unless table_step == 0
      that.toSvg()
      options.each_step(that) if options.each_step

      step_count += 1

      if step_count < steps
        requestAnimationFrame(animation)
      else
        that.setModulo(options.modulo) unless modulo_step == 0
        that.setTable(options.table) unless table_step == 0
        that.toSvg()

        callback() if callback
        if options.loop
          options.modulo = loop_modulo
          options.table = loop_table
          that.animate options

    animation()

  setAnimationTrigger: (options = {}) ->
    elt = document.querySelector("[mult-engine-trigger=#{ @svg_elt.id }]")

    base_modulo = @modulo
    base_table = @table
    active = false

    that = this

    @svg_elt.addEventListener 'play-animation', ->
      if !active
        active = true
        that.animate options, ->
          elt.classList.add 'active'

    elt.addEventListener 'click', ->
      active = false
      elt.classList.remove 'active'
      that.setModulo(base_modulo)
      that.setTable(base_table)
      that.svg_elt.dispatchEvent(new CustomEvent 'play-animation')
