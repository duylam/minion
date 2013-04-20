crypto = require 'crypto'

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
  
exports.generateUniqueKey = (value, cb) -> 
  key = (new Date).getTime().toString()
  for v, i in value
    key += value.charCodeAt(i).toString(16)
  
  hashDataFunc = (data) ->
    shasum = crypto.createHash 'sha1'
    shasum.update data
    cb shasum.digest('hex').substr(3, 15)
    
  crypto.randomBytes 15, (err, buff) ->
    if err
      hashDataFunc key
    else
      for b in buff
        key += b.toString 16
      
      hashDataFunc key

