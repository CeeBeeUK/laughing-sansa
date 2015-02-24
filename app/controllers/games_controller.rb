class GameController < ApplicationController
	def score
		@participating_country = ParticipatingCountry.find(params[:id])
	end
end
