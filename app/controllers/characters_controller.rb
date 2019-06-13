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
	#for planet in @character.homeworld
	#	@planets << planet
	#end

	#res = HTTParty.get('https://swapi.co/api/people/'+@id.to_s, :headers => {'Content-Type' => 'application/json'}).body
	#@character = JSON.parse(res)

	#planets_urls = @character["homeworld"]
	#@planets_names = request_urls_single(planets_urls, "name")

	#starships_urls = @character["starships"]
	#@starships_names = request_urls(starships_urls, "name")

	#films_urls = @character["films"]
	#@films_titles = request_urls(films_urls, "title")
  end

end
