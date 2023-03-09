Config = {}

Config.webhook = "https://discord.com/api/webhooks/979542618155409428/JbVj4n_nN-CTC8z5zDE4zpVcERXGCuW1sRaTvxd4bxxfcWZoJM-vHqKmS6AuznLpwWqT"						-- Webhook para enviar logs para o discord
Config.lang = "br"								-- Defina o idioma do arquivo [en/br]

Config.Framework = {							-- Configurações ESX/QBCore
	['SHAREDOBJECT'] = "QBCore:GetObject",		-- Altere seu evento de objeto getshared aqui, se você estiver usando anti-cheat
	['account_trucker'] = 'bank',				-- Mude aqui a conta que deve ser usada com despesas de caminhoneiro
}

Config.format = {
	['currency'] = 'USD',						-- Este é o formato da moeda, para que o símbolo da sua moeda apareça corretamente [Exemplos: BRL, USD]
	['location'] = 'pt-BR'						-- Esta é a localização do seu país, para formatar as casas decimais de acordo com seu padrão [Exemplos: pt-BR, en-US]
}

Config.permission = "false"		-- Permissão para abrir o menu (coloque false para desativar)

-- Aqui estão os locais onde a pessoa pode abrir o menu do caminhoneiro
-- Você pode adicionar quantos locais quiser, basta usar o local já criado como exemplo
Config.trucker_locations = {
	["trucker_1"] = {															-- ID
		['menu_location'] = {1208.7689208984,-3114.9829101562,5.5403342247009},	-- Coordenadas para abrir o menu
		['garage_location'] = {													-- Coordenadas de garagem, onde os caminhões irão spawnar (coordenadas compostas por x, y, z, h)
			{1250.55,-3162.4,5.88,270.00},
			{1250.76,-3168.05,5.86,270.00},
			{1245.91,-3135.67,5.62,270.00},
			{1246.07,-3142.42,5.63,270.00},
			{1245.93,-3149.04,5.62,270.00},
			{1245.69,-3155.94,5.6,270.00},
		},
		['trailer_location'] = {												-- Coordenadas do trailer, onde os trailers irão spawnar (coordenadas compostas por x, y, z, h)
			{1274.21,-3186.43,5.91,90.00},
			{1272.53,-3097.32,5.91,90.00},
			{1273.55,-3088.39,5.91,90.00},
			{1273.47,-3123.78,5.91,90.00},
			{1272.68,-3159.19,5.91,90.00},
			{1275.37,-3174.52,5.91,90.00},
			{1275.04,-3168.83,5.91,90.00},
		},
		--['blips'] = {							-- Criar os blips no mapa
		--	['id'] = 478,						-- ID do Blip [Defina este valor como 0 para não ter um blip]
		--	['name'] = "Los Santos Trucker",		-- Nome do Blip
		--	['color'] = 4,						-- Cor do Blip
		--	['scale'] = 0.5,					-- Escala do Blip
		--}
	}
}

-- Aqui está a definição dos contratos que são gerados para que os jogadores entreguem
Config.jobs = {
	['cancel_job'] = 167,						-- Tecla para cancelar o trabalho atual (167 = F6) [Segurar a tecla durante 2 segundos]
	['cooldown'] = 1, 							-- Tempo de espera (em minutos) para gerar um novo contrato
	['price_per_km_min'] = 250,				-- Preço mínimo por quilômetro do contrato
	['price_per_km_max'] = 275,				-- Preço máximo por quilômetro do contrato
	['freight_job_mutiplier'] = 1.2,			-- Mutiplicador aplicado ao gerar cargas de FRETE
	['probability_urgent_cargo'] = 10,			-- A carga urgente é gerada aleatoriamente, aqui você pode configurar a probabilidade (%)
	['max_contratos_ativos'] = 60,				-- Máximo de contratos que podem estar ativos, isso significa que ao gerar um contato que ultrapasse este número, o contrato mais antigo será excluído
	['available_trucks'] = {					-- Lista de caminhões que são gerados em contratos
		"packer","phantom","hauler"
	},
	['must_bring_truck_back'] = false,			-- true: O pagamento só será feito ao trazer o caminhão de volta para a garagem (exceto com caminhão proprio) | false: O pagamento será feito no ato da entrega da carga
	['available_loads'] = {
		--[[ 
			Lista de cargas que são geradas nos contratos.
			trailer: é o nome do trailer
			name: é o nome que aparecerá na lista para o jogador selecionar
			def: são as definições de carga, para configurar se é um certificado ADR, carga frágil ou valiosa
			Def é composto por 3 valores
			def = {
				0, [Primeiro valor]: Tipo de certificado ADR. 0 = Nenhum, 1 = Explosivos, 2 = Gases inflamáveis, 3 = Líquidos inflamáveis, 4 = Sólidos inflamáveis, 5 = Substâncias tóxicas, 6 = Substâncias corrosivas
				0, [Segundo valor]:  Carga frágil: 0 = Não frágil, 1 = É frágil
				0  [Terceiro valor]: Carga valiosa: 0 = Não tem valor, 1 = É valioso
			}
		]]
			{ trailer = "armytanker", name = "Tanque de combustível do exército", def = {3,0,0}},
			{ trailer = "armytanker", name = "Abastecimento de água do exército", def = {0,0,0}},
			{ trailer = "armytanker", name = "Tanque de materiais corrosivos do exército", def = {6,0,1}},
			{ trailer = "armytanker", name = "Tanque de gases inflamáveis do exército", def = {2,0,0}},
			{ trailer = "armytanker", name = "Tanque de gases tóxicos do exército", def = {5,0,0}},
			{ trailer = "armytanker", name = "Materiais secretos do exército", def = {0,0,0}},
	
			{ trailer = "armytrailer", name = "Trailer vazio do exército", def = {0,0,0}},
	
			{ trailer = "armytrailer2", name = "Transporte de máquinário pesado", def = {0,1,1}},
			{ trailer = "armytrailer2", name = "Transporte de tuneladora", def = {0,1,1}},
	
			{ trailer = "docktrailer", name = "Transporte de móveis", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de geladeiras", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de tijolos", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de produtos importados", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de plásticos", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de roupas", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de cadeiras", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de eletrodomésticos", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de materiais de limpeza", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de madeira refinada", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de pedras", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de jóias", def = {0,1,1}},
			{ trailer = "docktrailer", name = "Transporte de vidros", def = {0,1,0}},
			{ trailer = "docktrailer", name = "Transporte de lixeiras", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de telhado", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de acrilico", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de munição", def = {1,0,0}},
	
			{ trailer = "freighttrailer", name = "Trailer vazio", def = {0,0,0}},
	
			{ trailer = "tr2", name = "Trailer de carros vazio", def = {0,0,0}},
	
			{ trailer = "trailers4", name = "Trailer de artigos navais", def = {0,0,0}},
			{ trailer = "trailers4", name = "Trailer de barco", def = {0,1,1}},
	
			{ trailer = "tr4", name = "Cegonheira", def = {0,1,1}},
			
			{ trailer = "tvtrailer", name = "Transporte de materiais para shows", def = {0,0,0}},
			{ trailer = "tvtrailer", name = "Transporte de materiais de eventos", def = {0,0,0}},
	
			{ trailer = "tanker", name = "Tanque de combustível aditivado", def = {3,0,0}},
			{ trailer = "tanker2", name = "Tanque de combustível comum", def = {3,0,0}},
			{ trailer = "tanker2", name = "Tanque de querosene", def = {3,0,0}},
			{ trailer = "tanker2", name = "Tanque de óleo", def = {3,0,0}},
	
			{ trailer = "docktrailer", name = "Transporte de materiais exóticos", def = {0,0,0}},
			{ trailer = "docktrailer", name = "Transporte de materiais raros", def = {0,1,1}},
			{ trailer = "docktrailer", name = "Transporte de armamentos", def = {0,0,1}},
	
			{ trailer = "trailerlogs", name = "Transporte de toras de madeira", def = {0,0,0}},
	
			{ trailer = "trailers", name = "Transporte de materiais de construção", def = {0,0,0}},
			{ trailer = "trailers", name = "Transporte de borracha", def = {0,0,0}},
			{ trailer = "trailers", name = "Transporte de eletrodomésticos", def = {0,0,0}},
			{ trailer = "trailers", name = "Transporte de vacinas", def = {0,0,0}},
			{ trailer = "trailers", name = "Transporte de explosivos", def = {1,1,0}},
			{ trailer = "trailers", name = "Transporte de serragem", def = {0,0,0}},
	
			{ trailer = "trailers2", name = "Transporte de uvas", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de carne de porco", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de carne de boi", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de cenouras", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de batatas", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de leite", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de produtos enlatados", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de carne congelada", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de feijão", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de vinagre", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de limonada", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de agua engarrafada", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de queijo", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de lasanhas", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de carnes", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de frios", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de laticinios", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de suco Tial", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de coxinhas", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de empadas congeladas", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de verduras", def = {0,0,0}},
			{ trailer = "trailers2", name = "Transporte de legumes", def = {0,0,0}},
	
			{ trailer = "trailers3", name = "Transporte de telhas", def = {0,0,0}},
			{ trailer = "trailers3", name = "Transporte de calhas", def = {0,0,0}},
			{ trailer = "trailers3", name = "Transporte de embalagens usadas", def = {0,0,0}},
			{ trailer = "trailers3", name = "Transporte de placas de piso", def = {0,0,0}},
			{ trailer = "trailers3", name = "Transporte de cerâmica", def = {0,0,0}},
			{ trailer = "trailers3", name = "Transporte de sucata", def = {0,0,0}},
	
			{ trailer = "trailers4", name = "Transporte de fogos de artifício", def = {1,1,0}},
			{ trailer = "trailers4", name = "Transporte de explosivos", def = {1,1,0}},
			{ trailer = "trailers4", name = "Transporte de dinamite", def = {1,1,0}},
			{ trailer = "trailers4", name = "Transporte de fósforo branco", def = {4,1,0}},
	}
}

-- Aqui está a definição dos motoristas que são gerados para os jogadores contratarem
Config.drivers = {
	['cooldown'] = 30,							-- Tempo de espera (em minutos) para gerar um novo motorista disponível para ser contratado
	
	['hiring_costs'] = {						-- Custo de contratação do motorista (este valor será pago apenas no momento da contratação)
		['min'] = 1000,							-- Este é o custo mínimo de contratação do funcionário
		['max'] = 2000,							-- Este é o custo máximo de contratação do funcionário (este valor irá aumentar de acordo com as habilidades dele)
		['percentage_skills'] = 50,				-- Este é o custo em % que cada habilidade aumentará no custo de contratação do motorista. Ou seja, para cada nivel de habilidade que o motorista tiver, irá aumentar esta porcentagem
	},

	['available_drivers'] = {
		-- Lista de motoristas que são gerados aleatoriamente para serem contratados
		{img = "https://bootdey.com/img/Content/avatar/avatar8.png", names = {"Pedro Aquino","Jorge Fernandes","Lucas Silva","Cochran Hicks","Shirley Austin","Grimes Williamson","Kirk Cook","Davis Guerrero","Rocha Good","Hatfield Clarke","Norton Anthony","Parks Dale","Ellison Harrison","Rojas Boyd","Moon Acevedo","Carole Rivas","Wells Wyatt","Beasley Griffith","Jordan Hyde","Holman Dixon","Holden Lynch","Mckenzie Wilkerson","Chapman Preston","Christian Green","Blake Stuart","Paulette Atkinson","Dollie Lane","Castaneda Browning","Baldwin Blankenship","Russell Bowen","Madge Boyle","Nanette Cummings","Brooke Spence","Whitfield Berg","Angie Gonzales","Johanna Mercer","Terrell Mcmillan","Gilmore Quinn","Kenya Pittman","Hurley Black","Shanna Ortega","Logan Sharpe","Mari Brady","Mendoza Wilkinson","Stacie Sanford","Polly Acosta","Stone Robinson","Claudette Bartlett","Young Hines","Potter Wagner","Reilly Callahan","Kerr Kemp","Goff Raymond"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar7.png", names = {"Ivan Noleto Sequeira","Kim Wolfe","Laura Logan","Bruce Craft","Compton Luna","Randolph Callahan","Mccray Brock","Sybil Miles","Hendricks Henry","Tina Compton","Phelps Hunter","Jones Russo","Esmeralda Banks","Reid Dean","Parrish Cole","Carlson Gilbert","Jackie Macias","Liza Morse","Mclean Warner","Winnie Lopez","Katheryn Valenzuela","Wade Mccoy","Acosta Mays","Valeria Witt","Elnora Howard","Bernadette Dawson","Rivera Casey","Little Sanford","Deanna Petty","Leonard Blackwell","Payne Leblanc","Tammy Murphy","Sargent Donaldson","Colon Carey","Janis Roth","Lidia Higgins","Lakisha Whitaker","Adrian Mcbride","Maria Forbes","Daisy Mason","Pittman Curtis","Ladonna Bryan","Gaines Hogan","Powers Rodriquez","Donna Hopper","Kristi Livingston","Chelsea Bauer","Gray Fleming","Contreras Mcdonald","Vilma Potts","Guadalupe Mullins"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar6.png", names = {"Kenya Mullen","Castaneda Colon","Judy Mckay","Taylor Kerr","Hurst Roy","Owens Vaughan","Vanessa Cline","Bertie Edwards","Flynn Frank","Burks Sutton","Randi Meadows","Tessa Gentry","Lowery Wooten","Acosta Harper","Georgette Cooley","Candice Patterson","Kirsten Daniels","Blake West","Alexandria Pope","Lena Forbes","Morton Snyder","Tara Bradford","Selena Sykes","Tameka Atkinson","Fowler Walker","Gena Ortega","Sheppard Navarro","Imelda Duncan","Christina Bowers","Aline Haynes","Benita Bright","Boyd Mccall","Sandra Weaver","Melissa Wells","Graham Gilmore","Katrina Oliver","Ginger Larson","Griffith Bishop","Barbara Washington","Iris Christensen","Bauer Gay","Hays Vega","Valarie Booth","Kitty Crane","Carmella Torres","Angelina Puckett","Stone Cabrera","Brock Humphrey","Hillary Houston","Callie Robles"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar5.png", names = {"Rocha Harrell","Gilliam Thomas","Osborne Blevins","Elba Chambers","Heath Price","Melinda Maynard","Ashlee Johns","Shelton Petty","Carey Mcclain","Blackwell Horne","Deborah Gonzalez","Buck Faulkner","Celina Chang","Kennedy Patrick","Atkinson Sherman","Janelle Tyson","Noelle Vincent","Leah Barron","Angeline Sellers","Trudy Murray","Contreras Hardy","Fletcher Todd","Benson Singleton","Sanford Dean","Hartman Wilkinson","Harriet Robinson","Vivian Osborn","Ida Simmons","Tamara Merrill","Esmeralda Baird","Maynard Oneal","Brianna Greene","Pat Stewart","Tate Wood","French Farrell","Jolene Calderon","Irene Roth","Dina Waller","Gonzalez Alvarez","Leigh Durham","Eve Moody","Lydia Hewitt","Price Summers","Duran Schultz","Rena Williamson","Meagan Shaffer","Angelique Dennis","Graham Love","Sheree Lynn","Church Golden"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar4.png", names = {"Cecelia Carson","Rivas Kelly","Green Johnson","Jill Buck","Maddox Leblanc","Hope Aguirre","Aguilar Diaz","Valerie Wiggins","Crystal Sweeney","Sharlene Davidson","Ruthie Valdez","Allyson Haney","Bridgett Wright","Cooke Vargas","Hopkins Neal","Deloris Curry","Alba Warren","Lynette Preston","Candace Britt","Phyllis Mayer","Bailey Stephenson","Meredith Harrell","Conner Heath","Kelly Lynch","Kelli Salinas","Tamara Tran","Boone Sosa","Cora Barrera","John Francis","Tammi Parsons","Natalie Travis","Ivy Mccoy","William Nash","Reba Dillon","Kimberley Whitney","Karen Ellis","Alison Padilla","Spencer Camacho","Blackwell Mccray","Mcgowan Castaneda","Kent Thomas","Lauri Wiley","Atkins Lowery","Janell Hancock","Mosley Carney","Mason Clay","Pat Mercer","Frances Oneal","Brandy Strong","Elvira Houston"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar3.png", names = {"Joice Campos","Mélanie Rebotim","Berenice Holanda","Maitê Lage","Eduarda Barbosa","Livia Martins","Melissa Fernandes","Isabela Castro","Leila Fernandes","Letícia Correia","Melissa Cunha","Gabriela Azevedo"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar2.png", names = {"Howell Dickerson","Carlson Kerr","Kitty Moody","Malinda Richards","Craig Watts","Alana Ratliff","Mindy Patton","Kelly Stone","Beasley Stark","Perez Mercer","Janell Norris","Angela Mayer","Opal Orr","Charity Lamb","Ford Castaneda","Mitzi Nelson","Corrine Morris","Nanette Cervantes","Evelyn Burton","Giles Fletcher","Franklin Hahn","Ruiz Simmons","Selena Murphy","Mccoy Clarke","Skinner Sanford","Lea Oneill","Williamson Rosales","Katharine Hendricks","Dillon Nguyen","Cannon Fulton","Sharp Mccray","Billie Schultz","Flora Griffith","Russell Beasley","Sampson Forbes","Duran Moore","Leach Todd","Henrietta Bowman","Margie Solomon","Mcdonald Collins","Willis Pratt","Britney Dixon","Mcleod Mejia","Salinas Albert","Padilla Lynn","Natalia Garrett","Lynnette Savage","Fleming Keith","Johnston Carrillo","Whitney Gomez"}},
		{img = "https://bootdey.com/img/Content/avatar/avatar1.png", names = {"Bennett Stevens","Mcmillan Calhoun","Paula Blanchard","Roberson Holman","Frost Woods","Drake Boyd","Maricela Long","Hess Guerrero","Martha Adams","Simmons Ramsey","Medina Pitts","Hazel Tyson","Mia Nguyen","Clare Shannon","Kristy Dorsey","Hilda Cochran","Sandy Zimmerman","Petra Lowery","Opal Collier","Velez Terry","Mccormick Hewitt","Weeks Garner","Ashley Byers","Guzman Blackburn","Ramona Stanley","Delia Ratliff","Talley Rodriquez","Ochoa Hayden","Thelma Stout","Lloyd Clarke","Gordon Gould","Aida Noel","Corinne Richmond","Malone Walls","Shields Bowen","Howell Harper","Figueroa Schwartz","Rachel Delgado","Debora Chaney","Chen Avery","Kidd Fitzgerald","Aguirre Park","Combs Cruz","Huff Thompson","Munoz Crosby","Whitaker Mason","Oneil York","Francis Houston","Prince White","Cornelia Bell"}}
	},
	['max_active_drivers'] = 20,				-- Número máximo de drivers que podem estar ativos, isso significa que ao gerar um driver que ultrapasse este número, o driver mais antigo será excluído
	['max_drivers_per_player'] = 1				-- Número máximo de motoristas que cada player pode ter
}

-- Aqui está a definição dos contratos que são gerados para os motoristas realizarem
Config.driver_jobs = {
	['cooldown'] = 120,							-- Tempo de espera (em minutos) para que os motoristas façam contratos e gerem dinheiro para a empresa

	['profit'] = {								-- Estes são os ganhos dos motoristas por cada contrato, é gerado um valor aleatorio a cada contrato
		['min'] = 1000,							-- Lucro base mínimo, isso será o minimo de dinheiro que este motorista pode gerar
		['max'] = 1100,							-- Lucro base máximo, isso será o valor máximo de dinheiro que este motorista pode gerar (este valor irá aumentar de acordo com as habilidades do motorista)
		['percentage_skills'] = 5,				-- Este é o valor em % que cada habilidade aumentará no lucro final do motorista. Ou seja, quanto mais habilidades ele tiver, maior será o lucro
	},

	['generate_money_offline'] = false 			-- true: os motoristas vão gerar dinheiro o tempo todo / false: os motoristas vão gerar dinheiro apenas se o dono estiver online
}

Config.sell_price_multiplier = 0.7				-- Valor que você recebe ao vender o caminhão usado
Config.dealership = {							-- Veículos de concessionária de caminhões
	-- Aqui você pode configurar os veículos da concessionária
	['actros'] = { 								-- Este deve ser o nome de spawn do veículo
		['name'] = 'Mercedes-Benz Actros',		-- Nome do caminhão
		['price'] = 310000,						-- Preço
		['engine'] = "12.0 L MB OM 457 LA I6",	-- Configuração do motor
		['transmission'] = "12-Speed",			-- Configuração do motor
		['hp'] = '450',							-- Potência
		['img'] = 'img/actros.jpg',				-- Imagem do veículo
		['driver_bonus'] = 4					-- Porcentagem que o motorista receberá a mais ao ter este caminhão
	},
	-- Os outros veículos seguem o mesmo padrão do veículo acima
	['man'] = {
		['name'] = 'MAN TGX',
		['price'] = 270000,
		['engine'] = "16.2 L D2868 V8",
		['transmission'] = "12-Speed",
		['hp'] = '401',
		['img'] = 'img/man.jpg',
		['driver_bonus'] = 2
	},
	['daf'] = {
		['name'] = 'DAF XF Euro 6',
		['price'] = 330000,
		['engine'] = "12.9 PACCAR MX-13 I6",
		['transmission'] = "12-Speed",
		['hp'] = '480',
		['img'] = 'img/daf.jpg',
		['driver_bonus'] = 6
	},
	['t680'] = {
		['name'] = 'Kenworth T680',
		['price'] = 600000,
		['engine'] = "12.9 PACCAR MX-13 I6",
		['transmission'] = "10-Speed",
		['hp'] = '550',
		['img'] = 'img/t680.jpg',
		['driver_bonus'] = 10
	},
	['w900'] = {
		['name'] = 'Kenworth W900 6x2',
		['price'] = 650000,
		['engine'] = "15.0 Cummins ISX I6",
		['transmission'] = "18-Speed",
		['hp'] = '590',
		['img'] = 'img/w900.jpg',
		['driver_bonus'] = 12
	},
	['r730'] = {
		['name'] = 'Scania S730',
		['price'] = 620000,
		['engine'] = "DC-16-123 V8 de 16 litros",
		['transmission'] = "12-Speed",
		['hp'] = '620',
		['img'] = 'img/r730.jpg',
		['driver_bonus'] = 11
	}
}
Config.repair_price = { -- Valor a reparar 1% de cada peça (Exemplo: se 40% da peça estiver danificada, o valor a reparar será multiplicado por 40)
	['engine'] = 250,
	['body'] = 150,
	['transmission'] = 200,
	['wheels'] = 100
}

--[[
	Quantidade de exp que você precisa para alcançar cada nível
	Exemplo:
	[1] = 100,
	[2] = 200,
	Isso significa que para alcançar o nível 1 você precisa de 100 EXP, para chegar ao nível 2 você precisa de 200 EXP
	Ao subir de nível, o jogador recebe 1 ponto de habilidade
	O nível 30 é o máximo
]]
Config.required_xp_to_levelup = {
	[1] = 1000,
	[2] = 2000,
	[3] = 3000,
	[4] = 4000,
	[5] = 5000,
	[6] = 6000,
	[7] = 7000,
	[8] = 8000,
	[9] = 9000,
	[10] = 10000,
	[11] = 11000,
	[12] = 12000,
	[13] = 13000,
	[14] = 14000,
	[15] = 16000,
	[16] = 18000,
	[17] = 20000,
	[18] = 22000,
	[19] = 24000,
	[20] = 26000,
	[21] = 28000,
	[22] = 30000,
	[23] = 35000,
	[24] = 40000,
	[25] = 45000,
	[26] = 50000,
	[27] = 55000,
	[28] = 60000,
	[29] = 65000,
	[30] = 100000 -- Max
}

--[[
	Montante máximo do empréstimo que uma pessoa pode tomar por nível (quanto mais alto o nível, maior o empréstimo)
	Exemplo:
	[0] = 40000,
	[10] = 100000,
	[20] = 250000,
	[30] = 600000
	Isso significa que do nível 0 ao nível 10, você pode obter um empréstimo de 40 mil. Do nível 10 ao 20, você pode levar no máximo 100 mil ....
]]
Config.max_loan_per_level = {
	[0] = 40000,
	[10] = 100000,
	[20] = 250000,
	[30] = 600000
}

-- Valores do empréstimo e valor cobrado por dia
Config.loans = {
	['cooldown'] = 86400, -- Tempo (em segundos) que o empréstimo será cobrado do jogador (86400 = 24 horas)
	['amount'] = {
		--[[
			É possível configurar 4 valores de empréstimo e cada empréstimo tem suas próprias configurações
			Exemplo:
			[1] = {
				20.000, [valor do empréstimo]: 20.000
				240, 	[Valor que o jogador paga por dia]: Este valor deve ser maior que o valor abaixo, portanto, neste caso, ao finalizar o pagamento de todas as parcelas, o jogador pagará 24 mil (4 mil de juros)
				200 	[valor base para calcular juros]: O valor acima subtraído deste (240 - 200) será o valor dos juros: 40 juros por dia
			},
		]]
		[1] = {20000,400,200},
		[2] = {50000,950,500},
		[3] = {100000,1800,1000},
		[4] = {400000,7000,4000}
	}
}

--[[
	Nível de habilidade e km que você pode perceorrer em cada nível
	Exemplo:
	[0] = 6,
	[1] = 6.5,
	Isso significa que no nível 0 o jogador pode iniciar contratos de no máximo 6 km, no nível 1 ele pode fazer contratos de 6.5 km
	O nível 6 é o máximo
]]
Config.distance_skill = {
	[0] = 6,
	[1] = 6.5,
	[2] = 7,
	[3] = 7.5,
	[4] = 8,
	[5] = 8.5,
	[6] = 99 -- Max
}

--[[
	Ganho de EXP em %
	XP é calculado com base no valor da entrega, então se ele receber R$1000 em uma entrega, e Config.exp_gain = 1 então ele ganhará 10 XP
	Este XP será aumentado com base nos bônus configurados abaixo
]]
Config.exp_gain = 10

-- Bônus EXP e dinheiro que cada habilidade dá
Config.bonus = {
	-- Este bônus será aplicado de acordo com o nível e requisitos da carga. Então, ao transportar uma carga frágil, ele receberá o bônus de carga frágil (esses valores estão em %)
	['distance'] = {
		['money_bonus_percentage'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp_bonus_percentage'] = {
			[1] = 5,
			[2] = 5,
			[3] = 5,
			[4] = 5,
			[5] = 5,
			[6] = 5
		}
	},
	['valuable'] = {
		['money_bonus_percentage'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp_bonus_percentage'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	},
	['fragile'] = {
		['money_bonus_percentage'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp_bonus_percentage'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	},
	['fast'] = {
		['money_bonus_percentage'] = {
			[1] = 2,
			[2] = 4,
			[3] = 6,
			[4] = 8,
			[5] = 10,
			[6] = 12
		},
		['exp_bonus_percentage'] = {
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
			[5] = 10,
			[6] = 10
		}
	}
}

Config.party = {
	['price_to_create'] = 5000,		-- Preço para criar um grupo
	['price_per_member'] = 100, 	-- Custo de cada membro adicional
	['max_members'] = 10,			-- Quantidade maxima de membros de cada grupo
	['party_money_bonus'] = 5,		-- Bônus de dinheiro (em %) que cada membro do grupo recebe ao finalizar uma entrega
	['party_exp_bonus'] = 5,		-- Bônus de xp (em %) que cada membro do grupo recebe ao finalizar uma entrega
	['only_leader_can_start'] = true-- true: Somente o lider do grupo pode iniciar uma entrega | false: Qualquer membro pode iniciar uma entrega
}

Config.keyToUnlockTruck = 182     -- Tecla L

-- Locais de entrega de carga
Config.delivery_locations = {
	{-758.14,5540.96,33.49,28.00},
	{-3046.19,143.27,11.6,11.14},
	{-1153.01,2672.99,18.1,312.25},
	{622.67,110.27,92.59,340.75},
	{-574.62,-1147.27,22.18,177.7},
	{376.31,2638.97,44.5,286.38},
	{1738.32,3283.89,41.13,16.24},
	{1419.98,3618.63,34.91,195.33},
	{1452.67,6552.02,14.89,138.69},
	{3472.4,3681.97,33.79,76.44},
	{2485.73,4116.13,38.07,66.71},
	{65.02,6345.89,31.22,206.64},
	{-303.28,6118.17,31.5,135.24},
	{-746.6,-1496.67,5.01,28.08},
	{369.54,272.07,103.11,247.94},
	{907.61,-44.12,78.77,323.08},
	{-1517.31,-428.29,35.45,55.77},
	{235.04,-1520.18,29.15,316.76},
	{34.8,-1730.13,29.31,226.06},
	{350.4,-2466.9,6.4,169.38},
	{1213.97,-1229.01,35.35,270.74},
	{1395.7,-2061.38,52.0,135.81},
	{729.09,-2023.63,29.31,268.75},
	{840.72,-1952.59,28.85,81.46},
	{551.76,-1840.26,25.34,40.72},
	{723.78,-1372.08,26.29,106.65},
	{-339.92,-1284.25,31.32,89.06},
	{1137.23,-1285.05,34.6,189.65},
	{466.93,-1231.55,29.95,267.14},
	{442.28,-584.28,28.5,252.12},
	{1560.52,888.69,77.46,19.02},
	{2561.78,426.67,108.46,301.57},
	{569.21,2730.83,42.07,91.35},
	{2665.4,1700.63,24.49,269.33},
	{1120.1,2652.5,38.0,181.77},
	{2004.23,3071.87,47.06,237.58},
	{2038.78,3175.7,45.09,140.47},
	{1635.54,3562.84,35.23,296.61},
	{2744.55,3412.43,56.57,247.48},
	{1972.17,3839.16,32.0,304.36},
	{1980.59,3754.65,32.18,211.64},
	{1716.0,4706.41,42.69,91.44},
	{1970.3,5177.39,47.83,318.89},
	{1908.78,4932.06,48.97,340.08},
	{140.79,-1077.85,29.2,262.4},
	{-323.98,-1522.86,27.55,258.59},
	{-1060.53,-221.7,37.84,299.01},
	{2471.47,4463.07,35.3,277.56},
	{2699.47,3444.81,55.8,153.49},
	{2655.38,3281.01,55.24,63.99},
	{2730.39,2778.2,36.01,134.51},
	{2788.89,2816.49,41.72,296.22},
	{-604.45,-1212.24,14.95,227.43},
	{2534.83,2589.08,37.95,2.48},
	{-143.31,205.88,92.12,86.41},
	{2347.04,2633.25,46.67,30.15},
	{860.47,-896.87,25.53,181.8},
	{973.34,-1038.19,40.84,272.3},
	{-71.8,-1089.98,26.56,339.06},
	{-409.04,1200.44,325.65,164.59},
	{-1617.77,3068.17,32.27,94.64},
	{1246.34,1860.78,79.47,315.78},
	{-1637.61,-814.53,10.17,139.15},
	{-1494.72,-891.67,10.11,73.06},
	{-902.27,-1528.42,5.03,106.23},
	{-1173.93,-1749.87,3.97,211.53},
	{-1087.8,-2047.55,13.23,314.93},
	{-1234.4,-2092.3,13.93,173.93},
	{-1025.97,-2223.62,8.99,224.96},
	{850.42,2197.69,51.93,243.19},
	{42.61,2803.45,57.88,145.49},
	{-1193.54,-2155.4,13.2,138.82},
	{-1184.37,-2185.67,13.2,336.13},
	{2041.76,3172.26,44.98,155.2},
	{-465.48,-2169.09,10.01,9.47},
	{-433.69,-2277.29,7.61,268.97},
	{-395.18,-2182.97,10.29,94.54},
	{-3029.7,591.68,7.79,199.33},
	{-61.32,-1832.75,26.8,227.87},
	{822.72,-2134.28,29.29,349.36},
	{942.22,-2487.76,28.34,89.41},
	{729.29,-2086.53,29.3,89.29},
	{783.08,-2523.98,20.51,5.67},
	{787.05,-1612.38,31.17,48.33},
	{913.52,-1556.87,30.74,272.14},
	{777.64,-2529.46,20.13,96.09},
	{846.71,-2496.12,28.34,81.07},
	{711.79,-1395.19,26.35,103.31},
	{723.38,-1286.3,26.3,90.13},
	{983.0,-1230.77,25.38,121.4},
	{818.01,-2422.85,23.6,174.28},
	{885.53,-1166.38,24.99,94.77},
	{700.85,-1106.93,22.47,163.11},
	{882.26,-2384.1,28.0,179.16},
	{1003.55,-1860.27,30.89,268.33},
	{-1138.73,-759.77,18.87,234.36},
	{938.71,-1154.36,25.38,178.46},
	{973.0,-1156.18,25.43,267.36},
	{689.41,-963.48,23.49,178.61},
	{140.72,-375.29,43.26,336.19},
	{-497.09,-62.13,39.96,353.27},
	{-606.34,187.43,70.01,270.65},
	{117.12,-356.15,42.59,252.09},
	{53.91,-1571.07,29.47,137.1},
	{1528.1,1719.32,109.97,34.6},
	{1145.76,-287.73,68.96,284.29},
	{1117.71,-488.25,65.25,166.07},
	{874.28,-949.16,26.29,358.46},
	{829.28,-874.08,25.26,270.18},
	{725.37,-874.53,24.67,265.96},
	{693.66,-1090.43,22.45,174.62},
	{977.51,-1013.67,41.32,270.83},
	{911.7,-1258.04,25.58,33.69},
	{847.06,-1397.72,26.14,151.79},
	{130.47,-1066.12,29.2,160.09},
	{-16.81,-1021.67,28.93,68.04},
	{-131.74,-1097.38,21.69,335.25},
	{-668.65,-1182.07,10.62,208.79},
	{-111.84,-956.71,27.27,339.83},
	{-1323.51,-1165.11,4.73,359.27},
	{-1314.65,-1254.96,4.58,19.95},
	{-1169.18,-1768.78,3.87,306.82},
	{-1343.38,-744.02,22.28,309.26},
	{-1532.84,-578.16,33.63,304.2},
	{-1461.4,-362.39,43.89,219.06},
	{-1457.25,-384.15,38.51,114.12},
	{-1544.42,-411.45,41.99,226.04},
	{-1432.72,-250.32,46.37,130.83},
	{-1040.24,-499.88,36.07,118.78},
	{346.43,-1107.19,29.41,177.11},
	{523.99,-2112.7,5.99,182.08},
	{977.19,-2539.34,28.31,357.42},
	{1101.01,-2405.39,30.76,259.61},
	{1591.9,-1714.0,88.16,120.75},
	{1693.41,-1497.45,113.05,66.92},
	{1029.44,-2501.31,28.43,149.34},
	{2492.55,-320.89,93.0,82.83},
	{2846.31,1463.1,24.56,74.93},
	{3631.05,3768.61,28.52,320.0},
	{3572.5,3665.53,33.9,75.93},
	{2919.03,4337.85,50.31,203.77},
	{2521.47,4203.47,39.95,327.93},
	{2926.2,4627.28,48.55,143.26},
	{3808.59,4463.22,4.37,87.61},
	{3323.71,5161.1,18.4,147.02},
	{2133.06,4789.57,40.98,26.62},
	{1900.83,4913.82,48.87,154.21},
	{381.06,3591.37,33.3,82.49},
	{642.8,3502.47,34.09,95.04},
	{277.33,2884.71,43.61,296.91},
	{-60.3,1961.45,190.19,294.86},
	{225.63,1244.33,225.46,194.24},
	{-519.96,5243.84,79.95,72.76},
	{-602.87,5326.63,70.46,168.65},
	{-797.95,5400.61,34.24,86.78},
	{-776.0,5579.11,33.49,167.58},
	{-704.2,5772.55,17.34,68.44},
	{-299.24,6300.27,31.5,134.2},
	{402.52,6619.61,28.26,357.71},
	{-247.72,6205.46,31.49,45.5},
	{-267.5,6043.45,31.78,50.59},
	{-16.29,6452.44,31.4,226.65},
	{2204.73,5574.04,53.74,351.31},
	{1638.98,4840.41,42.03,185.92},
	{1961.26,4640.93,40.71,293.6},
	{1776.61,4584.67,37.65,181.45},
	{607.49,165.2,98.24,341.06},
	{199.8,2788.78,45.66,276.37},
	{708.58,-295.1,59.19,277.93},
	{581.28,2799.43,42.1,1.52},
	{1296.73,1424.35,100.45,178.89},
	{955.85,-22.89,78.77,147.51}
	
}

Config.createTable = true