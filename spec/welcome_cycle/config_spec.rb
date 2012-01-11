require 'spec_helper'

describe WelcomeCycle::Config do

  class Organisation
  end

  subject { WelcomeCycle::Config.new }

  it 'has sensible defaults' do
    subject.base_class.should eq(Organisation)
    subject.welcome_cycle_start_date.should eq(:created_at)
    subject.welcome_cycle_end_date.should eq(:trial_ends_at)
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
