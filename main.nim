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
  IFS = tuple[xc, yc: Coeffs, p: float, variation: Variation]

proc linear(pt: Point): Point = pt
  
proc apply(ifs: IFS, coord: Point): Point =
  let (x, y) = coord
  let (xx, yy, p, variation) = ifs
  let (a,b,c) = xx
  let (d,e,f) = yy
  variation( (a*x + b*y + c, d*x + e*y + f) )  

#proc generate(ifss: seq[IFS], pt: Point)

proc sdlMain() =
  const 
    Width = 800
    Height = 800
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
    xc: Coeffs = (s*(cos(PI/4.0)), s*(-sin(PI/4)), 0.0)
    yc: Coeffs = (s*(sin(PI/4.0)), s*(cos(PI/4)),  0.0)
    f: IFS =( xc: xc, 
        yc: yc,
        p: 0.5.float, 
        variation: proc(pt: Point): Point = pt )
    ifs: seq[IFS] = @[f]
    # ,
    #   ( (s*(cos(3*PI/4)), s*(-sin(3*PI/4)), 1.0), 
    #     (s*(sin(3*PI/4)), s*(cos(3*PI/4)),  0.0),
    #     0.5, linear )
    # ]
    # pts = newSeqWith(100, (0.0,0.0)).map(proc (pt: Point): Point = (random(2.0)-1.0, random(2.0)-1.0))        

  fpsman.init



  while runGame:
    while pollEvent(evt):
      if evt.kind == QuitEvent:
        runGame = false
        break

    let dt = fpsman.getFramerate() / 1000
    render.setDrawColor 0,0,0xFF,0xFF
    render.clear

    let f: IFS = random(ifs)
    let p = (random(2.0)-1.0,  random(2.0)-1.0)
    apply(f, p)

    # render.setDrawColor 0,0,0xFF,0xFF
    # render.clear

    #fill_circle(windowSurface, 10, 10, 20, 0xffffffff);

    # thickLineColor(render, 0, 0, 640,480, 20,  0xFF00FFFFu32)
    # thickLineColor(render, 0, 640, 480, 0, 20, 0xFF00FFFFu32)
    # render.filledCircleColor(100, 100, 10, 0xffffffFFu32)

    render.setDrawColor 0,0,0x00,0x00
    render.drawPoint(400,300)



    render.present
    fpsman.delay

  destroy render
  destroy window

  

when isMainModule:
  sdlMain()


