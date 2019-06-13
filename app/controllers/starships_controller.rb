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

	#res = HTTParty.get('https://swapi.co/api/starships/'+@id.to_s, :headers => {'Content-Type' => 'application/json'}).body
	#@starship = JSON.parse(res)

	#char_urls = @starship["pilots"]
	#@characters_names = request_urls(char_urls, "name")

	#films_urls = @starship["films"]
	#@films_titles = request_urls(films_urls, "title")
  end
end
