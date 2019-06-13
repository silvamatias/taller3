class CharactersController < ApplicationController
		include Metodos

  def show
	url = request.original_url
	@id = get_id(url)

	query = <<-GRAPHQL
	query($id: ID) {
		person(id: $id ) {
			  id
			  name
			  birthYear
			  eyeColor
			  gender
			  hairColor
			  height
			  mass
			  skinColor
			  homeworld {
		  name
		  id }
			  species { name }
			  filmConnection { edges { node { ...filmFragment }}}
			  starshipConnection { edges { node { ...starshipFragment }}}
		  } }
		  fragment starshipFragment on Starship {
			id
		  name }
		  fragment filmFragment on Film {
			id
		  title
		  }
	GRAPHQL
	variables = { "id": @id }
	response = @@client.query(query, variables)

	@character = response.data.person

	@starships = []
	for starship in @character.starship_connection.edges
		@starships << starship.node
	end

	@films = []
	for film in @character.film_connection.edges
		@films << film.node
	end

	@planets = @character.homeworld

  end

end
