// To add a new lang file you must declare the file on the last lines of index.html like: <script src="lang/en.js" type="text/javascript"></script>
if (Lang == undefined) {
	var Lang = [];
}
Lang['br'] = {
	new_contracts: 'Novos contratos a cada {0} min',
	top_trucker_distance_traveled: 'Distancia viajada: {0}km',
	top_trucker_exp: 'EXP: {0}',
	sidebar_profile: 'Perfil',
	sidebar_jobs: 'Trabalhos rápidos',
	sidebar_jobs_2: 'Trabalhos de frete',
	sidebar_skills: 'Habilidades',
	sidebar_diagnostic: 'Diagnóstico',
	sidebar_dealership: 'Loja de caminhões',
	sidebar_mytrucks: 'Caminhões',
	sidebar_driver: 'Agência de motoristas',
	sidebar_mydrivers: 'Motoristas',
	sidebar_bank: 'Banco',
	sidebar_party: 'Grupos',
	sidebar_close: 'Fechar',

	statistics_page_title: 'Estatísticas',
	statistics_page_desc: 'Estatísticas da sua empresa de caminhões',
	statistics_page_money: 'Dinheiro',
	statistics_page_money_earned: 'Total de dinheiro ganho',
	statistics_page_deliveries: 'Entregas Terminadas',
	statistics_page_distance: 'Distância viajada',
	statistics_page_exp: 'EXP total ganho',
	statistics_page_skill: 'Pontos de habilidade',
	statistics_page_trucks: 'Caminhões',
	statistics_page_drivers: 'Motoristas',
	statistics_page_top_truckers: 'Top caminhoneiros',
	statistics_page_top_truckers_desc: 'Lista do top 10 caminhoneiros da cidade',

	contract_page_title: 'Trabalhos Rápidos',
	contract_page_desc: 'Aqui você não precisa de caminhão. A empresa fornecerá tudo para você',
	contract_page_title_freight: 'Mercado de fretes',
	contract_page_desc_freight: 'Ganhe mais dinheiro com frete com seu próprio caminhão',
	contract_page_distance: 'Distância: {0}km',
	contract_page_reward: 'Recompensa: {0}',
	contract_page_cargo_explosive: 'Explosivos',
	contract_page_cargo_flammablegas: 'Gases Inflamáveis',
	contract_page_cargo_flammableliquid: 'Líquidos inflamáveis',
	contract_page_cargo_flammablesolid: 'Sólidos inflamáveis',
	contract_page_cargo_toxic: 'Substâncias Tóxicas',
	contract_page_cargo_corrosive: 'Substâncias corrosivas',
	contract_page_cargo_fragile: 'Carga frágil',
	contract_page_cargo_valuable: 'Carga valiosa',
	contract_page_cargo_urgent: 'Carga urgente',
	contract_page_button_start_job: 'Iniciar Entrega',
	contract_page_button_start_job_party: 'Iniciar em grupo',

	skills_page_title: 'Habilidades',
	skills_page_desc: 'Evolua suas habilidades para obter melhores entregas (pontos de habilidade disponíveis: {0})',

	dealership_page_title: 'Concessionária',
	dealership_page_truck: 'Caminhão',
	dealership_page_desc: 'Compre caminhões para você e seus motoristas',
	dealership_page_price: 'Preço',
	dealership_page_engine: 'MOTOR',
	dealership_page_power: 'POTÊNCIA',
	dealership_page_power_value: '{0} hp',
	dealership_page_buy_button: 'COMPRAR',
	dealership_page_bottom_text: '*Termos & Condições',

	diagnostic_page_title: 'Diagnóstico',
	diagnostic_page_desc: 'Conserte seu caminhão para fazer trabalhos (mude seu caminhão clicando no botão selecionar na página Caminhões)',
	diagnostic_page_chassi: 'Reparar chassi',
	diagnostic_page_engine: 'Reparar motor',
	diagnostic_page_transmission: 'Reparar transmissão',
	diagnostic_page_wheels: 'Reparar rodas',

	trucks_page_title: 'Caminhões',
	trucks_page_desc: 'Veja todos os seus caminhões aqui. Você pode configurar um motorista para cada um',
	trucks_page_chassi: 'Chassi',
	trucks_page_engine: 'Motor',
	trucks_page_transmission: 'Transmissão',
	trucks_page_wheels: 'Rodas',
	trucks_page_sell_button: 'Vender',
	trucks_page_spawn: 'Retirar da garagem',
	trucks_page_remove: 'Desalocar',
	trucks_page_select: 'Selecionar',

	mydrivers_page_title: 'Motoristas',
	mydrivers_page_desc: 'Veja todos os seus motoristas aqui. Para fazer um motorista trabalhar basta alocar um caminhão para ele e aguardar.',

	drivers_page_title: 'Agência de recrutamento',
	drivers_page_desc: 'Recrute novos motoristas para trabalhar para sua empresa',
	drivers_page_hiring_price: 'Preço: {0}',
	drivers_page_skills: 'Habilidades',
	drivers_page_product_type: 'Tipo de Produto',
	drivers_page_distance: 'Distância',
	drivers_page_valuable: 'Carga de alto valor',
	drivers_page_fragile: 'Carga frágil',
	drivers_page_urgent: 'Entrega urgente',
	drivers_page_hire_button: 'CONTRATAR',
	drivers_page_fire_button: 'Demitir',
	drivers_page_pick_truck: 'Selecione um caminhão',

	skills_page_description: 'Descrição',
	skills_page_product_type_title: 'Tipo de Produto',
	skills_page_product_type_description: `
		<p>O transporte de mercadorias perigosas exige profissionais bem treinados. Adquira certificados ADR para liberar novos tipos de cargas.</p>
		<ul>
			Classe 1 - Explosivos:
			<li>Libere cargas de dinamite, fogos de artifício e munição</li>
			<BR>Classe 2 - Gases:
			<li>Libere cargas de gases inflamáveis, não-inflamáveis e venenosos</li>
			<BR>Classe 3 - Líquidos inflamáveis:
			<li>Libere cargas de combustíveis perigosos como gasolina, diesel e querosene</li>
			<BR>Classe 4 - Sólidos  inflamáveis:
			<li>Libere cargas de nitrocelulose, megnésio, fósforos de segurança, alumínio de combustão espontânea, fósforo branco, entre outros</li>
			<BR> Classe 6 - Substâncias Tóxicas
			<li>Libere cargas de venenos, cloreto de potássio, cianeto de mercúrio e pesticidas</li>
			<BR>Classe 8 - Substâncias corrosivas
			<li>Libere cargas de substâncias que podem dissolver tecido orgânico ou corroer severamente certos metais. Como ácido sulfúrico, ácido clorídrico, hidróxido de potássio e hidróxido de sódio</li>
		</ul>`,
	skills_page_distance_title: 'Distância',
	skills_page_distance_description: `
		<p>Sua habilidade de longa distância determina a distância máxima que você pode viajar em serviço. Inicialmente não são oferecidos para conduzir mais do que 6km.</p>
		<ul>
			Nivel 1:
			<li>Entregas até 6.5km</li>
			<li>2% de recompensa para distâncias maiores que 6km</li>
			<li>5% de bônus de experiência para distâncias maiores que 6km</li>
			<BR>Nivel 2:
			<li>Entregas até 7km</li>
			<li>4% de recompensa para distâncias maiores que 6.5km</li>
			<BR>Nivel 3:
			<li>Entregas até 7.5km</li>
			<li>6% de recompensa para distâncias maiores que 7km</li>
			<BR>Nivel 4:
			<li>Entregas até 8km</li>
			<li>8% de recompensa para distâncias maiores que 7.5km</li>
			<BR>Nivel 5:
			<li>Entregas até 8.5km</li>
			<li>10% de recompensa para distâncias maiores que 8km</li>
			<BR>Nivel 6:
			<li>Entregas em qualquer lugar</li>
			<li>12% de recompensa para distâncias maiores que 8.5km</li>
		</ul>`,
	skills_page_valuable_title: 'Carga Valiosa',
	skills_page_valuable_desc: `
		<p>Toda carga é valiosa, mas algumas são mais valiosas que as outras. As empresas confiam apenas em especialistas comprovados para realizar este tipo de serviço.</p>
		<ul>
			Nivel 1:
			<li>Ofertas de trabalho de cargas de alto valor desbloqueadas</li>
			<li>2% de recompensa para entregas valiosas</li>
			<li>10% de bônus de experiência para entregas valiosas</li>
			<BR>Nivel 2:
			<li>4% de recompensa para entregas valiosas</li>
			<BR>Nivel 3:
			<li>6% de recompensa para entregas valiosas</li>
			<BR>Nivel 4:
			<li>8% de recompensa para entregas valiosas</li>
			<BR>Nivel 5:
			<li>10% de recompensa para entregas valiosas</li>
			<BR>Nivel 6:
			<li>12% de recompensa para entregas valiosas</li>
		</ul>`,
	skills_page_fragile_title: 'Carga Frágil',
	skills_page_fragile_desc: `
		<p>Esta habilidade permite transportar cargas frágeis, como vidro, eletrônicos ou máquinas delicadas.</p>
		<ul>
			Nivel 1:
			<li>Ofertas de trabalho de cargas frágeis desbloqueadas</li>
			<li>2% de recompensa para entregas de cargas frágeis</li>
			<li>10% de bônus de experiência para entregas de cargas frágeis</li>
			<BR>Nivel 2:
			<li>4% de recompensa para entregas de cargas frágeis</li>
			<BR>Nivel 3:
			<li>6% de recompensa para entregas de cargas frágeis</li>
			<BR>Nivel 4:
			<li>8% de recompensa para entregas de cargas frágeis</li>
			<BR>Nivel 5:
			<li>10% de recompensa para entregas de cargas frágeis</li>
			<BR>Nivel 6:
			<li>12% de recompensa para entregas de cargas frágeis</li>
		</ul>`,
	skills_page_fast_title: 'Entrega urgente',
	skills_page_fast_desc: `
		<p>Algumas vezes, as empresas precisam entregar algo rapidamente. Estes trabalhos colocam mais pressão sobre o motorista, o tempo de entrega é pequeno mas o pagamento compensa o desconforto.</p>
		<ul>
			Nivel 1:
			<li>Ofertas de trabalho de cargas urgentes</li>
			<li>2% de recompensa para entregas de cargas urgentes</li>
			<li>10% de bônus de experiência para entregas de cargas urgentes</li>
			<BR>Nivel 2:
			<li>4% de recompensa para entregas de cargas urgentes</li>
			<BR>Nivel 3:
			<li>6% de recompensa para entregas de cargas urgentes</li>
			<BR>Nivel 4:
			<li>8% de recompensa para entregas de cargas urgentes</li>
			<BR>Nivel 5:
			<li>10% de recompensa para entregas de cargas urgentes</li>
			<BR>Nivel 6:
			<li>12% de recompensa para entregas de cargas urgentes</li>
		</ul>`,

	loan_page_title: 'Banco',
	loan_page_desc: 'Faça empréstimos para investir na sua empresa (Máximo de empréstimos ativos: {0})',
	loan_page_pay: 'pague {0} por dia',
	loan_page_remaining: 'Restante: {0}',
	loan_page_daily_cost: 'Custo diário: {0}',
	loan_page_pay_off: 'Quitar empréstimo',

	party_page_title: 'Grupos',
	party_page_desc: 'Crie ou participe de um grupo para fazer entregas em conjunto com seus amigos.',
	party_page_create: 'Criar grupo',
	party_page_join: 'Entrar no grupo',
	party_page_name: 'Nome do Grupo*',
	party_page_subtitle: 'Descrição do Grupo*',
	party_page_password: 'Senha',
	party_page_password_confirm: 'Confirmar Senha',
	party_page_members: 'Quantidade de Membros*',
	party_page_finish_button: 'Concluir ({0} + {1})',
	party_page_finish_button_2: 'Concluir',
	party_page_password_mismatch: '* Senha incorreta',
	party_leader: 'Lider do grupo',
	party_finished_deliveries: 'Entregas finalizadas com o grupo: {0}',
	party_joined_time: 'No grupo desde: {0}',
	party_kick: 'Expulsar do grupo',
	party_quit: 'Sair do grupo',
	party_delete: 'Excluir grupo',
	
	str_fill_field:"Preencha este campo",
	str_invalid_value:"Valor inválido",
	str_more_than:"Deve ser maior ou igual a {0}",
	str_less_than:"Deve ser menor ou igual a {0}",

	bank_page_withdraw: 'Sacar dinheiro',
	bank_page_deposit: 'Depositar dinheiro',
	bank_page_placeholder: 'Valor',
	bank_page_loans: 'Empréstimos ativos:',
};