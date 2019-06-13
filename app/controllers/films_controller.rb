require 'httparty'
require 'pp'
require 'json'



class FilmsController < ApplicationController
	include Metodos

  def index
	@films = []

	response = @@client.query <<-GRAPHQL
		query {
			allFilms{
		edges { node {
				...filmFragment
				}
		} }
		}
		fragment filmFragment on Film {
			id 
		episodeID
				title
			releaseDate
			director
			producers
		}
	GRAPHQL

	for film in response.data.all_films.edges
		@films << film.node
	end
	
  end

  def show
	url = request.original_url
	@id = get_id(url)


	query = <<-GRAPHQL
		query($id: ID) {
			film(id: $id ) {
			  id
			  episodeID
			  title
			  openingCrawl
			  director
			  producers
			  releaseDate
			  starshipConnection { edges { node { ...starshipFragment }}}
			  characterConnection { edges { node { ...characterFragment }}}
			  planetConnection { edges { node { ...planetFragment }}}
		  } }
		  fragment starshipFragment on Starship {
			id
			name
			model
			costInCredits
		  }
		  fragment characterFragment on Person {
			name
			id
			species { name }
		  }
		  fragment planetFragment on Planet {
			name
		  id }
	GRAPHQL
	variables = { "id": @id }
	response2 = @@client.query(query, variables)

	@film = response2.data.film

	@starships = []
	for starship in @film.starship_connection.edges
		@starships << starship.node
	end

	@characters = []
	for character in @film.character_connection.edges
		@characters << character.node
	end

	@planets = []
	for planet in @film.planet_connection.edges
		@planets << planet.node
	end

  end


end

