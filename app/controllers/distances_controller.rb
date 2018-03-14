class DistancesController < ApplicationController
	def add
		req = request.raw_post
		data = req.split(' ')
		ret = validate_entry(data);
		
		#render plain: ret[:status]
		
		if !ret[:status].eql? 'ok' then
			distancia = data[2]
			#render plain: (distancia.is_a? Numeric ? 'num': 'str')
			status = 'erro'
			mensagem = ret[:mensagem]
		else
			inclusao = register_distance(data);
			if (inclusao===true) then

				status = 'ok'
				mensagem = 'Success'
			else 
				status = 'erro'
				mensagem = inclusao
			end
		end
		render json: {status: status, mensagem: mensagem}
	end;

	private def validate_entry(data)
		if data.length != 3 then
			status = 'erro'
			mensagem = 'Invalid Format. Must be <ORIGIN> <DESTINATION> <DISTANCE>'
		else
			distancia = data[2]
			if distancia.to_i<=0 || distancia.to_i > 100000
				status = 'erro'
				mensagem = 'Distance must be a number between 1 and 100000'
			else

				status = 'ok'
				mensagem = ''
			end

			
			

		end
		return {status: status, mensagem: mensagem}
	end;

	private def register_distance(data)
		origem = data[0]
		destino = data[1]
		distancia = data[2]
		begin
		#Place.transaction do
			if !Place.exists?(description: origem) then
				@plcOrigem = Place.create(:description => origem)
				if !@plcOrigem.save then				
					raise 'Error saving Origin'
				else
					id_origem = @plcOrigem.id
				end
			else
				@plcOrigem = Place.find_by_description(origem)
				id_origem = @plcOrigem.id
			end
			if !Place.exists?(description: destino) then
				@plcDestino = Place.create(:description => destino)
				if !@plcDestino.save then				
					raise 'Error saving Destination'
				else
					id_destino = @plcDestino.id
				end
			else
				@plcDestino = Place.find_by_description(destino)
				id_destino = @plcDestino.id
			end
			
			#dados = Route.where("place_origin_id = ? AND place_destiny_id = ?",id_origem,id_destino).limit(1)
			#if dados then
			#	raise 'Tem'
			#else
			#	raise 'Nao Tem'
			#end
			#return true
			@route = Route.where(place_origin_id: id_origem, place_destiny_id: id_destino).first
			if @route then
				@route.distance = distancia
				ret = @route.save
			else
				@route = Route.create(:place_origin_id => id_origem, :place_destiny_id => id_destino, :distance => distancia)
				ret = @route.save
			end

			#.first_or_create(place_origin_id: id_origem, place_destiny_id: id_destino).update(distance: distancia)
			#ret = false
			if ret then
				return true
			else
				raise 'Erro saving distance'
			end
			return true
		#end
		rescue Exception => e 
			puts 'Erro'
			return e.message;
		end
	end

	private def place_params
		params.require(:place).permit(:description)
	end	
end
