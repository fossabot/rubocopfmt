require 'diffy'

require 'rubocopfmt/errors'
require 'rubocopfmt/options_parser'
require 'rubocopfmt/source'

module RuboCopFMT
  class CLI
    def self.run(args = ARGV)
      new(args).run
    end

    attr_reader :options

    def initialize(args)
      @options = OptionsParser.parse(args)
    end

    def run
      if @options.list
        print_corrected_list
      elsif @options.diff
        print_diff_of_corrections
      elsif @options.write
        write_corrected_source
      else
        print_corrected_source
      end

      0
    end

    private

    def auto_correct_sources
      sources.map(&:auto_correct)
    end

    def require_real_files(flag)
      return unless @options.paths.empty?

      $stderr.puts "ERROR: To use #{flag} you must specify one or more files"
      exit 1
    end

    def print_corrected_list
      require_real_files('--list')
      auto_correct_sources

      sources.each { |c| puts c.path if c.corrected? }
    end

    def print_diff_of_corrections
      auto_correct_sources

      sources.each do |source|
        next unless source.corrected?
        puts "diff #{source.path} rubocopfmt/#{source.path}" if source.path
        puts diff_source(source)
      end
    end

    def write_corrected_source
      require_real_files('--write')
      auto_correct_sources

      sources.each do |source|
        File.write(source.path, source.output) if source.corrected?
      end
    end

    def print_corrected_source
      auto_correct_sources

      sources.each { |source| print source.output }
    end

    def sources
      return @sources if @sources

      if options.paths.empty?
        @sources = [new_source_from_stdin(options.stdin_file)]
      else
        @sources = options.paths.map do |path|
          new_source_from_file(path)
        end
      end
    end

    def diff_source(source)
      diff = Diffy::Diff.new(
        source.input, source.output,
        include_diff_info: true,
        diff: '-U 3'
      )

      diff.to_s(:text)
    end

    def new_source_from_stdin(path = nil)
      Source.new($stdin.binmode.read, path)
    end

    def new_source_from_file(path)
      raise FileNotFound, "File not found: #{path}" unless File.exist?(path)

      source = File.read(path, mode: 'rb')
      Source.new(source, path)
    end
  end
end
