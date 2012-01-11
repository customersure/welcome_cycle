require 'spec_helper'

describe WelcomeCycle::Driver do

  describe "::run" do
    let(:email1) { mock 'email 1' }
    let(:email2) { mock 'email 1' }

    before do
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