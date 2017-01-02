require 'spec_helper'
require 'open3'

RSpec.describe 'Integration: Help output' do
  let(:expected_help) do
    <<-EOF.undent
      Usage: rubocopfmt [options] [path ...]

      Options:
          -d, --diff                       Display diffs instead of rewriting files.
          -l, --list                       List files whose formatting is incorrect.
          -w, --write                      Write result to (source) file instead of STDOUT.

          -v, --version                    Show version.
          -h, --help                       Show this message.
    EOF
  end

  it 'prints help information when given -h flag' do
    stdout, status = Open3.capture2("#{fmt_bin} -h")

    expect(status).to eq(0)
    expect(stdout).to eq(expected_help)
  end

  it 'prints help information when given --help flag' do
    stdout, status = Open3.capture2("#{fmt_bin} --help")

    expect(status).to eq(0)
    expect(stdout).to eq(expected_help)
  end
end
