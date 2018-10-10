module Api
  module V1
    class SpotsController < ApiController
      def create
        @spot = current_user.spots.create!(spot_params)
      end

      def index
        @spots = current_user.spots
      end

      def destroy
        current_user.spots.destroy(params[:id])
      end

      private

      def spot_params
        params.require(:spot).permit(:title, :latitude, :longitude, :radius, :topic_id)
      end
    end
  end
end
