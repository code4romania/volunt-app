require 'rails_helper'

RSpec.describe ProjectsController, type: :routing do
  describe 'routing' do
    it 'routes to #search' do
      expect(post: '/projects/search').to route_to('projects#search')
    end
  end
end
