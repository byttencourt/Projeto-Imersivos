var lang = 'en'
var config = {};
window.addEventListener('message', function (event) {
	var item = event.data;
	var list_item = '';
	if (item.notification) {
		if (item.notification_type == "sucesso") {
			vt.successo(item.notification,{
				position: "top-right",
				duration: 8000
			});
		} else if (item.notification_type == "importante") {
			vt.importante(item.notification,{
				position: "top-right",
				duration: 8000
			});
		} else if (item.notification_type == "negado") {
			vt.erro(item.notification,{
				position: "top-right",
				duration: 8000
			});
		}
	} else if (item.showmenu) {
		config = item.dados.config;
		lang = item.dados.config.lang;
		var contracts = item.dados.trucker_available_contracts;
		var users = item.dados.trucker_users;
		var myTrucks = item.dados.trucker_trucks;
		var drivers = item.dados.trucker_drivers;
		var top_truckers = item.dados.top_truckers;
		var loans = item.dados.trucker_loans;
		var trucker_party_members = item.dados.trucker_party_members;
		var trucker_party = item.dados.trucker_party;

		if(item.update != true){
			// Open on first time
			$(".pages").css("display", "none");
			$(".main").css("display", "");
			$(".main-page").css("display", "block");
			$('.sidebar-navigation ul li').removeClass('active');
			$('#sidebar-1').addClass('active');
			openPage(0);

			$('#sidebar-ul').empty();
			$('#sidebar-ul').append(`
			<li id="sidebar-1" onclick="openPage(0)">
				<i class="fas fa-user-circle"></i>
				<span class="tooltip">${Lang[lang]['sidebar_profile']}</span>
			</li>
			<li onclick="openPage(1)">
				<i class="fas fa-truck-loading"></i>
				<span class="tooltip">${Lang[lang]['sidebar_jobs']}</span>
			</li>
			<li onclick="openPage(2)">
				<i class="fas fa-dolly-flatbed"></i>
				<span class="tooltip">${Lang[lang]['sidebar_jobs_2']}</span>
			</li>
			<li onclick="openPage(10)">
				<i class="fas fa-user-group"></i>
				<span class="tooltip">${Lang[lang]['sidebar_party']}</span>
			</li>
			<li onclick="openPage(3)">
				<i class="fas fa-medal"></i>
				<span class="tooltip">${Lang[lang]['sidebar_skills']}</span>
			</li>
			<li onclick="openPage(4)">
				<i class="fas fa-wrench"></i>
				<span class="tooltip">${Lang[lang]['sidebar_diagnostic']}</span>
			</li>
			<li onclick="openPage(5)">
				<i class="fas fa-shopping-cart"></i>
				<span class="tooltip">${Lang[lang]['sidebar_dealership']}</span>
			</li>
			<li onclick="openPage(6)">
				<i class="fas fa-truck"></i>
				<span class="tooltip">${Lang[lang]['sidebar_mytrucks']}</span>
			</li>
			<li onclick="openPage(7)">
				<i class="fas fa-user-plus"></i>
				<span class="tooltip">${Lang[lang]['sidebar_driver']}</span>
			</li>
			<li onclick="openPage(8)">
				<i class="fas fa-users"></i>
				<span class="tooltip">${Lang[lang]['sidebar_mydrivers']}</span>
			</li>
			<li onclick="openPage(9)">
				<i class="fas fa-university"></i>
				<span class="tooltip">${Lang[lang]['sidebar_bank']}</span>
			</li>
			<li onclick="closeUI()">
				<i class="fas fa-times"></i>
				<span class="tooltip">${Lang[lang]['sidebar_close']}</span>
			</li>
			`);
			$('#statistics-title-div').empty();
			$('#statistics-title-div').append(`
				<h4 class="text-uppercase">${Lang[lang]['statistics_page_title']}</h4>
				<p>${Lang[lang]['statistics_page_desc']}</p>
			`);
			$('#profile-money-span').empty();
			$('#profile-money-span').append(Lang[lang]['statistics_page_money']);
			$('#profile-money-earned-span').empty();
			$('#profile-money-earned-span').append(Lang[lang]['statistics_page_money_earned']);
			$('#profile-deliveries-span').empty();
			$('#profile-deliveries-span').append(Lang[lang]['statistics_page_deliveries']);
			$('#profile-distance-traveled-span').empty();
			$('#profile-distance-traveled-span').append(Lang[lang]['statistics_page_distance']);
			$('#profile-exp-1-span').empty();
			$('#profile-exp-1-span').append(Lang[lang]['statistics_page_exp']);
			$('#profile-skill-points-span').empty();
			$('#profile-skill-points-span').append(Lang[lang]['statistics_page_skill']);
			$('#profile-trucks-span').empty();
			$('#profile-trucks-span').append(Lang[lang]['statistics_page_trucks']);
			$('#profile-drivers-span').empty();
			$('#profile-drivers-span').append(Lang[lang]['statistics_page_drivers']);
			$('#top-truckers-title-div').empty();
			$('#top-truckers-title-div').append(`
				<h4 class="text-uppercase">${Lang[lang]['statistics_page_top_truckers']}</h4>
				<p>${Lang[lang]['statistics_page_top_truckers_desc']}</p>
			`);
			$('#job-title-div').empty();
			$('#job-title-div').append(`
				<h4 class="text-uppercase">${Lang[lang]['contract_page_title']}</h4>
				<p>${Lang[lang]['contract_page_desc']}</p>
			`);

			$('#freight-title-div').empty();
			$('#freight-title-div').append(`
				<h4 class="text-uppercase">${Lang[lang]['contract_page_title_freight']}</h4>
				<p>${Lang[lang]['contract_page_desc_freight']}</p>
			`);
			$('#trucks-title-div').empty();
			$('#trucks-title-div').append(`
				<h4 class="text-uppercase">${Lang[lang]['trucks_page_title']}</h4>
				<p>${Lang[lang]['trucks_page_desc']}</p>
			`);

			$('#mydrivers-title-div').empty();
			$('#mydrivers-title-div').append(`
				<h4 class="text-uppercase">${Lang[lang]['mydrivers_page_title']}</h4>
				<p>${Lang[lang]['mydrivers_page_desc']}</p>
			`);

			$('#loan-title-div').empty();
			$('#loan-title-div').append(`
				<h4 class="text-uppercase">${Lang[lang]['loan_page_title']}</h4>
				<p>${Lang[lang]['loan_page_desc'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.max_emprestimo))}</p>
			`);
			

			$('#skills-title').empty();
			$('#skills-title').append(Lang[lang]['skills_page_title']);

			
			$('#bank-money-span').empty();
			$('#bank-money-span').append(Lang[lang]['bank_page_withdraw']);
			$('#input-deposit-money-div').empty();
			$('#input-deposit-money-div').append(`
				<input id="input-deposit-money" class="deposit-money" type="number" placeholder="${Lang[lang]['bank_page_placeholder']}">
				<button onclick="depositMoney()" class="btn btn-blue btn-darken-2 white deposit-money-btn">${Lang[lang]['bank_page_deposit']}</button>
			`);
			$('#active-loans-title').empty();
			$('#active-loans-title').append(`<p>${Lang[lang]['bank_page_loans']}</p>`);

			$('#skills-description-1').empty();
			$('#skills-description-1').append(Lang[lang]['skills_page_description']);
			$('#skills-description-2').empty();
			$('#skills-description-2').append(Lang[lang]['skills_page_description']);
			$('#skills-description-3').empty();
			$('#skills-description-3').append(Lang[lang]['skills_page_description']);
			$('#skills-description-4').empty();
			$('#skills-description-4').append(Lang[lang]['skills_page_description']);
			$('#skills-description-5').empty();
			$('#skills-description-5').append(Lang[lang]['skills_page_description']);
			$('#product-type-title').empty();
			$('#product-type-title').append(Lang[lang]['skills_page_product_type_title']);
			$('#product-type-desc').empty();
			$('#product-type-desc').append(Lang[lang]['skills_page_product_type_description']);
			$('#distance-title').empty();
			$('#distance-title').append(Lang[lang]['skills_page_distance_title']);
			$('#distance-desc').empty();
			$('#distance-desc').append(Lang[lang]['skills_page_distance_description']);
			$('#valuable-skill-title').empty();
			$('#valuable-skill-title').append(Lang[lang]['skills_page_valuable_title']);
			$('#valuable-skill-desc').empty();
			$('#valuable-skill-desc').append(Lang[lang]['skills_page_valuable_desc']);
			$('#fragile-skill-title').empty();
			$('#fragile-skill-title').append(Lang[lang]['skills_page_fragile_title']);
			$('#fragile-skill-desc').empty();
			$('#fragile-skill-desc').append(Lang[lang]['skills_page_fragile_desc']);
			$('#fast-skill-title').empty();
			$('#fast-skill-title').append(Lang[lang]['skills_page_fast_title']);
			$('#fast-skill-desc').empty();
			$('#fast-skill-desc').append(Lang[lang]['skills_page_fast_desc']);

			var form = document.getElementById("party-form-create");
			form.style.opacity = "0";
			form.style.maxHeight = "0";
			form.style.fontSize = "0";
			form.style.position = "absolute"

			var formJoin = document.getElementById("party-form-join");
			formJoin.style.opacity = "0";
			formJoin.style.maxHeight = "0";
			formJoin.style.fontSize = "0";
			formJoin.style.position = "absolute"

			$('#party-form-container-create').empty();
			$('#party-form-container-create').append(`
				<input id="party-name" maxlength="30" class="input-party" name="name" type="text" placeholder="${Lang[lang]['party_page_name']}" oninput="InvalidMsg(this);" oninvalid="InvalidMsg(this);" required>
				<input id="party-desc" maxlength="300" class="input-party" name="desc" type="text" placeholder="${Lang[lang]['party_page_subtitle']}" oninput="InvalidMsg(this);" oninvalid="InvalidMsg(this);" required>
				<input id="party-password" maxlength="20" class="input-party input-pass" name="password" type="password" placeholder="${Lang[lang]['party_page_password']}" oninput="InvalidMsg(this);" oninvalid="InvalidMsg(this);">
				<input id="party-password-confirm" maxlength="20" class="input-party input-pass" name="password-confirm" type="password" placeholder="${Lang[lang]['party_page_password_confirm']}" oninput="InvalidMsg(this);" oninvalid="InvalidMsg(this);">
				<div class="ShowPasswordNotMatchesError" style="display:none;">${Lang[lang]['party_page_password_mismatch']}</div>
				<div class="party-members-container">
					<input id="party-members" max="${config.party.max_members}" style="margin-bottom: 0px;" name="members" class="input-party" type="number" placeholder="${Lang[lang]['party_page_members']}" oninput="InvalidMsg(this,1,${config.party.max_members});" oninvalid="InvalidMsg(this,1,${config.party.max_members});" required>
					<span>${new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(0)}</span>
				</div>
				<div class="ShowSubmitErrorCreate" style="display:none;"></div>
				<button class="btn btn-blue btn-darken-2 btn-send btn-block white submit-party-form" id="submit-party-form">${Lang[lang]['party_page_finish_button'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.party.price_to_create),new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(0))}</button>
			`);
			$('#party-create-btn').empty();
			$('#party-create-btn').append(`${Lang[lang]['party_page_create']}`);
			$('#party-join-btn').empty();
			$('#party-join-btn').append(`${Lang[lang]['party_page_join']}`);

			$('#party-form-container-join').empty();
			$('#party-form-container-join').append(`
				<input id="party-name-join" class="input-party" name="name" type="text" placeholder="${Lang[lang]['party_page_name']}" oninput="InvalidMsg(this);" oninvalid="InvalidMsg(this);" required>
				<input id="party-password-join" class="input-party input-pass" name="password" type="password" placeholder="${Lang[lang]['party_page_password']}" oninput="InvalidMsg(this);" oninvalid="InvalidMsg(this);">
				<div class="ShowSubmitErrorJoin" style="display:none;"></div>
				<button class="btn btn-blue btn-darken-2 btn-send btn-block white submit-party-form" id="submit-party-form-join">${Lang[lang]['party_page_finish_button_2']}</button>
			`);
		}

		$('#diagnostic-title-div').empty();
		$('#diagnostic-title-div').append(`
			<h4 class="text-uppercase">${Lang[lang]['diagnostic_page_title']} <small></small></h4>
			<p>${Lang[lang]['diagnostic_page_desc']}</p>
		`);
		$('#diagnostic-body').empty();
		$('#diagnostic-body').append(`
			<div class="media d-flex">
				<div class="media-body text-left">
					<h3 class="success">100 %</h3><span>${Lang[lang]['diagnostic_page_chassi']}</span>
				</div>
				<div class="align-self-center">
					<i class="fas fa-tools success font-large-2 float-right"></i>
				</div>
			</div>
			<div class="progress mt-1 mb-0" style="height: 7px;">
				<div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
			</div>
		`);
		$('#diagnostic-engine').empty();
		$('#diagnostic-engine').append(`
			<div class="media d-flex">
				<div class="media-body text-left">
					<h3 class="success">100 %</h3><span>${Lang[lang]['diagnostic_page_engine']}</span>
				</div>
				<div class="align-self-center">
					<i class="fas fa-tools success font-large-2 float-right"></i>
				</div>
			</div>
			<div class="progress mt-1 mb-0" style="height: 7px;">
				<div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
			</div>
		`);
		$('#diagnostic-transmission').empty();
		$('#diagnostic-transmission').append(`
			<div class="media d-flex">
				<div class="media-body text-left">
					<h3 class="success">100 %</h3><span>${Lang[lang]['diagnostic_page_transmission']}</span>
				</div>
				<div class="align-self-center">
					<i class="fas fa-tools success font-large-2 float-right"></i>
				</div>
			</div>
			<div class="progress mt-1 mb-0" style="height: 7px;">
				<div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
			</div>
		`);
		$('#diagnostic-wheels').empty();
		$('#diagnostic-wheels').append(`
			<div class="media d-flex">
				<div class="media-body text-left">
					<h3 class="success">100 %</h3><span>${Lang[lang]['diagnostic_page_wheels']}</span>
				</div>
				<div class="align-self-center">
					<i class="fas fa-tools success font-large-2 float-right"></i>
				</div>
			</div>
			<div class="progress mt-1 mb-0" style="height: 7px;">
				<div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
			</div>
		`);

		$('#new-contracts-1').empty();
		$('#new-contracts-1').append(Lang[lang]['new_contracts'].format(config.cooldown*2));
		$('#new-contracts-2').empty();
		$('#new-contracts-2').append(Lang[lang]['new_contracts'].format(config.cooldown*2));
		
		$('#profile-money').empty();
		$('#profile-money').append(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(users.money));
		$('#bank-money').empty();
		$('#bank-money').append(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(users.money));
		
		$('#profile-money-earned').empty();
		$('#profile-money-earned').append(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(users.total_earned));
		$('#profile-deliveries').empty();
		$('#profile-deliveries').append(users.finished_deliveries);
		$('#profile-exp-1').empty();
		$('#profile-exp-1').append(users.exp);
		$('#profile-exp-2').empty();
		var exp_r = 0
		if (users.exp >= config.required_xp_to_levelup[config.required_xp_to_levelup.length-1]){
			exp_r = 100;
		}else if (config.player_level == 0) {
			max = config.required_xp_to_levelup[config.player_level]
			exp = users.exp
			exp_r = Math.round((exp*100)/max);
		}else{
			for (const key in config.required_xp_to_levelup) {
				if(users.exp < config.required_xp_to_levelup[key]){
					max = config.required_xp_to_levelup[key] - config.required_xp_to_levelup[key-1]
					exp = users.exp - config.required_xp_to_levelup[key-1]
					exp_r = Math.round((exp*100)/max);
					if(exp_r >= 0){
						break;
					}
				}
			}
		}
		$('#profile-exp-2').append('<div class="progress-bar bg-amber accent-4" role="progressbar" style="width: ' + exp_r + '%" aria-valuenow="' + exp_r + '" aria-valuemin="0" aria-valuemax="100"></div>');
		$('#profile-distance-traveled').empty();
		$('#profile-distance-traveled').append(users.traveled_distance.toFixed(2) + 'km');
		$('#profile-skill-points').empty();
		$('#profile-skill-points').append(users.skill_points);
		$('#profile-trucks').empty();
		$('#profile-trucks').append(myTrucks.length);
		$('#profile-drivers').empty();
		var drivers_count = 0;
		for (const driver of drivers) {
			if(driver.user_id != null && driver.user_id != undefined){
				drivers_count++;
			}
		}
		$('#profile-drivers').append(drivers_count);

		$('#top-truckers-list').empty();
		var c = 1;
		var icon = "";
		for (const top_users of top_truckers) {
			if(c == 1){
				icon = "fa-medal amber accent-4 font-large-2";
			}else if(c == 2){
				icon = "fa-medal blue-grey lighten-3 font-large-1";
			}else if(c == 3){
				icon = "fa-medal bronze font-large-0";
			}else{
				icon = "fa-check-circle checkicon font-small-2";
			}
			$('#top-truckers-list').append(`
			<li class="d-flex justify-content-between">
				<div class="d-flex flex-row align-items-center"><i class="fas ` + icon + `"></i>
					<div class="ml-2">
						<h6 class="mb-0">` + top_users.name + ` ` + (top_users.firstname??'') + `</h6>
						<div class="d-flex flex-row mt-1 text-black-50 date-time">
							<div><i class="fas fa-route"></i></i><span class="ml-2">${Lang[lang]['top_trucker_distance_traveled'].format(top_users.traveled_distance.toFixed(2))}</span></div>
							<div class="ml-3"><i class="fas fa-chart-line"></i></i><span class="ml-2">${Lang[lang]['top_trucker_exp'].format(top_users.exp)}</span></div>
						</div>
					</div>
				</div>
			</li>`);
			c++;
		}
		

		$('#job-page-list').empty();
		$('#freight-page-list').empty();
		for (const contract of contracts) {
			list_item = `
			<ul class="list list-inline">
				<li class="d-flex justify-content-between">
					<div class="d-flex flex-row align-items-center"><i class="fas fa-check-circle checkicon"></i>
						<div class="ml-2">
							<h6 class="mb-0">` + contract.contract_name + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 date-time">
								<div><i class="fas fa-route"></i><span class="ml-2">${Lang[lang]['contract_page_distance'].format(contract.distance)}</span></div>
								<div class="ml-3"><i class="fas fa-coins"></i><span class="ml-2">${Lang[lang]['contract_page_reward'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(contract.reward))}</span></div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						<div class="d-flex flex-column mr-2">
							<div class="profile-image">
							`;
			if(contract.cargo_type == 1) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_explosive'] + '"><img class="rounded-circle" src="img/explosive-1.png" width="30"></div>';
			}else if(contract.cargo_type == 2) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_flammablegas'] + '"><img class="rounded-circle" src="img/flamable-2.png" width="30"></div>';
			}else if(contract.cargo_type == 3) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_flammableliquid'] + '"><img class="rounded-circle" src="img/flamable-3.png" width="30"></div>';
			}else if(contract.cargo_type == 4) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_flammablesolid'] + '"><img class="rounded-circle" src="img/flamable-4.png" width="30"></div>';
			}else if(contract.cargo_type == 5) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_toxic'] + '"><img class="rounded-circle" src="img/toxic-6.png" width="30"></div>';
			}else if(contract.cargo_type == 6) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_corrosive'] + '"><img class="rounded-circle" src="img/corrosive-8.png" width="30"></div>';
			}
			if(contract.fragile == 1) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_fragile'] + '"><img class="rounded-circle" src="img/fragile.png" width="30"></div>';
			}
			if(contract.valuable == 1) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_valuable'] + '"><img class="rounded-circle" src="img/valuable.png" width="30"></div>';
			}
			if(contract.fast == 1) {
				list_item += '<div data-tooltip="' + Lang[lang]['contract_page_cargo_urgent'] + '"><img class="rounded-circle" src="img/fast.png" width="30"></div>';
			}
			var partystart_btn = '';
			if (trucker_party != undefined) {
				partystart_btn = `<button onclick="startJob(${contract.contract_id},${contract.reward},${contract.distance},true)" type="button" class="btn btn-secondary btn-darken-2 white waves-effect waves-light">${Lang[lang]['contract_page_button_start_job_party']}</button>`
			}
			list_item += `
							</div>
						</div>
						<div class="btn-group" role="group">
							<button onclick="startJob(${contract.contract_id},${contract.reward},${contract.distance},false)" type="button" class="btn btn-blue btn-darken-2 white waves-effect waves-light">${Lang[lang]['contract_page_button_start_job']}</button>
							${partystart_btn}
						</div>
					</div>
				</li>
			</ul>
			`;
			if(contract.contract_type == 0) {
				$('#job-page-list').append(list_item);
			}else{
				$('#freight-page-list').append(list_item);
			}
		}
		
		$('#skills-desc').empty();
		$('#skills-desc').append(Lang[lang]['skills_page_desc'].format(users.skill_points));
		setSkill('distance',users.distance);
		setSkill('product_type',users.product_type);
		setSkill('valuable',users.valuable);
		setSkill('fragile',users.fragile);
		setSkill('fast',users.fast);

		$('#dealership-page-list').empty();
		list_item = `
			<div class="col-12 mt-3 mb-1">
				<h4 class="text-uppercase">${Lang[lang]['dealership_page_title']}</h4>
				<p>${Lang[lang]['dealership_page_desc']}</p>
			</div>`;

		for (const key in config.dealership) {
			truck = config.dealership[key];
			list_item += `
				<div class="card"> <img src="` + truck.img + `" class="card-img-top" width="100%">
					<div class="card-body pt-0 px-0">
						<div class="d-flex flex-row justify-content-between mb-0 mt-3 px-3"> <span class="text-muted">${Lang[lang]['dealership_page_truck']}</span>
							<h6>` + truck.name + `</h6>
						</div>
						<hr class="mt-2 mx-3">
						<div class="d-flex flex-row justify-content-between px-3 pb-4">
							<div class="d-flex flex-column"><span class="text-muted">${Lang[lang]['dealership_page_price']}</span></div>
							<div class="d-flex flex-column">
								<h5 class="mb-0">` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(truck.price) + `</h5>
							</div>
						</div>
						<div class="d-flex flex-row justify-content-between p-3 mid">
							<div class="d-flex flex-column"><small class="text-muted mb-1">${Lang[lang]['dealership_page_engine']}</small>
								<div class="d-flex flex-row"><img src="img/engine_icon.jpg" width="35px" height="25px">
									<div class="d-flex flex-column ml-1"><small class="ghj">` + truck.engine + `</small><small class="ghj">` + truck.transmission + `</small></div>
								</div>
							</div>
							<div class="d-flex flex-column"><small class="text-muted mb-2">${Lang[lang]['dealership_page_power']}</small>
								<div class="d-flex flex-row"><img src="img/power_icon.jpg">
									<h6 class="ml-1">${Lang[lang]['dealership_page_power_value'].format(truck.hp)}</h6>
								</div>
							</div>
						</div>
						<div class="mx-3 mt-3 mb-2"><button onclick="buyTruck('` + key + `')" type="button" class="btn btn-blue btn-darken-2 white btn-block"><small>${Lang[lang]['dealership_page_buy_button']}</small></button></div> <small class="d-flex justify-content-center text-muted">${Lang[lang]['dealership_page_bottom_text']}</small>
					</div>
				</div>
				`;
		}
		$('#dealership-page-list').append(list_item);

		$('#trucks-page-list').empty();
		list_item = "";
		for (const truck of myTrucks) {
			truck.body = truck.body/10;
			truck.engine = truck.engine/10;
			truck.transmission = truck.transmission/10;
			truck.wheels = truck.wheels/10;
			if(truck.driver == 0){
				$('#diagnostic-title-div').empty();
				$('#diagnostic-title-div').append(`
					<h4 class="text-uppercase">${Lang[lang]['diagnostic_page_title']} <small>(${config.dealership[truck.truck_name].name})</small></h4>
					<p>${Lang[lang]['diagnostic_page_desc']}</p>
				`);
				var color = "";
				
				if (truck.body > 80) {
					color = "success";
				}else if(truck.body > 40){
					color = "warning";
				}else{
					color = "danger";
				}
				$('#diagnostic-body').empty();
				$('#diagnostic-body').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.body + ` %</h3><span>${Lang[lang]['diagnostic_page_chassi']} (` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format((100-truck.body)*config.repair_price.body) + `)</span>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar bg-` + color + `" role="progressbar" style="width: ` + truck.body + `%" aria-valuenow="` + truck.body + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.engine > 80) {
					color = "success";
				}else if(truck.engine > 40){
					color = "warning";
				}else{
					color = "danger";
				}
				$('#diagnostic-engine').empty();
				$('#diagnostic-engine').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.engine + ` %</h3><span>${Lang[lang]['diagnostic_page_engine']} (` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format((100-truck.engine)*config.repair_price.engine) + `)</span>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar bg-` + color + `" role="progressbar" style="width: ` + truck.engine + `%" aria-valuenow="` + truck.engine + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.transmission > 80) {
					color = "success";
				}else if(truck.transmission > 40){
					color = "warning";
				}else{
					color = "danger";
				}
				$('#diagnostic-transmission').empty();
				$('#diagnostic-transmission').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.transmission + ` %</h3><span>${Lang[lang]['diagnostic_page_transmission']} (` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format((100-truck.transmission)*config.repair_price.transmission) + `)</span>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar bg-` + color + `" role="progressbar" style="width: ` + truck.transmission + `%" aria-valuenow="` + truck.transmission + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
				
				if (truck.wheels > 80) {
					color = "success";
				}else if(truck.wheels > 40){
					color = "warning";
				}else{
					color = "danger";
				}
				$('#diagnostic-wheels').empty();
				$('#diagnostic-wheels').append(`
					<div class="media d-flex">
						<div class="media-body text-left">
							<h3 class="` + color + `">` + truck.wheels + ` %</h3><span>${Lang[lang]['diagnostic_page_wheels']} (` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format((100-truck.wheels)*config.repair_price.wheels) + `)</span>
						</div>
						<div class="align-self-center">
							<i class="fas fa-tools ` + color + ` font-large-2 float-right"></i>
						</div>
					</div>
					<div class="progress mt-1 mb-0" style="height: 7px;">
						<div class="progress-bar bg-` + color + `" role="progressbar" style="width: ` + truck.wheels + `%" aria-valuenow="` + truck.wheels + `" aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				`);
			}
			list_item += `
				<li class="d-flex justify-content-between">
					<div class="d-flex flex-row align-items-center"><img src="` + config.dealership[truck.truck_name].img + `" class="img-radius img-width" alt="User-Profile-Image">
						<div class="ml-2">
							<h6 class="mb-0">` + config.dealership[truck.truck_name].name + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 date-time">
								<div>
									<i class="fas fa-tools"></i><span class="ml-2">${Lang[lang]['trucks_page_chassi']}: ` + truck.body + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-tools"></i><span class="ml-2">${Lang[lang]['trucks_page_engine']}: ` + truck.engine + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-tools"></i><span class="ml-2">${Lang[lang]['trucks_page_transmission']}: ` + truck.transmission + `%</span>
								</div>
								<div class="ml-3">
									<i class="fas fa-tools"></i><span class="ml-2">${Lang[lang]['trucks_page_wheels']}: ` + truck.wheels + `%</span>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						` + getMyTruckHTML(truck) + `
						<button onclick="sellTruck('` + truck.truck_id + `','` + truck.truck_name + `')" class="btn btn-red btn-accent-4 white">${Lang[lang]['trucks_page_sell_button']}</button>
					</div>
				</li>
				`;
		}
		$('#trucks-page-list').append(list_item);

		$('#recruitment-page-list').empty();
		$('#drivers-page-list').empty();
		list_item = `
			<div class="col-12 mt-3 mb-1">
				<h4 class="text-uppercase">${Lang[lang]['drivers_page_title']}</h4>
				<p>${Lang[lang]['drivers_page_desc']}</p>
			</div>
			`;
		for (const driver of drivers) {
			if (driver.user_id == null || driver.user_id == undefined){
				list_item += `
					<div class="card user-card">
						<div class="card-block">
							<div class="user-image">
								<img src="` + driver.img + `" class="img-radius" alt="User-Profile-Image">
							</div>
							<h6 class="m-t-25 m-b-10">` + driver.name + `</h6>
							<p class="text-muted">${Lang[lang]['drivers_page_hiring_price'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(driver.price))}</p>
							<hr>
							<p class="text-muted">${Lang[lang]['drivers_page_product_type']}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.product_type) + `
							</ul>
							<p class="text-muted">${Lang[lang]['drivers_page_distance']}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.distance) + `
							</ul>
							<p class="text-muted">${Lang[lang]['drivers_page_valuable']}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.valuable) + `
							</ul>
							<p class="text-muted">${Lang[lang]['drivers_page_fragile']}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.fragile) + `
							</ul>
							<p class="text-muted">${Lang[lang]['drivers_page_urgent']}</p>
							<ul class="list-unstyled activity-leval">
								` + getDriverLevelHTML(driver.fast) + `
							</ul>
							<div onclick="hireDriver('` + driver.driver_id + `')" class="mx-3 mt-3 mb-2"><button type="button" class="btn btn-blue btn-darken-2 white btn-block"><small>${Lang[lang]['drivers_page_hire_button']}</small></button></div>
						</div>
					</div>
					`;
			}else{
				$('#drivers-page-list').append(`
					<li class="d-flex justify-content-between">
						<div class="d-flex flex-row align-items-center">
							<img src="` + driver.img + `" class="img-radius img-width" alt="User-Profile-Image">
							<div class="ml-2">
								<h6 class="mb-0">` + driver.name + `</h6>
								<div class="d-flex flex-row mt-1 text-black-50 date-time">
									<div>
										<i class="fas fa-coins"></i><span class="ml-2">${Lang[lang]['drivers_page_hiring_price'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(driver.price))}</span>
									</div>
									<div class="ml-3">
										<i class="fas fa-medal"></i><span class="ml-2">${Lang[lang]['drivers_page_skills']}: ${Lang[lang]['drivers_page_product_type']} (` + driver.product_type + `) ${Lang[lang]['drivers_page_distance']} (` + driver.distance + `) ${Lang[lang]['drivers_page_valuable']} (` + driver.valuable + `) ${Lang[lang]['drivers_page_fragile']} (` + driver.fragile + `) ${Lang[lang]['drivers_page_urgent']} (` + driver.fast + `)</span>
									</div>
								</div>
							</div>
						</div>
						<div class="d-flex flex-row align-items-center">
							<div class="d-flex flex-column mr-2">
								<select id="select-truck" class="selectpicker form-control" onchange="setDriver(this.options[this.selectedIndex].getAttribute('driver_id'),this.options[this.selectedIndex].getAttribute('truck_id'));">
									` + getDriverAvailableTrucksHTML(myTrucks,driver,config) + `
								</select>
							</div> 
							<button onclick="fireDriver('` + driver.driver_id + `')" class="btn btn-red btn-accent-4 white">${Lang[lang]['drivers_page_fire_button']}</button>
						</div>
					</li>
				`);
			}
		}
		$('#recruitment-page-list').append(list_item);

		
		$('#loan-1').empty();
		list_item = '<h3 class="success darken-1">' + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.loans[0][0]) + '</h3><span>' + Lang[lang]['loan_page_pay'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.loans[0][1])) + '</span>';
		$('#loan-1').append(list_item);
		$('#loan-2').empty();
		list_item = '<h3 class="success darken-1">' + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.loans[1][0]) + '</h3><span>' + Lang[lang]['loan_page_pay'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.loans[1][1])) + '</span>';
		$('#loan-2').append(list_item);
		$('#loan-3').empty();
		list_item = '<h3 class="success darken-1">' + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.loans[2][0]) + '</h3><span>' + Lang[lang]['loan_page_pay'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.loans[2][1])) + '</span>';
		$('#loan-3').append(list_item);
		$('#loan-4').empty();
		list_item = '<h3 class="success darken-1">' + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.loans[3][0]) + '</h3><span>' + Lang[lang]['loan_page_pay'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.loans[3][1])) + '</span>';
		$('#loan-4').append(list_item);

		$('#loan-list').empty();
		for (const loan of loans) {
			list_item = `
				<li class="d-flex justify-content-between">
					<div class="d-flex flex-row align-items-center"><i class="fas fa-check-circle checkicon"></i>
						<div class="ml-2">
							<h6 class="mb-0">` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(loan.loan) + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 date-time">
								<div><i class="fas fa-coins"></i></i><span class="ml-2">${Lang[lang]['loan_page_remaining'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(loan.remaining_amount))}</span></div>
								<div class="ml-3"><i class="fas fa-coins"></i></i><span class="ml-2">${Lang[lang]['loan_page_daily_cost'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(loan.day_cost)))}</span></div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						<button onclick="payLoan('` + loan.id + `')" class="btn btn-red btn-accent-4 white">${Lang[lang]['loan_page_pay_off']}</button>
					</div>
				</li>
			`;
			$('#loan-list').append(list_item);
		}
		
		$('#party-title-div').empty();
		$('#party-title-div').append(`
			<h4 class="text-uppercase">${Lang[lang]['party_page_title']}</h4>
			<p>${Lang[lang]['party_page_desc']}</p>
		`);

		if (trucker_party != undefined) {
			var quit_str = `<button onclick="quitParty()" class="btn btn-red btn-accent-4 white">${Lang[lang]['party_quit']}</button>`;
			if (trucker_party.owner == 1) {
				quit_str = `<button onclick="deleteParty()" class="btn btn-red btn-accent-4 white">${Lang[lang]['party_delete']}</button>`;
			}
			$('#party-title-div').empty();
			$('#party-title-div').append(`
				<div class="party-title-container">
					<h4 class="text-uppercase">${trucker_party.name} <small>(${trucker_party.members_count}/${trucker_party.members})</small></h4>
					${quit_str}
				</div>
				<p>${trucker_party.description}</p>
			`);

			$("#party-form-container-base").css("display", "none");
			$("#party-container-members").css("display", "");
			
			$('#party-container-members').empty();
			for (const member of trucker_party_members) {
				var kick_str = '';
				if (trucker_party.owner == 1 && trucker_party.user_id != member.user_id) {
					kick_str = `<button onclick="kickParty(\'${member.user_id}\')" class="btn btn-red btn-accent-4 white">${Lang[lang]['party_kick']}</button>`;
				}
				var owner_str = '';
				if (member.owner) {
					owner_str = `<div data-tooltip="${Lang[lang]['party_leader']}"><img class="rounded-circle" src="img/crown.png" width="30"></div>`;
				}
				var online_str = 'fas fa-xmark-circle xicon';
				if (member.online) {
					online_str = 'fas fa-check-circle checkicon';
				}
				$('#party-container-members').append(`
					<ul class="list list-inline">
						<li class="d-flex justify-content-between">
							<div class="d-flex flex-row align-items-center"><i class="${online_str}" aria-hidden="true"></i>
								<div class="ml-2">
									<h6 class="mb-0">${member.name} ${(member.firstname??'')}</h6>
									<div class="d-flex flex-row mt-1 text-black-50 date-time">
										<div>
											<i class="fas fa-route"></i><span class="ml-2">${Lang[lang]['party_finished_deliveries'].format(member.finished_deliveries)}</span>
										</div>
										<div class="ml-3">
											<i class="fas fa-clock"></i><span class="ml-2">${Lang[lang]['party_joined_time'].format(timeConverter(member.joined_at,config.format.location))}</span>
										</div>
									</div>
								</div>
							</div>
							<div class="d-flex flex-row align-items-center">
								<div class="d-flex flex-column mr-2">
									<div class="profile-image">
										${owner_str}
									</div>
								</div>
								${kick_str}
							</div>
						</li>
					</ul>
				`);
			}
		} else {
			$("#party-form-container-base").css("display", "");
			$("#party-container-members").css("display", "none");
		}

		$(function () {
			$(".input-pass").blur(function () {
				var PasswordVal=$('#party-password').val();
				var ConfirmPasswordVal=$('#party-password-confirm').val();
				if(PasswordVal != ConfirmPasswordVal && ConfirmPasswordVal.length > 0 && PasswordVal.length > 0) {
					$('.ShowPasswordNotMatchesError').show();
				} else {
					$('.ShowPasswordNotMatchesError').hide();
				}
			});
			$("#party-members").keyup(function () {
				if ($(this).val() > config.party.max_members) {
					this.value = config.party.max_members;
				}
				if ($(this).val() && $(this).val() <= 0) {
					this.value = 1;
				}
				$('.party-members-container span').text(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format($(this).val() * config.party.price_per_member));
				$('#submit-party-form').text(Lang[lang]['party_page_finish_button'].format(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(config.party.price_to_create),new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format($(this).val() * config.party.price_per_member)));
			});
		});
	}
	if (item.hidemenu){
		$(".main").css("display", "none");
	}
});

function log(d){
	console.log(JSON.stringify(d));
}

function getDriverLevelHTML(value){
	var html = "";
	for (var i = 1; i <= 6; i++) {
		if(i <= value){
			html += '<li class="actived"></li>';
		}else{
			html += '<li></li>';
		}
	}
	return html;
}

function getDriverAvailableTrucksHTML(myTrucks,driver,config){
	var html = "";
	var i = 1;
	var has_truck = null;
	for (const truck of myTrucks) {
		if (truck.driver == driver.driver_id) {
			has_truck = truck.truck_id;
			html += '<option selected="selected">' + config.dealership[truck.truck_name].name +'</option>';
		}else{
			if (truck.driver == null){
				html += '<option truck_id="' + truck.truck_id + '" driver_id="' + driver.driver_id + '">' + config.dealership[truck.truck_name].name +'</option>';
			}
		}
	}
	if (has_truck == null) {
		html = '<option selected="selected">' + Lang[lang]['drivers_page_pick_truck'] + '</option>' + html;
	}else{
		html = '<option driver_id="' + driver.driver_id + '">' + Lang[lang]['drivers_page_pick_truck'] + '</option>' + html;
	}
	return html;
}

function getMyTruckHTML(truck){
	return truck.driver==0 ? `<button onclick="spawnTruck(` + truck.truck_id + `)" class="btn btn-blue btn-darken-2 white white mr-2">${Lang[lang]['trucks_page_spawn']}</button> <button onclick="setDriver(null,'` + truck.truck_id + `')" class="btn btn-blue btn-darken-2 white white mr-2">${Lang[lang]['trucks_page_remove']}</button>` : `<button onclick="setDriver('0','` + truck.truck_id + `')" class="btn btn-blue btn-darken-2 white white mr-2">${Lang[lang]['trucks_page_select']}</button>`
}

function setSkill(id,newValue){
	$('#'+id).empty();
	for (var i = 1; i <= 6; i++) {
		if(i <= newValue){
			if(i == 1){
				$('#'+id).append('<div class="steps"> <span><i class="fas fa-check"></i></span> </div>');
			}else{
				$('#'+id).append('<span class="line"></span><div class="steps"> <span><i class="fas fa-check"></i></span> </div>');
			}
		}else{
			if(i == 1){
				$('#'+id).append('<div class="redsteps" onclick="upgradeSkill(\''+id+'\','+i+')"> <span class="font-weight-bold">'+i+'</span> </div>');
			}else{
				$('#'+id).append('</div> <span class="redline"></span><div class="redsteps" onclick="upgradeSkill(\''+id+'\','+i+')"> <span class="font-weight-bold">'+i+'</span>');
			}
		}
	}
}

function openPage(pageN){
	if(pageN == 0){
		$(".pages").css("display", "none");
		$(".main-page").css("display", "block");
	}
	if(pageN == 1){
		$(".pages").css("display", "none");
		$(".job-page").css("display", "block");
	}
	if(pageN == 2){
		$(".pages").css("display", "none");
		$(".freight-page").css("display", "block");
	}
	if(pageN == 3){
		$(".pages").css("display", "none");
		$(".skills-page").css("display", "block");
	}
	if(pageN == 4){
		$(".pages").css("display", "none");
		$(".diagnostic-page").css("display", "block");
	}
	if(pageN == 5){
		$(".pages").css("display", "none");
		$(".dealership-page").css("display", "block");
	}
	if(pageN == 6){
		$(".pages").css("display", "none");
		$(".trucks-page").css("display", "block");
	}
	if(pageN == 7){
		$(".pages").css("display", "none");
		$(".recruitment-page").css("display", "block");
	}
	if(pageN == 8){
		$(".pages").css("display", "none");
		$(".drivers-page").css("display", "block");
	}
	if(pageN == 9){
		$(".pages").css("display", "none");
		$(".bank-page").css("display", "block");
	}
	if(pageN == 10){
		$(".pages").css("display", "none");
		$(".party-page").css("display", "block");
	}
}

function createParty() {
	var form = document.getElementById("party-form-create");
	var form2 = document.getElementById("party-form-join");
	if (form.style.opacity === "1" || form2.style.opacity === "1") {
		form.style.opacity = "0";
		form.style.maxHeight = "0";
		form.style.fontSize = "0";

		form2.style.opacity = "0";
		form2.style.maxHeight = "0";
		form2.style.fontSize = "0";
		setTimeout(function(){ form.style.position = "absolute" }, 300);
		setTimeout(function(){ form2.style.position = "absolute" }, 300);

	} else {
		form2.style.opacity = "0";
		form2.style.maxHeight = "0";
		form2.style.fontSize = "0";
		
		form.style.opacity = "1";
		form.style.maxHeight = "1000px";
		form.style.fontSize = "15px";
		form.style.position = "";
	}
}

function joinParty() {
	var form = document.getElementById("party-form-join");
	var form2 = document.getElementById("party-form-create");
	if (form.style.opacity === "1" || form2.style.opacity === "1") {
		form.style.opacity = "0";
		form.style.maxHeight = "0";
		form.style.fontSize = "0";

		form2.style.opacity = "0";
		form2.style.maxHeight = "0";
		form2.style.fontSize = "0";
		setTimeout(function(){ form.style.position = "absolute" }, 300);
		setTimeout(function(){ form2.style.position = "absolute" }, 300);

	} else {
		form2.style.opacity = "0";
		form2.style.maxHeight = "0";
		form2.style.fontSize = "0";

		form.style.opacity = "1";
		form.style.maxHeight = "1000px";
		form.style.fontSize = "15px";
		form.style.position = "";
	}
	
}

function InvalidMsg(textbox,min,max) {
	if (textbox.value == '') {
		textbox.setCustomValidity(Lang[config.lang]['str_fill_field']);
	}
	else if(textbox.validity.typeMismatch){
		textbox.setCustomValidity(Lang[config.lang]['str_invalid_value']);
	}
	else if(textbox.validity.rangeUnderflow){
		textbox.setCustomValidity(Lang[config.lang]['str_more_than'].format(min));
	}
	else if(textbox.validity.rangeOverflow){
		textbox.setCustomValidity(Lang[config.lang]['str_less_than'].format(max));
	}
	else if(textbox.validity.stepMismatch){
		textbox.setCustomValidity(Lang[config.lang]['str_invalid_value']);
	} else {
		textbox.setCustomValidity('');
	}
	return true;
}


$(document).ready( function() {
	$("#party-form-create").on('submit', function(e){
		e.preventDefault();
		var form = $('#party-form-create').serializeArray();
		if(form[2].value !== form[3].value)	{
			$('.ShowPasswordNotMatchesError').show();
			return;
		}
		post("createParty",{name:form[0].value,desc:form[1].value,pass:form[2].value,cpass:form[3].value,members:form[4].value})
	});

	$("#party-form-join").on('submit', function(e){
		e.preventDefault();
		var form = $('#party-form-join').serializeArray();
		post("joinParty",{name:form[0].value,pass:form[1].value})
	});
})

function closeUI(){
	post("close","")
}
function startJob(contract_id,reward,distance,party){
	post("startJob",{id:contract_id,reward:reward,distance:distance,party:party})
}
function sellTruck(truck_id,truck_name){
	post("sellTruck",{truck_id:truck_id,truck_name:truck_name})
}
function buyTruck(truck_name){
	post("buyTruck",{truck_name:truck_name})
}
function spawnTruck(truck_id){
	post("spawnTruck",{truck_id:truck_id})
}
function fireDriver(driver_id){
	post("fireDriver",{driver_id:driver_id})
}
function hireDriver(driver_id){
	post("hireDriver",{driver_id:driver_id})
}
function upgradeSkill(id,i){
	post("upgradeSkill",{id:id,value:i})
}
function repairTruck(id){
	post("repairTruck",{id:id})
}
function setDriver(driver_id,truck_id){
	post("setDriver",{driver_id:driver_id,truck_id:truck_id})
}
function loan(loan_id){
	post("loan",{loan_id:loan_id})
}
function payLoan(loan_id){
	post("payLoan",{loan_id:loan_id})
}
function depositMoney(){
	var amount = document.getElementById('input-deposit-money').value;
	document.getElementById('input-deposit-money').value = null;
	post("depositMoney",{amount:amount})
}
function withdrawMoney(){
	post("withdrawMoney",{})
}
function kickParty(user_id){
	post("kickParty",{user_id:user_id})
}
function deleteParty(){
	post("deleteParty",{})
}
function quitParty(){
	post("quitParty",{})
}

document.onkeyup = function(data){
	if (data.which == 27){
		if ($(".main").is(":visible")){
			post("close","")
		}
	}
};

$('.sidebar-navigation ul li').on('click', function() {
	$('li').removeClass('active');
	$(this).addClass('active');
});

var coll = document.getElementsByClassName("collapsible");
var i;
for (i = 0; i < coll.length; i++) {
	coll[i].addEventListener("click", function() {
		this.classList.toggle("active");
		var content = this.nextElementSibling;
		if (content.style.display === "block") {
			content.style.display = "none";
		} else {
			content.style.display = "block";
		}
	});
}

if (!String.prototype.format) {
    String.prototype.format = function() {
        var args = arguments;
        return this.replace(/{(\d+)}/g, function(match, number) { 
        return typeof args[number] != 'undefined'
            ? args[number]
            : match
        ;
        });
    };
}

function post(name,data){
	$.post("http://truck_logistics/"+name,JSON.stringify(data),function(datab){
		if (datab != "ok"){
			console.log(datab);
		}
	});
}

function timeConverter(UNIX_timestamp,locale){
	var a = new Date(UNIX_timestamp * 1000);
	var time = a.toLocaleString(locale);
	return time;
}

// Notification
(() => {
	const toastPosition = {
		TopLeft: "top-left",
		TopCenter: "top-center",
		TopRight: "top-right",
		BottomLeft: "bottom-left",
		BottomCenter: "bottom-center",
		BottomRight: "bottom-right"
	}

	const toastPositionIndex = [
		[toastPosition.TopLeft, toastPosition.TopCenter, toastPosition.TopRight],
		[toastPosition.BottomLeft, toastPosition.BottomCenter, toastPosition.BottomRight]
	]

	const svgs = {
		successo: '<svg viewBox="0 0 426.667 426.667" width="18" height="18"><path d="M213.333 0C95.518 0 0 95.514 0 213.333s95.518 213.333 213.333 213.333c117.828 0 213.333-95.514 213.333-213.333S331.157 0 213.333 0zm-39.134 322.918l-93.935-93.931 31.309-31.309 62.626 62.622 140.894-140.898 31.309 31.309-172.203 172.207z" fill="#6ac259"></path></svg>',
		aviso: '<svg viewBox="0 0 310.285 310.285" width=18 height=18> <path d="M264.845 45.441C235.542 16.139 196.583 0 155.142 0 113.702 0 74.743 16.139 45.44 45.441 16.138 74.743 0 113.703 0 155.144c0 41.439 16.138 80.399 45.44 109.701 29.303 29.303 68.262 45.44 109.702 45.44s80.399-16.138 109.702-45.44c29.303-29.302 45.44-68.262 45.44-109.701.001-41.441-16.137-80.401-45.439-109.703zm-132.673 3.895a12.587 12.587 0 0 1 9.119-3.873h28.04c3.482 0 6.72 1.403 9.114 3.888 2.395 2.485 3.643 5.804 3.514 9.284l-4.634 104.895c-.263 7.102-6.26 12.933-13.368 12.933H146.33c-7.112 0-13.099-5.839-13.345-12.945L128.64 58.594c-.121-3.48 1.133-6.773 3.532-9.258zm23.306 219.444c-16.266 0-28.532-12.844-28.532-29.876 0-17.223 12.122-30.211 28.196-30.211 16.602 0 28.196 12.423 28.196 30.211.001 17.591-11.456 29.876-27.86 29.876z" fill="#FFDA44" /> </svg>',
		importante: '<svg viewBox="0 0 23.625 23.625" width=18 height=18> <path d="M11.812 0C5.289 0 0 5.289 0 11.812s5.289 11.813 11.812 11.813 11.813-5.29 11.813-11.813S18.335 0 11.812 0zm2.459 18.307c-.608.24-1.092.422-1.455.548a3.838 3.838 0 0 1-1.262.189c-.736 0-1.309-.18-1.717-.539s-.611-.814-.611-1.367c0-.215.015-.435.045-.659a8.23 8.23 0 0 1 .147-.759l.761-2.688c.067-.258.125-.503.171-.731.046-.23.068-.441.068-.633 0-.342-.071-.582-.212-.717-.143-.135-.412-.201-.813-.201-.196 0-.398.029-.605.09-.205.063-.383.12-.529.176l.201-.828c.498-.203.975-.377 1.43-.521a4.225 4.225 0 0 1 1.29-.218c.731 0 1.295.178 1.692.53.395.353.594.812.594 1.376 0 .117-.014.323-.041.617a4.129 4.129 0 0 1-.152.811l-.757 2.68a7.582 7.582 0 0 0-.167.736 3.892 3.892 0 0 0-.073.626c0 .356.079.599.239.728.158.129.435.194.827.194.185 0 .392-.033.626-.097.232-.064.4-.121.506-.17l-.203.827zm-.134-10.878a1.807 1.807 0 0 1-1.275.492c-.496 0-.924-.164-1.28-.492a1.57 1.57 0 0 1-.533-1.193c0-.465.18-.865.533-1.196a1.812 1.812 0 0 1 1.28-.497c.497 0 .923.165 1.275.497.353.331.53.731.53 1.196 0 .467-.177.865-.53 1.193z" fill="#006DF0" /> </svg>',
		erro: '<svg viewBox="0 0 51.976 51.976" width=18 height=18> <path d="M44.373 7.603c-10.137-10.137-26.632-10.138-36.77 0-10.138 10.138-10.137 26.632 0 36.77s26.632 10.138 36.77 0c10.137-10.138 10.137-26.633 0-36.77zm-8.132 28.638a2 2 0 0 1-2.828 0l-7.425-7.425-7.778 7.778a2 2 0 1 1-2.828-2.828l7.778-7.778-7.425-7.425a2 2 0 1 1 2.828-2.828l7.425 7.425 7.071-7.071a2 2 0 1 1 2.828 2.828l-7.071 7.071 7.425 7.425a2 2 0 0 1 0 2.828z" fill="#D80027" /> </svg>'
	}

	const styles = `
		.vt-container {
			position: fixed;
			width: 100%;
			height: 100vh;
			top: 0;
			left: 0;
			z-index: 9999;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
			pointer-events: none;
		}

		.vt-row {
			display: flex;
			justify-content: space-between;
		}

		.vt-col {
			flex: 1;
			margin: 10px 20px;
			display: flex;
			flex-direction: column;
			align-items: center;
		}

		.vt-col.top-left,
		.vt-col.bottom-left {
			align-items: flex-start;
		}

		.vt-col.top-right,
		.vt-col.bottom-right {
			align-items: flex-end;
		}

		.vt-card {
			display: flex;
			justify-content: center;
			align-items: center;
			padding: 12px 20px;
			background-color: #fff;
			box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
			color: #000;
			border-radius: 4px;
			margin: 0px;
			transition: 0.3s all ease-in-out;
			pointer-events: all;
			border-left: 3px solid #8b8b8b;
			cursor: pointer;
		}

		.vt-card.successo {
			border-left: 3px solid #6ec05f;
		}

		.vt-card.aviso {
			border-left: 3px solid #fed953;
		}

		.vt-card.importante {
			border-left: 3px solid #1271ec;
		}

		.vt-card.erro {
			border-left: 3px solid #d60a2e;
		}

		.vt-card .text-group {
			margin-left: 15px;
		}

		.vt-card h4 {
			margin: 0;
			margin-bottom: 10px;
			font-size: 16px;
			font-weight: 500;
		}

		.vt-card p {
			margin: 0;
			font-size: 14px;
		}
	`

	const styleSheet = document.createElement("style")
	styleSheet.innerText = styles.replace((/  |\r\n|\n|\r/gm), "")
	document.head.appendChild(styleSheet)

	const vtContainer = document.createElement("div")
	vtContainer.className = "vt-container"

	for (const ri of [0, 1]) {
		const row = document.createElement("div")
		row.className = "vt-row"

		for (const ci of [0, 1, 2]) {
			const col = document.createElement("div")
			col.className = `vt-col ${toastPositionIndex[ri][ci]}`

			row.appendChild(col)
		}

		vtContainer.appendChild(row)
	}

	document.body.appendChild(vtContainer)

	window.vt = {
		options: {
			title: undefined,
			position: toastPosition.TopCenter,
			duration: 10000,
			closable: true,
			focusable: true,
			callback: undefined
		},
		successo(message, options) {
			show(message, options, "successo")
		},
		importante(message, options) {
			show(message, options, "importante")
		},
		aviso(message, options) {
			show(message, options, "aviso")
		},
		erro(message, options) {
			show(message, options, "erro")
		}
	}

	function show(message = "", options, type) {
		options = { ...window.vt.options, ...options }

		const col = document.getElementsByClassName(options.position)[0]

		const vtCard = document.createElement("div")
		vtCard.className = `vt-card ${type}`
		vtCard.innerHTML += svgs[type]
		vtCard.options = {
			...options, ...{
				message,
				type: type,
				yPos: options.position.indexOf("top") > -1 ? "top" : "bottom",
				isFocus: false
			}
		}

		setVTCardContent(vtCard)
		setVTCardIntroAnim(vtCard)
		setVTCardBindEvents(vtCard)
		autoDestroy(vtCard)

		

		col.appendChild(vtCard)
	}

	function setVTCardContent(vtCard) {
		const textGroupDiv = document.createElement("div")

		textGroupDiv.className = "text-group"

		if (vtCard.options.title) {
			textGroupDiv.innerHTML = `<h4>${vtCard.options.title}</h4>`
		}

		textGroupDiv.innerHTML += `<p>${vtCard.options.message}</p>`

		vtCard.appendChild(textGroupDiv)
	}

	function setVTCardIntroAnim(vtCard) {
		vtCard.style.setProperty(`margin-${vtCard.options.yPos}`, "-15px")
		vtCard.style.setProperty("opacity", "0")

		setTimeout(() => {
			vtCard.style.setProperty(`margin-${vtCard.options.yPos}`, "15px")
			vtCard.style.setProperty("opacity", "1")
		}, 50)
	}

	function setVTCardBindEvents(vtCard) {
		vtCard.addEventListener("click", () => {
			if (vtCard.options.closable) {
				destroy(vtCard)
			}
		})

		vtCard.addEventListener("mouseover", () => {
			vtCard.options.isFocus = vtCard.options.focusable
		})

		vtCard.addEventListener("mouseout", () => {
			vtCard.options.isFocus = false
			autoDestroy(vtCard, vtCard.options.duration)
		})
	}

	function destroy(vtCard) {
		vtCard.style.setProperty(`margin-${vtCard.options.yPos}`, `-${vtCard.offsetHeight}px`)
		vtCard.style.setProperty("opacity", "0")

		setTimeout(() => {
			if(typeof x !== "undefined"){
				vtCard.parentNode.removeChild(v)

				if (typeof vtCard.options.callback === "function") {
					vtCard.options.callback()
				}
			}
		}, 500)
	}

	function autoDestroy(vtCard) {
		if (vtCard.options.duration !== 0) {
			setTimeout(() => {
				if (!vtCard.options.isFocus) {
					destroy(vtCard)
				}
			}, vtCard.options.duration)
		}
	}
})()