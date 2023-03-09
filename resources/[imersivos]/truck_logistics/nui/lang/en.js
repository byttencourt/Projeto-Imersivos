// To add a new lang file you must declare the file on the last lines of index.html like: <script src="lang/en.js" type="text/javascript"></script>
if (Lang == undefined) {
	var Lang = [];
}
Lang['en'] = {
	new_contracts: 'New contracts each {0} min',
	top_trucker_distance_traveled: 'Traveled distance: {0}km',
	top_trucker_exp: 'EXP: {0}',
	sidebar_profile: 'Your Profile',
	sidebar_jobs: 'Quick Jobs',
	sidebar_jobs_2: 'Freight Jobs',
	sidebar_skills: 'Skills',
	sidebar_diagnostic: 'Diagnostic',
	sidebar_dealership: 'Dealership',
	sidebar_mytrucks: 'Trucks',
	sidebar_driver: 'Recruitment agency',
	sidebar_mydrivers: 'Drivers',
	sidebar_bank: 'Bank',
	sidebar_party: 'Party',
	sidebar_close: 'Close',

	statistics_page_title: 'Statistics',
	statistics_page_desc: 'Statistics of your truck company',
	statistics_page_money: 'Money',
	statistics_page_money_earned: 'Total Money Earned',
	statistics_page_deliveries: 'Finished Deliveries',
	statistics_page_distance: 'Distance Traveled',
	statistics_page_exp: 'Total EXP earned',
	statistics_page_skill: 'Skill Points',
	statistics_page_trucks: 'Trucks',
	statistics_page_drivers: 'Drivers',
	statistics_page_top_truckers: 'Top drivers',
	statistics_page_top_truckers_desc: 'Top 10 truck drivers list in the city',

	contract_page_title: 'Quick Jobs',
	contract_page_desc: 'Here you don\'t need a truck. The company will provide everything for you',
	contract_page_title_freight: 'Freights',
	contract_page_desc_freight: 'Earn more money by freight with your own truck',
	contract_page_distance: 'Distance: {0}km',
	contract_page_reward: 'Reward: {0}',
	contract_page_cargo_explosive: 'Explosives',
	contract_page_cargo_flammablegas: 'Flammable Gases',
	contract_page_cargo_flammableliquid: 'Flammable liquids',
	contract_page_cargo_flammablesolid: 'Flammable solids',
	contract_page_cargo_toxic: 'Toxic Substances',
	contract_page_cargo_corrosive: 'Corrosive substances',
	contract_page_cargo_fragile: 'Fragile cargo',
	contract_page_cargo_valuable: 'Valuable cargo',
	contract_page_cargo_urgent: 'Urgent cargo',
	contract_page_button_start_job: 'Start Job',
	contract_page_button_start_job_party: 'Start in Group',

    skills_page_title: 'Skills',
	skills_page_desc: 'Upgrade your skills to get better jobs (Skill points avaliable: {0})',

	dealership_page_title: 'Dealership',
	dealership_page_desc: 'Buy more trucks to you and your drivers',
	dealership_page_truck: 'Truck',
	dealership_page_price: 'Price',
	dealership_page_engine: 'ENGINE',
	dealership_page_power: 'HORSEPOWER',
	dealership_page_power_value: '{0} hp',
	dealership_page_buy_button: 'BUY',
	dealership_page_bottom_text: '*Legal Disclaimer',

    diagnostic_page_title: 'Diagnostic',
	diagnostic_page_desc: 'Fix your truck to do jobs (change your truck by clicking on select button on Trucks page)',
	diagnostic_page_chassi: 'Fix Body',
	diagnostic_page_engine: 'Fix Engine',
	diagnostic_page_transmission: 'Fix Transmission',
	diagnostic_page_wheels: 'Fix Wheels',

    trucks_page_title: 'Trucks',
	trucks_page_desc: 'See all your trucks here. You can setup a driver for each one',
	trucks_page_chassi: 'Body',
	trucks_page_engine: 'Engine',
	trucks_page_transmission: 'Transmission',
	trucks_page_wheels: 'Wheels',
	trucks_page_sell_button: 'Sell Truck',
	trucks_page_spawn: 'Spawn Truck',
	trucks_page_remove: 'Deselect',
	trucks_page_select: 'Select Truck',

    mydrivers_page_title: 'Drivers',
	mydrivers_page_desc: 'See all your drivers here. You can setup a truck for each one',

	drivers_page_title: 'Recruitment Agency',
	drivers_page_desc: 'Recruit new drivers to work for your company',
	drivers_page_hiring_price: 'Price: {0}',
	drivers_page_skills: 'Skills',
	drivers_page_product_type: 'Product Type',
	drivers_page_distance: 'Distance',
	drivers_page_valuable: 'Valuable Cargo',
	drivers_page_fragile: 'Fragile Cargo',
	drivers_page_urgent: 'On-time delivery',
	drivers_page_hire_button: 'HIRE',
	drivers_page_fire_button: 'Fire Driver',
	drivers_page_pick_truck: 'Select a Truck',

	skills_page_description: 'Description',
	skills_page_product_type_title: 'Product Type',
	skills_page_product_type_description: `
		<p>The transport of dangerous goods requires well-trained professionals. Purchase ADR certificates to release new types of cargo.</p>
		<ul>
			Class 1 - Explosives:
			<li>Release loads of dynamite, fireworks and ammo</li>
			<BR> Class 2 - Gases:
			<li> Release charges of flammable, non-flammable and poisonous gases </li>
			<BR> Class 3 - Flammable liquids:
			<li> Release loads of dangerous fuels such as gasoline, diesel and kerosene </li>
			<BR> Class 4 - Flammable solids:
			<li> Release loads of nitrocellulose, megnium, safety matches, spontaneous combustion aluminum, white phosphorus, among others </li>
			<BR> Class 6 - Toxic Substances
			<li> Release loads of poisons, potassium chloride, mercury cyanide and pesticides </li>
			<BR> Class 8 - Corrosive substances
			<li> Release loads of substances that can dissolve organic tissue or severely corrode certain metals. As sulfuric acid, hydrochloric acid, potassium hydroxide and sodium hydroxide </li>
		</ul>`,
	skills_page_distance_title: 'Distance',
	skills_page_distance_description: `
		<p> Your long distance skill determines the maximum distance you can travel on duty. Initially they are not offered to drive more than 6km. </p>
		<ul>
			Level 1:
			<li> Deliveries up to 6.5km </li>
			<li> 5% reward for distances greater than 6km </li>
			<li> 10% experience bonus for distances greater than 6km </li>
			<BR> Level 2:
			<li> Deliveries up to 7km </li>
			<li> 10% reward for distances greater than 6.5km </li>
			<BR> Level 3:
			<li> Deliveries up to 7.5km </li>
			<li> 15% reward for distances greater than 7km </li>
			<BR> Level 4:
			<li> Deliveries up to 8km </li>
			<li> 20% reward for distances greater than 7.5km </li>
			<BR> Level 5:
			<li> Deliveries up to 8.5km </li>
			<li> 25% reward for distances greater than 8km </li>
			<BR> Level 6:
			<li> Deliveries anywhere </li>
			<li> 30% reward for distances greater than 8.5km </li>
		</ul>`,
	skills_page_valuable_title: 'Valuable Cargo',
	skills_page_valuable_desc: `
		<p> Every cargo is valuable, but some are more valuable than others. Companies rely only on proven specialists to perform this type of service. </p>
		<ul>
			Level 1:
			<li> High value unlocked job offers </li>
			<li> 5% reward for valuable deliveries </li>
			<li> 20% experience bonus for valuable deliveries </li>
			<BR> Level 2:
			<li> 10% reward for valuable deliveries </li>
			<BR> Level 3:
			<li> 15% reward for valuable deliveries </li>
			<BR> Level 4:
			<li> 20% reward for valuable deliveries </li>
			<BR> Level 5:
			<li> 25% reward for valuable deliveries </li>
			<BR> Level 6:
			<li> 30% reward for valuable deliveries </li>
		</ul>`,
	skills_page_fragile_title: 'Fragile Cargo',
	skills_page_fragile_desc: `
		<p> This ability allows you to transport fragile loads, such as glass, electronics or delicate machines. </p>
		<ul>
			Level 1:
			<li> Fragile cargo job offers unlocked </li>
			<li> 5% reward for fragile cargo deliveries </li>
			<li> 20% experience bonus for fragile cargo deliveries </li>
			<BR> Level 2:
			<li> 10% reward for delivery of fragile cargo </li>
			<BR> Level 3:
			<li> 15% reward for deliveries of fragile cargo </li>
			<BR> Level 4:
			<li> 20% reward for delivery of fragile cargo </li>
			<BR> Level 5:
			<li> 25% reward for delivery of fragile cargo </li>
			<BR> Level 6:
			<li> 30% reward for fragile cargo deliveries </li>
		</ul>`,
	skills_page_fast_title: 'On-time delivery',
	skills_page_fast_desc: `
		<p> Sometimes, companies need to deliver something quickly. These jobs put more pressure on the driver, the delivery time is short but the payment makes up for the discomfort. </p>
		<ul>
			Level 1:
			<li> Urgent cargo job offers </li>
			<li> 5% reward for urgent cargo deliveries </li>
			<li> 20% experience bonus for urgent cargo deliveries </li>
			<BR> Level 2:
			<li> 10% reward for urgent cargo deliveries </li>
			<BR> Level 3:
			<li> 15% reward for urgent cargo deliveries </li>
			<BR> Level 4:
			<li> 20% reward for urgent cargo deliveries </li>
			<BR> Level 5:
			<li> 25% reward for urgent cargo deliveries </li>
			<BR> Level 6:
			<li> 30% reward for urgent cargo deliveries </li>
		</ul>`,

    loan_page_title: 'Bank',
	loan_page_desc: 'Get loans to invest in your company (Maximum active loans: {0})',
	loan_page_pay: 'pay {0} at day',
	loan_page_remaining: 'Remaining: {0}',
	loan_page_daily_cost: 'Daily cost: {0}',
	loan_page_pay_off: 'Pay Loan',

	party_page_title: 'Party',
	party_page_desc: 'Create or join a party to deliver together with your friends.',
	party_page_create: 'Create party',
	party_page_join: 'Join party',
	party_page_name: 'Party name*',
	party_page_subtitle: 'Party description*',
	party_page_password: 'Password',
	party_page_password_confirm: 'Confirm Password',
	party_page_members: 'Members amount*',
	party_page_finish_button: 'Finish ({0} + {1})',
	party_page_finish_button_2: 'Finish',
	party_page_password_mismatch: '* Password mismatch',
	party_leader: 'Party leader',
	party_finished_deliveries: 'Deliveries completed on party: {0}',
	party_joined_time: 'In the party since: {0}',
	party_kick: 'Kick party',
	party_quit: 'Quit party',
	party_delete: 'Delete party',
	
	str_fill_field:"Fill this field",
	str_invalid_value:"Invalid value",
	str_more_than:"Must be greater than or equal to {0}",
	str_less_than:"Must be less than or equal to {0}",

    bank_page_withdraw: 'Withdraw your money',
	bank_page_deposit: 'Deposit Money',
	bank_page_placeholder: 'Amount',
	bank_page_loans: 'Active loans:',
};