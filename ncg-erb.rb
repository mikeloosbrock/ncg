#!/usr/bin/env ruby

require 'optparse' # stdlib, cmd-line option parsing
require 'yaml'     # stdlib, yaml processing
require 'json'     # stdlib, json processing

module NCG
  module Conf
    class ConfObject
    end
    def self.cli_app
      begin
        (op = OptionParser.new do |p|
          p.banner =
            "Summary:\n" +
            "  Utility for verifying and troubleshooting NCG conf files."
            "Usage:\n" +
            "  #{File.basename($0)} [options]\n" +
            "Options:"
          p.summary_indent = '  '; p.summary_width = 4
          p.on("-h","Display this help message and exit.") { die(0,p.help) }
        end).parse!
      rescue
        die(-1,"Error: Invalid options specified.\n#{op.help}")
      end
    end
    def die(code,msg) STDERR.puts(msg); exit(code) end
  end
end
NCG::Conf.cli_app if $0 == __FILE__
