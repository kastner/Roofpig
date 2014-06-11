#= require roofpig/Colors

class @Config
  constructor: (config_string) ->
    @raw_input = Config._parse(config_string)
    @base = this.base_config(@raw_input['base'], config_string)

    @alg    = this.raw("alg")
    @hover  = this.raw("hover", 2.0)
    @flags  = (this.raw("flags") + ' ' + this.raw("moreflags")).trim()
    @colors = new Colors(this.raw("colored"), this.raw("solved"), this.raw("tweaks"), this.raw("colors"))
    @setup  = this.raw("setup")
    @pov    = this.raw("pov", "Ufr")

  flag: (name) ->
    @flags.indexOf(name) > -1

  raw: (name, default_value = "") ->
    @raw_input[name] || @base.raw(name) || default_value

  base_config: (base_id, config_string) ->
    base_string = window["ROOFPIG_CONF_" + base_id]
    if base_id && not base_string
      log_error("'ROOFPIG_CONF_#{base_id}' does not exist")

    if config_string && config_string == base_string
      log_error("#{base_string} tries to inherit from itself.")
      base_string = null

    if base_string then new Config(base_string) else { raw: -> }


  @_parse: (config_string) ->
    return {} unless config_string

    result = {}
    for conf in config_string.split("|")
      eq_pos = conf.indexOf("=")
      key = conf.substring(0, eq_pos).trim()
      value = conf.substring(eq_pos+1).trim()
      result[key] = value
    result