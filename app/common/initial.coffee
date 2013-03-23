global.environment = 
  name : process.env.NODE_ENV or 'development'
  on : (envName, trueFn, falseFn) -> 
    if envName == @name
      trueFn()
    else
      falseFn() if falseFn
