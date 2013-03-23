# Return string value or '' if value is null or undefinded
exports.getSafeStringValue = (str) ->
  return str or ''

# Use: var greeting = formatString("Hi, {0} {1}", 'dear', 'John');
exports.formatString = ->
  # Follow code from: http://stackoverflow.com/questions/2534803/string-format-in-javascript
  s = arguments[0]
  maxLength = arguments.length - 1
  i = 0
  while i < maxLength
    reg = new RegExp "\\{" + i + "\\}", "gm"
    s = s.replace(reg, arguments[i + 1])
    ++i
  
  return s