require "rails_helper"

RSpec.describe ActivityMailer, type: :mailer do

  let!(:volunteer)  { create(:volunteer) }
  let!(:profile)    { Profile.find_by_email(volunteer.email) }
  let!(:date)       { profile.created_at.to_date }

  def send_report
    described_class.daily(date).deliver_now
  end
  
  describe 'Daily activity' do

    it "sends an email" do
      expect { send_report }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    let!(:mail) { send_report }

    it 'sends to configured daily_to' do
      expect(mail.to).to eq([Rails.configuration.x.email.daily_to])
    end

    it 'include new profile' do
      # Mailer Test Case does not gives access to `assigns`
      # Body is encoded 'quoted-printable'
      # Array.pack('M') encodes 'quoted-printable'
      # The terminal =\n is from `pack` and needs to be removed
      # enjoy!
      expect(mail.body.encoded).to include([profile.full_name].pack('M').gsub(/=\n/,''))
    end
  
  end
end
