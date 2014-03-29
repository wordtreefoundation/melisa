require_relative "spec_helper"

class ConfigHarness
  include Melisa::BaseConfigFlags
end

describe Melisa::BaseConfigFlags do
  let(:config) { ConfigHarness.new }

  context "config_flags" do
    it "builds an integer" do
      config.config_flags.should be_a(Integer)
    end

    it "accepts a hash of options" do
      config.config_flags(:binary => false).should == 135683
      config.config_flags(:binary => true).should == 139779
    end
  end

  context "binary_flag" do
    it "accepts boolean" do
      config.binary_flag(true).should == Marisa::BINARY_TAIL
      config.binary_flag(false).should == Marisa::TEXT_TAIL
      lambda { config.binary_flag(nil) }.should raise_error(ArgumentError)
    end
  end

  context "valid_num_tries" do
    it "must be >= MIN" do
      min = Marisa::MIN_NUM_TRIES
      lambda { config.valid_num_tries(min-1) }.should raise_error
      lambda { config.valid_num_tries(min) }.should_not raise_error
    end

    it "must be <= MAX" do
      max = Marisa::MAX_NUM_TRIES
      lambda { config.valid_num_tries(max+1) }.should raise_error
      lambda { config.valid_num_tries(max) }.should_not raise_error
    end

    it "accepts values between MIN and MAX" do
      value = Marisa::MIN_NUM_TRIES+1
      config.valid_num_tries(value).should == value
    end

    it "accepts special :default symbol" do
      config.valid_num_tries(:default).should == Marisa::DEFAULT_NUM_TRIES
    end
  end

  context "lookup_cache_size" do
    it "must be a valid size" do
      lambda { config.lookup_cache_size(:tiny) }.should_not raise_error
      lambda { config.lookup_cache_size(:eentsy_weentsy) }.should raise_error
    end

    it "returns an integer" do
      config.lookup_cache_size(:tiny).should be_a(Integer)
    end
  end

  context "valid_node_order" do
    it "must be a valid node order" do
      lambda { config.valid_node_order(:weight) }.should_not raise_error
      lambda { config.valid_node_order(:upside_down) }.should raise_error
    end

    it "returns an integer" do
      config.valid_node_order(:weight).should be_a(Integer)
    end
  end
end