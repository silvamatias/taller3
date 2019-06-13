class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  @@client = Graphlient::Client.new('https://swapi-graphql-integracion-t3.herokuapp.com/')
end
