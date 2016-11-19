#!/usr/bin/env ruby

require 'optparse' # stdlib, cmd-line option parsing
require 'yaml'     # stdlib, yaml processing
require 'json'     # stdlib, json processing

dir = File.dirname(File.realpath(__FILE__))
require "#{dir}/ncg-server" # ncg server app

module NCG
  module Client
    @@option_defaults = {
      'root-dir'     => './',
      'template-dir' => 'templates',
      'script-dir'   => 'scripts',
      'image-dir'    => 'images',
    }
    def self.cli_app
      begin
        (op = OptionParser.new do |p|
          p.banner =
            "Summary:\n" +
            "  NCG client application.\n" +
            "Usage:\n" +
            "  #{File.basename($0)} [options] host [host...]\n" +
            "Options:"
          p.summary_indent = '  '; p.summary_width = 4
          p.on("-h","Display this help message and exit.") { die(0,p.help) }
        end).parse!
      rescue
        die(-1,"Error: Invalid options specified.\n#{op.help}")
      end
      server = NCG::Server.new(o)
      server.start
    end
    def self.die(code,msg) STDERR.puts(msg); exit(code) end
  end
end
NCG::Client.cli_app if $0 == __FILE__
