class StarshipsController < ApplicationController
		include Metodos

  def show
	url = request.original_url
	@id = get_id(url)

	query = <<-GRAPHQL
	query($id: ID) {
		starship(id: $id){
		  id
		  name
		  model
		  manufacturers
		  costInCredits
		  length
		  maxAtmospheringSpeed
		  crew
		  passengers
		  cargoCapacity
		  consumables
		  hyperdriveRating
		  MGLT
		  starshipClass
		  pilotConnection { edges { node { ...characterFragment }}}
		  filmConnection { edges { node { ...filmFragment }}}
	  } }
	  fragment characterFragment on Person {
		id
	  name }
	  fragment filmFragment on Film {
		id
	  title }
	GRAPHQL
	variables = { "id": @id }
	response = @@client.query(query, variables)

	@starship = response.data.starship

	@characters = []
	for pilot in @starship.pilot_connection.edges
		@characters << pilot.node
	end

	@films = []
	for film in @starship.film_connection.edges
		@films << film.node
	end

  end
end
