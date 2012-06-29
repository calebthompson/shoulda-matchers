
require 'spec_helper'

describe Shoulda::Matchers::ActiveModel::PositiveErrorDescription do
  context 'with no errors' do
    it 'returns a description indicating that it expected at least one error' do
      described_class.new([], 'expected message').description.should == 'errors to include "expected message", but none matched'
    end
  end

  context 'with one error' do
    it 'returns a description indicating that it got the expected errors' do
      model = build_response
      described_class.new(.matches?(
    end
  end
end
