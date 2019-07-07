# frozen_string_literal: true

require_relative '../spec/support/fake_stream'

RSpec.describe Nmax do
  it "has a version number" do
    expect(Nmax::VERSION).not_to be nil
  end

  describe '#perform' do
    let(:stream) { FakeStream.new }
    let(:result_limit) { 100 }
    let(:line_limit) { 1000 }
    let(:expected_result) { [0, 3, 5, 9, 10, 122] }

    subject(:result) { described_class.perform(stream, result_limit, line_limit) }

    it { is_expected.to eq expected_result }

    context 'limit results' do
      let(:line_limit) { 3 }

      it { expect(result.size).to eq limit }
    end

    context 'limit line length' do
      let(:line_limit) { 3 }
      let(:limited_expected_result) do
        expected_result.reject { |i| i.to_s.length > line_limit }
      end

      it { is_expected.to eq limited_expected_result }
    end
  end
end
