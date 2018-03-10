class CostsController < ApplicationController
  def process(params)
  		params = request.query_parameters

		ret = validate_entry(params);
		
		#render plain: ret[:status]
		
		if !ret[:status].eql? 'ok' then
			
			status = 'erro'
			mensagem = ret[:mensagem]
		else
			retono = calculate_route(params);
			if (retono[:sucesso]===true) then

				status = 'ok'
				mensagem = retono[:mensagem]
			else 
				status = 'erro'
				mensagem = retono[:mensagem]
			end
		end
		render plain: mensagem

  end

	private def validate_entry(params)
		origem = params['origin']
		destino = params['destination']
		peso = params['weight']

		if origem.blank? then
			status = 'erro'
			mensagem = 'Origin not set'
		elsif destino.blank? then
			status = 'erro'
			mensagem = 'Destination not set'
		elsif peso.blank? then
			status = 'erro'
			mensagem = 'Weight not set'
		else
			if peso.to_i<=0 || peso.to_i > 50
				status = 'erro'
				mensagem = 'Weight must be between 1 e 50'
			else
				status = 'ok'
				mensagem = ''
			end
		end


		return {status: status, mensagem: mensagem}
	end;

	private def calculate_route(params)
		origem = params['origin']
		destino = params['destination']
		peso = params['weight']
		begin

			if !Place.exists?(description: origem) then
				raise 'Origin not found'
			else
				@plcOrigem = Place.find_by_description(origem)
				id_origem = @plcOrigem.id
			end
			if !Place.exists?(description: destino) then
				raise 'Destination not found'
			else
				@plcDestino = Place.find_by_description(destino)
				id_destino = @plcDestino.id
			end

			query = 'WITH base AS (
			    select origem1.description || \' -> \' || destino1.description as route, route_filho.place_origin_id as ori, route_filho.place_origin_id, route_filho.place_destiny_id, route_filho.distance, route_filho.distance as all_distance
			    from routes route_filho
			        join places as origem1 on origem1.id = route_filho.place_origin_id
			        join places as destino1 on destino1.id = route_filho.place_destiny_id
			    where route_filho.place_origin_id = ?
			    union all
			    select base.route || \' -> \' || destino2.description as route, base.ori as ori, route_pai.place_origin_id, route_pai.place_destiny_id, route_pai.distance, route_pai.distance + base.distance as all_distance
			    from routes route_pai
			        join places as origem2 on origem2.id = route_pai.place_origin_id
			        join places as destino2 on destino2.id = route_pai.place_destiny_id
			    join base on route_pai.place_origin_id = base.place_destiny_id
			)
			select * from base
			where ori = ? and place_destiny_id = ?
			order by all_distance asc limit 1'

			@route = Route.find_by_sql([query, id_origem, id_origem, id_destino])
			rota =  @route.map { |f| f.route }.join ','
			distancia =  @route.map { |f| f.all_distance }.join ','
			#distancia = @route['all_distance']
			

			#raise id_destino.to_s
			#dados = Route.where("place_origin_id = ? AND place_destiny_id = ?",id_origem,id_destino).limit(1)
			#if dados then
			#	raise 'Tem'
			#else
			#	raise 'Nao Tem'
			#end
			#return true


			#.first_or_create(place_origin_id: id_origem, place_destiny_id: id_destino).update(distance: distancia)
			#ret = false
			if !rota.blank? then
				valor = distancia.to_i
				valor = valor * peso.to_i * 0.15
				mensagem = valor
				return {sucesso: true, mensagem: mensagem.to_s};
			else
				raise 'No Path Found between Origin and Destination'
			end
			return {sucesso: true, mensagem: mensagem};
		#end
		rescue Exception => e 
			puts 'Erro'
			return {sucesso: false, mensagem: e.message};
		end
	end	  
end
