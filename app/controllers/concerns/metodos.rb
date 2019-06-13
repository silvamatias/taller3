module Metodos
	extend ActiveSupport::Concern

	def get_id(url)
		id = url.split("/")[-1]
		return id
	end 

end 










