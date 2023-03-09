$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["show"] !== undefined){
			if (event["data"]["show"] == true){
				$("#Arena").css("display","block");
			} else {
				$("#Arena").css("display","none");
			}

			return
		}

		if (event["data"]["Players"] !== undefined){
			$("#Arena").html(`<b>MORTES CONSECUTIVAS: ${event["data"]["Streek"]}</b><br>WWW.IMERSIVOS.COM.BR`);
		}
	});
});