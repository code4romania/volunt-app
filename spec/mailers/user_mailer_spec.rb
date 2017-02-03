require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do

  let!(:volunteer) { create(:volunteer) }
  let!(:profile)   { Profile.find_by_email(volunteer.email) }

  describe 'primary email reset_password' do
    let!(:mail) { described_class.reset_password(volunteer).deliver_now }

    it 'sends reset password' do
      expect(mail.subject).to eq('Reseteaza parola Voluntari Code4Romania')
    end
    it 'sends to primary email' do
      expect(mail.to).to eq([volunteer.email])
    end
  end

  describe 'secondary email reset_password' do
    email = "secondary@example.com"
    let!(:mail) { described_class.reset_password(volunteer, email).deliver_now }
    it 'sends to secondary email' do
      expect(mail.to).to eq([email])
    end
  end

end
