#= require roofpig/utils
#= require roofpig/Cubexp
#= require roofpig/Tweaks

class @Colors

  constructor: (colored, solved, tweaks, colors = "") ->
    @colored = new Cubexp(colored || "*")
    @solved = new Cubexp(solved)
    @tweaks = new Tweaks(tweaks)
    @side_colors = Colors._set_colors(colors)

  to_draw: (piece_name, side) ->
    result = { hovers: false, color: this.of(side) }

    if @solved.matches_sticker(piece_name, side)
      result.color = this.of('solved')
    else if @colored.matches_sticker(piece_name, side)
      result.hovers = true
    else
      result.color = this.of('ignored')

    for tweak in @tweaks.for_sticker(piece_name, side)
      result.hovers = true
      switch tweak
        when 'X', 'x'
          result.x_color = {X: 'black', x: 'white'}[tweak]
        else
          if Layer.by_name(tweak)
            result.color = this.of(tweak)
          else
            log_error("Unknown tweak: '#{tweak}'")
    result

  of: (sticker_type) ->
    type = sticker_type.name || sticker_type
    unless @side_colors[type]
      throw new Error("Unknown sticker type '#{sticker_type}'")
    @side_colors[type]

  adjust_for: (drift) ->
    sc = @side_colors
    [sc.U, sc.D, sc.R, sc.L, sc.F, sc.B] = [sc[drift.U], sc[drift.D], sc[drift.R], sc[drift.L], sc[drift.F],
                                            sc[drift.B]]

  DEFAULT_COLORS = {g:'#0d0', b:'#07f', r:'red', o:'orange', y:'yellow', w:'#eee'}
  @_set_colors: (overrides) ->
    dc = DEFAULT_COLORS
    result = {R:dc.g, L:dc.b, F:dc.r, B:dc.o, U:dc.y, D:dc.w, solved:'#444', ignored:'#888', cube:'black'}

    for override in overrides.split(' ')
      [type, color] = override.split(':')
      type = {s:'solved', i:'ignored', c:'cube'}[type] || type
      result[type] = DEFAULT_COLORS[color] || color
    result
