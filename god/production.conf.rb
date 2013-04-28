
MINION_HOME = File.dirname File.dirname(__FILE__) # go to ..
LOGS_FOLDER = File.join MINION_HOME, 'logs'
MAIN_EXECUTION_FILE = File.join MINION_HOME, 'main.coffee'

God.watch do |w|
  w.env = { 'NODE_ENV' => 'production' }
  w.name = "minion-main"
  w.log = File.join(LOGS_FOLDER, "main.god.log")
  w.start = "coffee #{MAIN_EXECUTION_FILE}"
  
  w.keepalive
end

