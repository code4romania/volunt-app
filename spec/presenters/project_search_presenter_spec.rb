require 'rails_helper'

RSpec.describe ProjectSearchPresenter, type: :presenter do
  let(:presenter) { ProjectSearchPresenter.new }

  it 'checks if it is blank' do
    expect(presenter).to be_blank
    presenter.name = 'caisă'
    expect(presenter).to_not be_blank
  end
end
