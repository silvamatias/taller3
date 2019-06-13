class PlanetsController < ApplicationController
		include Metodos

  def show
	url = request.original_url
	@id = get_id(url)

	query = <<-GRAPHQL
	query($id: ID) {
		planet(id: $id){
		name
		  diameter
		  rotationPeriod
		  orbitalPeriod
		  gravity
		  population
		  climates
		  terrains
		  surfaceWater
		  residentConnection { edges {node {...characterFragment}}}
		  filmConnection { edges {node {...filmFragment}}}
		} } 
	  fragment characterFragment on Person {
		name
		id
	  }
	  fragment filmFragment on Film {
		title
		  id 
	  }
	GRAPHQL
	variables = { "id": @id }
	response = @@client.query(query, variables)

	@planet = response.data.planet

	@characters = []
	for character in @planet.resident_connection.edges
		@characters << character.node
	end

	@films = []
	for film in @planet.film_connection.edges
		@films << film.node
	end

  end

end
