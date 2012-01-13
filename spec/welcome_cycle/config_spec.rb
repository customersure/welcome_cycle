require 'spec_helper'

describe WelcomeCycle::Config do

  subject { WelcomeCycle::Config.new }

  describe "new config object" do
    it 'has sensible defaults for the welcome cycle start and end dates' do
      subject.welcome_cycle_start_date.should eq(:trial_stared_at)
      subject.welcome_cycle_end_date.should eq(:trial_ends_at)
    end
  end

  describe "attributes" do
    it 'allows you to set :base_class' do
      subject.base_class = 'SomeClass'
      subject.base_class.should eq('SomeClass')
    end
    it 'allows you to set :welcome_cycle_start_date' do
      subject.welcome_cycle_start_date = :signed_up_at
      subject.welcome_cycle_start_date.should eq(:signed_up_at)
    end
    it 'allows you to set :welcome_cycle_end_date' do
      subject.welcome_cycle_end_date = :close_at
      subject.welcome_cycle_end_date.should eq(:close_at)
    end
  end

end
