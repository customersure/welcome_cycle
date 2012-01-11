require 'spec_helper'

describe WelcomeCycle::EmailRegister do

  subject { WelcomeCycle::EmailRegister.instance }

  after(:each) { WelcomeCycle::EmailRegister.instance.emails = [] }

  describe "attributes" do
    it 'allows setting/getting :emails' do
      subject.emails = [1, 2, 3]
      subject.emails.should eq([1, 2, 3])
    end
  end


  describe "adding emails into the register" do
    let(:email_register) { WelcomeCycle::EmailRegister.instance }
    it 'stores them in an array' do
      subject << "email1"
      subject << "email2"
      subject << "email3"
      subject.emails.should eq(['email1', 'email2', 'email3'])
    end
  end

  describe "each" do
    let(:email1) { mock('email1') }
    let(:email2) { mock('email2') }
    let(:email3) { mock('email2') }

    it 'yields the given block for each email in the register' do
      subject << email1
      subject << email2
      subject << email3
      email1.should_receive(:some_method)
      email2.should_receive(:some_method)
      email3.should_receive(:some_method)
      subject.emails.each { |e| e.some_method }
    end
  end

end