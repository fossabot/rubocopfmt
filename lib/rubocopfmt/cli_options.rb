require 'trollop'
require 'rubocop'

require 'rubocopfmt/core_ext/string'
require 'rubocopfmt/options'
require 'rubocopfmt/version'

module RuboCopFMT
  class CLIOptions
    class << self
      def parse(args)
        args = args.clone

        opts = parse_args(args)
        opts[:paths] = args
        opts[:diff] = true if opts[:diff_format] && !opts[:diff]

        validate_diff_format(opts)
        validate_paths(opts)

        opts
      end

      private

      def parse_args(args)
        Trollop.options(args) do
          banner <<-EOF.undent
            Usage: rubocopfmt [options] [path ...]

            Reads from STDIN if no path is given.

            Options:
          EOF

          version "rubocopfmt #{RuboCopFMT::VERSION}" \
                  " (rubocop #{::RuboCop::Version::STRING})"

          opt :diff, 'Display diffs instead of rewriting files'
          opt :list, 'List files whose formatting is incorrect'
          opt :write, 'Write result to (source) file instead of STDOUT'
          opt :src_dir, 'Operate as if code resides in specified directory',
              short: 'S', type: :string
          opt :diff_format, 'Display diffs using format: unified, rcs, context',
              short: 'D', type: :string
          banner ''

          conflicts :diff, :list, :write
          conflicts :diff_format, :list, :write
        end
      end

      def validate_paths(opts)
        [:list, :write].each do |opt|
          if opts[opt] && opts[:paths].empty?
            Trollop.die(opt, 'requires one or more paths to be specified')
          end
        end
      end

      def validate_diff_format(opts)
        return if opts[:diff_format].nil? \
                  || Diff.valid_format?(opts[:diff_format])

        Trollop.die(:diff_format,
                    "does not support \"#{opts[:diff_format]}\" format")
      end
    end
  end
end