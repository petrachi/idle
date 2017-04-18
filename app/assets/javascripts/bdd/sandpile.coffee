class window.SandpileHelper
  constructor: (@grid, @sand) ->
    @angle = 13*TAU/72
    @vector = new Quaternion(0,1,-0.125,0.125)
    @perspective = new Quaternion(0,0,0,-256)

  draw: (svg_elt) ->
    @grid.rotate(@vector, @angle).toSvg(svg_elt, @perspective)

    for pile in @sand
      pile = new Function("return " + pile)()
      pile.rotate(@vector, @angle).toSvg(svg_elt, @perspective)
