require 'spec_helper'

describe WelcomeCycle::Driver do

  describe "::run" do
    let(:email1) { mock('email 1').as_null_object }
    let(:email2) { mock('email 1').as_null_object }

    context "when WelcomeCycle has not been configured" do
      it 'raises an error telling you to configure it' do
        lambda { WelcomeCycle::Driver.run }.should raise_error('WelcomeCycle is not configured! See the README config section for help.')
      end
    end

    context "when no base_class is configured" do
      before { WelcomeCycle.configure {} }
      it 'raises an error telling you to set the base class' do
        lambda { WelcomeCycle::Driver.run }.should raise_error("You must set the 'base_class' option. See README config section.")
      end
    end

    context "when configured with a base class" do
      before do
        WelcomeCycle.configure { |c| c.base_class = mock('class') }
        WelcomeCycle::EmailRegister.instance << email1
        WelcomeCycle::EmailRegister.instance << email2
      end

      it 'calls #send_to_recipients! on each email in the register' do
        email1.should_receive(:send_to_recipients!)
        email2.should_receive(:send_to_recipients!)
        WelcomeCycle::Driver.run
      end
    end

    describe 'callbacks' do
      it 'calls the before_run callback if one is set' do
        WelcomeCycle.configure { |c| c.before {} }
        WelcomeCycle.config.before_run.should_receive(:call)
        WelcomeCycle::Driver.run
      end

      it 'calls the after_run callback if one is set' do
        WelcomeCycle.configure { |c| c.after {} }
        WelcomeCycle.config.after_run.should_receive(:call)
        WelcomeCycle::Driver.run
      end
    end
  end
end