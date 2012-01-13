require 'spec_helper'

describe WelcomeCycle::Driver do

  describe "::run" do
    let(:email1) { mock 'email 1' }
    let(:email2) { mock 'email 1' }

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

  end

end