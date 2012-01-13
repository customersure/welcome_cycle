require 'spec_helper'

describe WelcomeCycle::Email do

  class WelcomeCycleMailer
  end

  class Subscription
    def self.table_name
      'organisations'
    end
  end

  before(:each) do
    WelcomeCycle.configure do |c|
      c.base_class = Subscription
      c.welcome_cycle_start_date = :trial_started_at
      c.welcome_cycle_end_date = :trial_ends_at
    end
  end

  subject do
    WelcomeCycle::Email.new("Test email") do
      days_into_cycle 1, 10, 25
      scope do
        where('created_at < ?', Date.today)
      end
    end
  end

  describe "#initialize" do
    it 'raises an error if you do not specify any days' do
      lambda { WelcomeCycle::Email.new("Test email") {} }.should raise_error("You must specify at least one day to send this email by specifying 'days_into_cycle' and/or 'days_offset_from_cycle_end'")
    end
    it 'adds itself into the register' do
      lambda {
        WelcomeCycle::Email.new("Test email") { days_into_cycle 1 }
      }.should change(WelcomeCycle::EmailRegister.instance.emails, :size).by(1)
    end
  end

  describe "#days_into_cycle" do
    it 'allows you to set the days the email should be sent after the cycle begins' do
      subject.days_into_cycle(1,2,3,4,5).should eq([1,2,3,4,5])
      subject.days_into_cycle(1,2,3).should eq([1,2,3])
    end
    it 'raises an ArgumentError if passed day 0' do
      lambda { subject.days_into_cycle(1, 10, 0, 25) }.should raise_error(ArgumentError, "'days_into_cycle' can only contain positive numbers")
    end
    it 'raises an ArgumentError if passed day a negative day' do
      lambda { subject.days_into_cycle(1, -4, 25) }.should raise_error(ArgumentError, "'days_into_cycle' can only contain positive numbers")
    end
    context 'with no welcome_start_date set' do
      before { WelcomeCycle.config.welcome_cycle_start_date = nil }
      it 'raises an error' do
        lambda { subject.days_into_cycle(1) }.should raise_error("When specifying 'days_into_cycle' you must set the 'welcome_cycle_start_date'. See README config section")
      end
    end
  end

  describe "#days_offset_from_cycle_end" do
    it 'allows you to set the days the email should be sent, offset from the cycle beginning' do
      subject.days_offset_from_cycle_end(-1,0,1).should eq([-1,0,1])
    end
    context 'with no welcome_cycle_end_date set' do
      before { WelcomeCycle.config.welcome_cycle_end_date = nil }
      it 'raises an error' do
        lambda { subject.days_offset_from_cycle_end(1, -4, 25)}.should raise_error("When specifying 'days_offset_from_cycle_end' you must set the 'welcome_cycle_end_date' config section")
      end
    end
  end

  describe '#scope' do
    it 'allows you to set a further scope for the email recipients' do
      subject.scope do
        where('1=1')
      end.should be_a(Proc)
    end
  end

  describe '#send_to_recipients!' do
    let(:r1) { mock 'mock recipient 1' }
    let(:r2) { mock 'mock recipient 2' }
    let(:r3) { mock 'mock recipient 3' }

    before { subject.stub(:recipients).and_return([r1, r2, r3]) }

    it 'delivers the email to each recipient' do
      subject.should_receive(:deliver).with(r1)
      subject.should_receive(:deliver).with(r2)
      subject.should_receive(:deliver).with(r3)
      subject.send_to_recipients!
    end
  end

  describe "#recipients" do
    let(:mock_orgs) { mock "Orgs" }
    context "with the email set to go out on day 5 and 10 of the welcome cycle" do
      let(:email) { WelcomeCycle::Email.new("Test email") { days_into_cycle(5, 10) } }
      it 'queries the base class for all the records that started the welcome cycle 5 or 10 days ago' do
        Subscription.should_receive(:where).with(["date(`organisations`.`trial_started_at`) = ? OR date(`organisations`.`trial_started_at`) = ?", Date.today - 5, Date.today - 10]).and_return(mock_orgs)
        mock_orgs.should_receive(:all)
        email.recipients
      end
    end
    context "with the email set to go out 9 and 3 days before the welcome cycle ends" do
      let(:email) { WelcomeCycle::Email.new("Test email") { days_offset_from_cycle_end(-9, -3) } }
      it 'queries the base class for all the records that are 5/3 days away from ending the welcome cycle' do
        Subscription.should_receive(:where).with(["date(`organisations`.`trial_ends_at`) = ? OR date(`organisations`.`trial_ends_at`) = ?", Date.today + 9, Date.today + 3]).and_return(mock_orgs)
        mock_orgs.should_receive(:all)
        email.recipients
      end
    end
    context "with an extra Arel scope set" do
      let(:email) do
        WelcomeCycle::Email.new("Test email") do
          days_into_cycle(3)
          days_offset_from_cycle_end(-5)
          scope do
            active.where('1=1')
          end
        end
      end
      it "adds the extra scope to the date based query on the base_class" do
        mock_active_orgs = mock 'mock active orgs'
        Subscription.should_receive(:where).with(["date(`organisations`.`trial_started_at`) = ? OR date(`organisations`.`trial_ends_at`) = ?", Date.today - 3, Date.today + 5]).and_return(mock_orgs)
        mock_orgs.should_receive(:active).and_return(mock_active_orgs)
        mock_active_orgs.should_receive(:where).with('1=1')
        email.recipients
      end
      context 'with a non-default configuration for the date fields' do
        before do
          WelcomeCycle.configure do |c|
            c.welcome_cycle_start_date = :my_test_start_date
            c.welcome_cycle_end_date = :my_test_end_date
          end
        end
        it "queries based on the configured field names" do
          mock_active_orgs = mock 'mock active orgs'
          Subscription.should_receive(:where).with(["date(`organisations`.`my_test_start_date`) = ? OR date(`organisations`.`my_test_end_date`) = ?", Date.today - 3, Date.today + 5]).and_return(mock_orgs)
          mock_orgs.should_receive(:active).and_return(mock_active_orgs)
          mock_active_orgs.should_receive(:where).with('1=1')
          email.recipients
        end
      end
    end
  end

  describe "#deliver" do
    let(:mock_email) { mock 'email' }
    let(:mock_recipient) { mock 'recipient' }

    context 'without DelayedJob in the project' do
      it 'calls deliver on the mailer template for this email passing in the recipient' do
        WelcomeCycleMailer.should_receive(:test_email).with(mock_recipient).and_return(mock_email)
        mock_email.should_receive(:deliver)
        subject.deliver(mock_recipient)
      end
    end
    context 'with DelayedJob in place' do
      it 'queues the email for delivery' do
        pending 'Need to research the specific DJ method chaining requirements'
      end
    end
  end

end
