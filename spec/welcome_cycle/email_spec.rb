require 'spec_helper'

describe WelcomeCycle::Email do

  class WelcomeCycleMailer
  end

  subject do
    WelcomeCycle::Email.new("Test email") do
      days 1, 10, 25
      scope do
        where('created_at < ?', Date.today)
      end
    end
  end

  describe "#days" do
    it 'allows you to set the days the email should be sent on' do
      subject.days(1,2,3,4,5).should eq([1,2,3,4,5])
      subject.days(1,2,3).should eq([1,2,3])
    end
    it 'raises an argument error if passed day 0' do
      lambda { subject.days(1, 10, 0, 25).should raise_error(ArgumentError, "You cannot specify day zero in the welcome cycle") }
    end
    it 'raises an argument error if you do not pass in any days' do
      lambda { subject.days(1, 10, 0, 25).should raise_error(ArgumentError, "You must specify at least one day in the welcome cycle that you'd like this email to be sent on") }
    end
  end

  describe '#scope' do
    it 'allows you to set a further scope for the recipients' do
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
    before { WelcomeCycle.configure { |c| c.base_class = Organisation } }
    context "with no days set" do
      let(:email) { WelcomeCycle::Email.new("Test email") { } }
      it 'returns an empty array' do
        email.recipients.should eq([])
      end
    end
    context "with the email set to go out on day 5 and 10 of the welcome cycle" do
      let(:email) { WelcomeCycle::Email.new("Test email") { days(5, 10) } }
      it 'queries the base class for all the records that started the welcome cycle 5 or 10 days ago' do
        Organisation.should_receive(:where).with(["date(created_at) = ? OR date(created_at) = ?", Date.today - 5, Date.today - 10]).and_return(mock_orgs)
        mock_orgs.should_receive(:all)
        email.recipients
      end
    end
    context "with the email set to go out 9 and 3 days before welcome cycle ends" do
      let(:email) { WelcomeCycle::Email.new("Test email") { days(-9, -3) } }
      it 'queries the base class for all the records that are 5/3 days away from ending the welcome cycle' do
        Organisation.should_receive(:where).with(["date(trial_ends_at) = ? OR date(trial_ends_at) = ?", Date.today + 9, Date.today + 3]).and_return(mock_orgs)
        mock_orgs.should_receive(:all)
        email.recipients
      end
    end
    context "with extra Arel scope set" do
      let(:email) do
        WelcomeCycle::Email.new("Test email") do
          days(3, -5)
          scope do
            active.where('1=1')
          end
        end
      end
      it "adds the extra scope to the query on the base_class" do
        mock_active_orgs = mock 'mock active orgs'
        Organisation.should_receive(:where).with(["date(created_at) = ? OR date(trial_ends_at) = ?", Date.today - 3, Date.today + 5]).and_return(mock_orgs)
        mock_orgs.should_receive(:active).and_return(mock_active_orgs)
        mock_active_orgs.should_receive(:where).with('1=1')
        email.recipients
      end
    end
  end

  describe "#deliver" do
    let(:mock_email) { mock 'email' }
    let(:mock_recipient) { mock 'recipient' }

    context 'without DelayedJob' do
      it 'calls deliver on the mailer template for this email passing in the recipient' do
        WelcomeCycleMailer.should_receive(:test_email).with(mock_recipient).and_return(mock_email)
        mock_email.should_receive(:deliver)
        subject.deliver(mock_recipient)
      end
    end
    context 'with DelayedJob' do
      it 'queues the email for delivery' do
        pending 'Need to research the specific DJ method chaining requirements'
      end
    end
  end

end
