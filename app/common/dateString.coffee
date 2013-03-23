class DateString
  constructor: (year,month, date, hour, minute, second) ->
    @__date = new Date year, month, date, hour, minute, second
  
  @fromString: (dateString) ->
    return null unless dateString
    dateElements = dateString.split '.'
    if dateElements.length > 5
      return new DateString parseInt(dateElements[0]), parseInt(dateElements[1]), parseInt(dateElements[2]), parseInt(dateElements[3]), parseInt(dateElements[4]), parseInt(dateElements[5])
    else
      return null

  @fromDate: (date) ->
     return new DateString date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds()
     
  toString: ->
    return @__date.getFullYear() + '.' + @__date.getMonth() + '.' + @__date.getDate() + '.' + @__date.getHours() + '.' + @__date.getMinutes() + '.' + @__date.getSeconds()

  toDate: ->
    return @__date
    
module.exports = DateString