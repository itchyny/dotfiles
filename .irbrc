require 'fileutils'

IRB.conf[:SAVE_HISTORY] ||= 10000

history_file = File.join(ENV["XDG_DATA_HOME"], "irb", "history")
FileUtils.mkdir_p File.dirname(history_file)
IRB.conf[:HISTORY_FILE] ||= history_file
