require 'spec_helper'

describe Shoulda::Matchers::ActiveRecord::ValidateAssociatedMatcher do
  before { 
    @matcher = validate_associated(:child)
  }

  it "should accept a validated association" do
    define_model :parent do
      has_one :child
      validates_associated :child
    end
    define_model :child, parent_id: :integer do
      belongs_to :parent
    end
    Parent.should @matcher
  end

  it "should reject an unvalidated association" do
    define_model :parent do
      has_one :child
    end
    define_model :child, parent_id: :integer do
      belongs_to :parent
    end
    Parent.should_not @matcher
  end

  it "should reject a nonexistent association" do
    define_model :parent
    Parent.should_not @matcher
  end
end
