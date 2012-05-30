
require 'spec_helper'

describe Shoulda::Matchers::ActiveModel::PositiveErrorDescription do
  context 'with no errors' do
    it 'shows it it expected errors'
  end

  context 'with one error' do
    it 'returns a description indicating that it got the expected errors'
  end
end
