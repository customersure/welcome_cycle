require 'spec_helper'

describe WelcomeCycle do

  describe "::configure" do
    before do
      WelcomeCycle.configure do |c|
        c.base_class = String
      end
    end

    it 'sets a module attribute :config to a new WelcomeCycle::Config object and sets the attributes specified in the block given' do
      WelcomeCycle.config.should be_a(WelcomeCycle::Config)
      WelcomeCycle.config.base_class.should eq(String)
    end

    describe 'calling config more than once' do
      before do
        WelcomeCycle.configure do |c|
          c.base_class = String
        end
      end
      it 'does not create a new WelcomeCycle::Config object' do
        WelcomeCycle::Config.should_receive(:new).never
        WelcomeCycle.configure do |c|
          c.base_class = Fixnum
        end
      end
    end
  end

end