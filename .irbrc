$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'free_mart'

def reload
  Object.send :remove_const, :FreeMart
  load File.join(File.dirname(__FILE__), 'lib', 'free_mart.rb')
end

