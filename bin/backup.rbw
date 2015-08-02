#!/usr/bin/ruby

# Written by Daniel Frank

# Initialize the options
$options = Hash.new
$options[:logfile] = nil
$options[:threads] = 5
$options[:filecopies] = 1
$options[:source] = nil
$options[:destination] = nil

# Parse the command line
require 'optparse'
optparse = OptionParser.new { |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)} [options]"
  opts.on('-s', '--source DIR', 'Defines which directory to backup') { |v|
    $options[:source] = v
  }
  opts.on('-d', '--destination DIR', 'Backup the data to a subdirectory of DIR') { |v|
    $options[:destination] = v
  }
  opts.on('-x', '--exclude FILE', 'Exclude all files matching lines in FILE (shell globbing)') { |v|
    x = File.read(v).split("\n").collect { |line|
      if line.start_with?('#')
        nil
      elsif line == ""
        nil
      end
      line
    }
    $options[:excludes] = x
  }
  opts.on('-?', '--help', 'List help') {
    puts opts
    exit
  }
}
optparse.parse!
puts "test"
# Resolve paths
#$options[:source] = File.absolute_path($options[:source]) if $options[:source]
#$options[:destination] = File.absolute_path($options[:destination]) if $options[:destination]


# Load the classes
$LOAD_PATH << File.absolute_path(File.dirname(__FILE__) + "/..")
require 'lib/winbackup/backup'
require 'lib/winbackup/b_dir'
require 'lib/winbackup/b_file'

backup = Backup.new($options[:source], $options[:destination], $options[:excludes])
backup.prepare
backup.backup!
