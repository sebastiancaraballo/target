module Api
  module V1
    module User
      class MatchesController < ApiController
        def index
          @matches = current_user.matches
        end
      end
    end
  end
end
