#!/usr/bin/env ruby

require 'optparse' # stdlib, cmd-line option parsing
require 'webrick'  # stdlib, http/https server
require 'yaml'     # stdlib, yaml processing
require 'json'     # stdlib, json processing

dir = File.dirname(File.realpath(__FILE__))
require "#{dir}/ncg-conf" # ncg conf processing
require "#{dir}/ncg-erb"  # ncg erb template processing

module NCG
  module Server
    @@option_defaults = {
      'conf-file'    => 'ncg.conf',
      'root-dir'     => './',
      'template-dir' => 'templates',
      'script-dir'   => 'scripts',
      'image-dir'    => 'images',
    }
    class ServerObject
      def initialize(o)
        @server = WEBrick::HTTPServer.new(:Port=>8000)
      end
      def start
        @server.start
      end
      def stop
        @server.shutdown
      end
      def cfg_handler(req,res)
      end
    end
    def self.new(o)
      return ServerObject.new(o)
    end
    def self.cli_app
      o = {}; d = @@option_defaults
      begin
        (op = OptionParser.new do |p|
          p.banner =
            "Summary:\n" +
            "  NGC server application.\n" +
            "Usage:\n" +
            "  #{File.basename($0)} [options]\n" +
            "Options:"
          p.summary_indent = '  '; p.summary_width = 24
          p.on("-c","--conf-file PATH",   "Defaults to '#{d['conf-file']}'.")    { |v| o['conf-file']    = v }
          p.on("-r","--root-dir PATH",    "Defaults to '#{d['root-dir']}'.")     { |v| o['root-dir']     = v }
          p.on("-t","--template-dir PATH","Defaults to '#{d['template-dir']}'.") { |v| o['template-dir'] = v }
          p.on("-s","--script-dir PATH",  "Defaults to '#{d['script-dir']}'.")   { |v| o['script-dir']   = v }
          p.on("-i","--image-dir PATH",   "Defaults to '#{d['image-dir']}'.")    { |v| o['image-dir']    = v }
          p.on("-h","Display this help message and exit.") { die(0,p.help) }
        end).parse!
      rescue
        die(-1,"Error: Invalid options specified.\n#{op.help}")
      end
      server = ServerObject.new(o)
      trap 'INT' do server.stop end
      server.start
    end
    def self.die(code,msg) STDERR.puts(msg); exit(code) end
  end
end
NCG::Server.cli_app if $0 == __FILE__
