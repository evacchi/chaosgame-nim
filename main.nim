import sdl2, sdl2/gfx, random, math, sequtils

type
  Point = tuple[x, y: float]

  # A variation is just a function R^2->R^2
  Variation = proc (pt: Point): Point

  # IFS data type
  # it represents a IFS function as a pair of triples
  # specifying the coefficients for x, y
  # the last float value is a probability
  #
  # the IfsVar alternate datatype provides a Variation type, which is a function
  Coeffs = (float,float,float)
  IFS = object
    xc, yc: Coeffs
    p: float
    variation: Variation

proc linear(pt: Point): Point = pt
proc spherical(pt: Point): Point = 
  let (x,y) = pt
  let r2 = pt.x*pt.x + pt.y*pt.y
  (x * sin(r2) - y*cos(r2) , x*cos(r2) + y*sin(r2) )

proc swirl(pt: Point): Point = 
  let (x,y) = pt
  let r2 = pt.x*pt.x + pt.y*pt.y
  (x * sin(r2) - y*cos(r2), x*cos(r2) + y*sin(r2) )

proc apply(ifs: IFS, coord: Point): Point =
  let (x, y) = coord
  let (a,b,c) = ifs.xc
  let (d,e,f) = ifs.yc
  ifs.variation( (a*x + b*y + c, d*x + e*y + f) )


proc step(ifs: seq[IFS], p: Point): Point = 
  let f = random(ifs)
  f.apply(p)

proc chaos(ifs: seq[IFS], n: int, pts: seq[Point]): seq[Point] =
  if (n == 0):
    pts
  else:
    let pp = pts.map(proc(pt:Point):Point = step(ifs, pt))
    (chaos(ifs, n-1, pp))

#proc generate(ifss: seq[IFS], pt: Point)

proc sdlMain() =
  const
    Width = 1000
    Height = 1000
  discard sdl2.init(INIT_EVERYTHING)

  var
    window: WindowPtr
    render: RendererPtr

  window = createWindow("SDL Skeleton", 100, 100, Width, Height, SDL_WINDOW_SHOWN)
  render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)

  var
    evt = sdl2.defaultEvent
    runGame = true
    fpsman: FpsManager
    s: float = 1.0/sqrt(2.0)
    ifs: seq[IFS] =
      @[
        IFS(
          xc: ( s*cos(PI/4.0), -s*sin(PI/4.0), 0.0 ),
          yc: ( s*sin(PI/4.0),  s*cos(PI/4.0), 0.0 ),
          p: 0.5,
          variation: proc(p: Point): Point = swirl(spherical(p))
        ),
        IFS(
          xc: ( s*cos(3*PI/4.0), -s*sin(3*PI/4.0), 1.0),
          yc: ( s*sin(3*PI/4.0),  s*cos(3*PI/4.0), 0.0),
          p: 0.5,
          variation: proc(p: Point): Point = swirl(spherical(p))
        )
      ]
      # @[
      #    IFS(xc: (0.0,0.0,0.0),      yc:  (0.0,0.16,0.0),      p:  0.01, variation: linear),
      #    IFS(xc:(0.85,0.04,0.0), yc: (-0.04,0.85,1.6), p: 0.85, variation: linear),
      #    IFS(xc:(0.2,-0.26,0.0), yc:(0.23,0.22,1.6),  p: 0.07, variation: linear),
      #    IFS(xc:(-0.15,0.28,0.0),yc:(0.26,0.24,0.44),p: 0.07, variation: linear)
      # ]
    pts = chaos(ifs, 40, newSeqWith(300000, (0.0,0.0)))

    

  fpsman.init

  # for i in 1..300:
  #   let f: IFS = random(ifs)
  #   let p = (random(2.0)-1.0,  random(2.0)-1.0)
  #   let pr = f.apply(p)
  
  
  while runGame:
    while pollEvent(evt):
      if evt.kind == QuitEvent:
        runGame = false
        break

    let dt = fpsman.getFramerate() / 1000
    render.setDrawColor 0,0,0xFF,0xFF
    render.clear

    
    render.setDrawColor 0,0,0x00,0x00
    for pr in pts:
      render.drawPoint((Width/2 + pr.x*Width/3).cint, (Height/2 + pr.y*Height/3).cint)
    render.present
    fpsman.delay

    # render.setDrawColor 0,0,0xFF,0xFF
    # render.clear

    #fill_circle(windowSurface, 10, 10, 20, 0xffffffff);

    # thickLineColor(render, 0, 0, 640,480, 20,  0xFF00FFFFu32)
    # thickLineColor(render, 0, 640, 480, 0, 20, 0xFF00FFFFu32)
    # render.filledCircleColor(100, 100, 10, 0xffffffFFu32)






  destroy render
  destroy window



when isMainModule:
  sdlMain()

