(function() {
	var global = window[_MYNAMESPACE_];
	//eventUtil的简称
	var eu = global.eventUtil;
	//httpUtil的简称
	var hu = global.httpUtil;
	//offlineStore的简称
	var os = global.offlineStore;
	var pu = global.pageUtil;
	var gsu = global.getServerUrl;

	var loadingElemZ = $("#loadingid");

	var demoData = {"response":{"statusCode":120000,"responseID":"212A6FF4A4A19A5B0ABCFD819DD47BE1","result":{"brlcnt":"4","busInfo":[{"brldist":"9.832","brltime":"38","linecnt":"1","lineInfo":[{"walkdist":"0.8","stationName":"西单北大街","walkLine":"53623897,18391735,53623909,18391256,53623909,18391256,53624245,18391265,53624245,18391265,53624264,18390588,53624264,18390588,53624383,18390588,53624383,18390588,53624416,18390385,53624499,18390261,53624540,18390021,53624540,18390021,53625107,18390049,53625107,18390049,53625116,18389265,53625170,18389265","linename":"地铁1号线(苹果园站-四惠东站)","consumetime":"19","stopcnt":"8","swdist":"648","usid":"27785","usname":"西单站","spx":"53625170","spy":"18389236","dsid":"27793","dsname":"大望路站","epx":"53672284","epy":"18389726","clistcnt":"11","clist":"53625170,18389236,53629801,18389250,53633284,18389375,53637909,18389500,53642431,18389622,53645430,18389700,53649869,18389799,53653596,18389840,53660441,18389812,53665502,18389796,53672284,18389726,"}],"toEndDist":"0.6","distName":"未知路段","toDistLine":"53672285,18389818,53672970,18389805,53672970,18389805,53672970,18389832,53673021,18389832,53673021,18389947,53673021,18389947,53673565,18389957,53673565,18389957,53673565,18390182,53673606,18390242,53673790,18390422,53673929,18390436,53673929,18390436,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"10.133","brltime":"47","linecnt":"1","lineInfo":[{"walkdist":"1.1","stationName":"西长安街","walkLine":"53623897,18391735,53623909,18391256,53623909,18391256,53625079,18391288,53625079,18391288,53625042,18391247,53625061,18390606,53625061,18390606,53625176,18390399,53625176,18390399,53625185,18390150,53625185,18390150,53625208,18389196,53625208,18389196,53626520,18389198","linename":"728路(老山公交场站-武夷花园)","consumetime":"28","stopcnt":"8","swdist":"782","usid":"4292","usname":"西单路口东","spx":"53626521","spy":"18389197","dsid":"4300","dsname":"八王坟东","epx":"53675542","epy":"18389615","clistcnt":"17","clist":"53626521,18389195,53629216,18389212,53632430,18389304,53637541,18389454,53644370,18389642,53650656,18389778,53653986,18389820,53657757,18389799,53659186,18389790,53663868,18389754,53664080,18389673,53664331,18389629,53667213,18389673,53667363,18389717,53670892,18389699,53671062,18389640,53675542,18389616,"}],"toEndDist":"0.6","distName":"未知路段","toDistLine":"53675542,18389620,53674947,18389620,53674947,18389620,53674952,18389805,53674952,18389805,53675150,18389805,53675150,18389805,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"10.147","brltime":"48","linecnt":"1","lineInfo":[{"walkdist":"1.1","stationName":"西长安街","walkLine":"53623897,18391735,53623909,18391256,53623909,18391256,53625079,18391288,53625079,18391288,53625042,18391247,53625061,18390606,53625061,18390606,53625176,18390399,53625176,18390399,53625185,18390150,53625185,18390150,53625208,18389196,53625208,18389196,53626520,18389198","linename":"1路(靛厂新村-四惠站)","consumetime":"30","stopcnt":"10","swdist":"782","usid":"44082","usname":"西单路口东","spx":"53626521","spy":"18389197","dsid":"44092","dsname":"八王坟东","epx":"53675542","epy":"18389615","clistcnt":"20","clist":"53626521,18389197,53629216,18389212,53632430,18389304,53637541,18389454,53644370,18389643,53650189,18389769,53653206,18389818,53656863,18389806,53658434,18389793,53662285,18389767,53663868,18389754,53664080,18389673,53664421,18389624,53666846,18389667,53667214,18389673,53667363,18389717,53669657,18389705,53670892,18389699,53671062,18389640,53675542,18389615,"}],"toEndDist":"0.6","distName":"未知路段","toDistLine":"53675542,18389620,53674947,18389620,53674947,18389620,53674952,18389805,53674952,18389805,53675150,18389805,53675150,18389805,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"9.890","brltime":"54","linecnt":"2","lineInfo":[{"walkdist":"1.1","stationName":"西长安街","walkLine":"53623897,18391735,53623909,18391256,53623909,18391256,53625079,18391288,53625079,18391288,53625042,18391247,53625061,18390606,53625061,18390606,53625176,18390399,53625176,18390399,53625185,18390150,53625185,18390150,53625208,18389196,53625208,18389196,53626520,18389198","linename":"728快(军事博物馆-武夷花园)","consumetime":"23","stopcnt":"3","swdist":"782","usid":"43652","usname":"西单路口东","spx":"53626521","spy":"18389197","dsid":"43655","dsname":"大北窑西","epx":"53664331","epy":"18389629","clistcnt":"7","clist":"53626521,18389195,53630735,18389247,53644370,18389642,53652188,18389808,53663869,18389755,53664080,18389673,53664331,18389629,"},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"668路(北京站东-京东运乔建材城)","consumetime":"13","stopcnt":"1","swdist":"0","usid":"5060","usname":"大北窑西","spx":"53664331","spy":"18389629","dsid":"5061","dsname":"八王坟东","epx":"53674580","epy":"18389617","clistcnt":"3","clist":"53664331,18389629,53667231,18389675,53674580,18389619,"}],"toEndDist":"0.5","distName":"未知路段","toDistLine":"53674580,18389620,53674947,18389620,53674947,18389620,53674952,18389805,53674952,18389805,53675150,18389805,53675150,18389805,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"}]}}};

	var demoData1 = {"response":{"statusCode":120000,"responseID":"E5AD3EB43975E3E152692F091EB1EC4B","result":{"brlcnt":"10","busInfo":[{"brldist":"28.836","brltime":"64","linecnt":"3","lineInfo":[{"walkdist":"0.0","stationName":"同成街","walkLine":"53607655,18464809,53607659,18464809","linename":"地铁13号线(西直门站-东直门站)","consumetime":"24","stopcnt":"5","swdist":"40","usid":"58877","usname":"回龙观站","spx":"53607657","spy":"18464645","dsid":"58882","dsname":"芍药居","epx":"53653321","epy":"18421331","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"地铁10号线(西局站-首经贸站)","consumetime":"19","stopcnt":"8","swdist":"0","usid":"63451","usname":"芍药居","spx":"53653321","spy":"18421331","dsid":"63459","dsname":"国贸","epx":"53665587","epy":"18389774","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"地铁1号线(苹果园站-四惠东站)","consumetime":"11","stopcnt":"1","swdist":"0","usid":"27792","usname":"国贸","spx":"53665587","spy":"18389774","dsid":"27793","dsname":"大望路站","epx":"53672284","epy":"18389726","clistcnt":null,"clist":null}],"toEndDist":"0.6","distName":"未知路段","toDistLine":"53672285,18389818,53672970,18389805,53672970,18389805,53672970,18389832,53673021,18389832,53673021,18389947,53673021,18389947,53673565,18389957,53673565,18389957,53673565,18390182,53673606,18390242,53673790,18390422,53673929,18390436,53673929,18390436,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"33.003","brltime":"70","linecnt":"3","lineInfo":[{"walkdist":"0.0","stationName":"同成街","walkLine":"53607655,18464809,53607659,18464809","linename":"地铁13号线(东直门站-西直门站)","consumetime":"21","stopcnt":"5","swdist":"40","usid":"58862","usname":"回龙观站","spx":"53607657","spy":"18464645","dsid":"58867","dsname":"知春路","epx":"53609501","epy":"18421128","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"地铁10号线(西局站-首经贸站)","consumetime":"28","stopcnt":"15","swdist":"0","usid":"63444","usname":"知春路","spx":"53609501","spy":"18421128","dsid":"63459","dsname":"国贸","epx":"53665587","epy":"18389774","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"地铁1号线(苹果园站-四惠东站)","consumetime":"11","stopcnt":"1","swdist":"0","usid":"27792","usname":"国贸","spx":"53665587","spy":"18389774","dsid":"27793","dsname":"大望路站","epx":"53672284","epy":"18389726","clistcnt":null,"clist":null}],"toEndDist":"0.6","distName":"未知路段","toDistLine":"53672285,18389818,53672970,18389805,53672970,18389805,53672970,18389832,53673021,18389832,53673021,18389947,53673021,18389947,53673565,18389957,53673565,18389957,53673565,18390182,53673606,18390242,53673790,18390422,53673929,18390436,53673929,18390436,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"30.152","brltime":"103","linecnt":"2","lineInfo":[{"walkdist":"1.6","stationName":"未知路段","walkLine":"53607655,18464809,53609320,18464786,53609320,18464786,53609325,18465873,53609325,18465873,53607039,18465919,53607039,18465919,53607177,18464924,53607177,18464924,53607182,18463556,53607154,18463514,53607154,18463514,53606844,18463513","linename":"371路(新龙城东站-天鑫家园)","consumetime":"16","stopcnt":"3","swdist":"348","usid":"10184","usname":"新龙城东站","spx":"53606845","spy":"18463511","dsid":"10187","dsname":"西三旗桥北","epx":"53603567","epy":"18458256","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"753路(马连店-郎辛庄)","consumetime":"68","stopcnt":"30","swdist":"0","usid":"53150","usname":"西三旗桥北","spx":"53603567","spy":"18458256","dsid":"53180","dsname":"慈云寺桥","epx":"53678478","epy":"18392052","clistcnt":null,"clist":null}],"toEndDist":"1.4","distName":"未知路段","toDistLine":"53678477,18392052,53678472,18391058,53678472,18391058,53678463,18391030,53678454,18390970,53678306,18390745,53677924,18390247,53677924,18390247,53677518,18389998,53677048,18389851,53677048,18389851,53675970,18389800,53675970,18389800,53675583,18389800,53675583,18389800,53675583,18389938,53675583,18389938,53675417,18389924,53675164,18390017,53675164,18390017,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"30.164","brltime":"103","linecnt":"2","lineInfo":[{"walkdist":"1.6","stationName":"未知路段","walkLine":"53607655,18464809,53609320,18464786,53609320,18464786,53609325,18465873,53609325,18465873,53607039,18465919,53607039,18465919,53607177,18464924,53607177,18464924,53607182,18463556,53607154,18463514,53607154,18463514,53606844,18463513","linename":"636路(回南家园-西苑枢纽站)","consumetime":"14","stopcnt":"2","swdist":"348","usid":"58011","usname":"新龙城东站","spx":"53606845","spy":"18463511","dsid":"58013","dsname":"龙兴园","epx":"53601731","epy":"18460543","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"753路(马连店-郎辛庄)","consumetime":"69","stopcnt":"31","swdist":"0","usid":"53149","usname":"龙兴园","spx":"53601731","spy":"18460543","dsid":"53180","dsname":"慈云寺桥","epx":"53678478","epy":"18392052","clistcnt":null,"clist":null}],"toEndDist":"1.4","distName":"未知路段","toDistLine":"53678477,18392052,53678472,18391058,53678472,18391058,53678463,18391030,53678454,18390970,53678306,18390745,53677924,18390247,53677924,18390247,53677518,18389998,53677048,18389851,53677048,18389851,53675970,18389800,53675970,18389800,53675583,18389800,53675583,18389800,53675583,18389938,53675583,18389938,53675417,18389924,53675164,18390017,53675164,18390017,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"30.464","brltime":"104","linecnt":"2","lineInfo":[{"walkdist":"1.8","stationName":"未知路段","walkLine":"53607655,18464809,53609320,18464786,53609320,18464786,53609325,18465873,53609325,18465873,53607039,18465919,53607039,18465919,53607177,18464924,53607177,18464924,53607182,18463556,53607154,18463514,53607154,18463514,53608518,18463498","linename":"681路(龙锦苑公交场站-海淀中街)","consumetime":"16","stopcnt":"3","swdist":"355","usid":"37546","usname":"吉晟别墅","spx":"53608518","spy":"18463498","dsid":"37549","dsname":"西三旗桥北","epx":"53603567","epy":"18458256","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"753路(马连店-郎辛庄)","consumetime":"68","stopcnt":"30","swdist":"0","usid":"53150","usname":"西三旗桥北","spx":"53603567","spy":"18458256","dsid":"53180","dsname":"慈云寺桥","epx":"53678478","epy":"18392052","clistcnt":null,"clist":null}],"toEndDist":"1.4","distName":"未知路段","toDistLine":"53678477,18392052,53678472,18391058,53678472,18391058,53678463,18391030,53678454,18390970,53678306,18390745,53677924,18390247,53677924,18390247,53677518,18389998,53677048,18389851,53677048,18389851,53675970,18389800,53675970,18389800,53675583,18389800,53675583,18389800,53675583,18389938,53675583,18389938,53675417,18389924,53675164,18390017,53675164,18390017,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"32.254","brltime":"105","linecnt":"2","lineInfo":[{"walkdist":"0.5","stationName":"同成街","walkLine":"53607655,18464809,53609320,18464786,53609320,18464786,53609320,18464832,53608235,18464848","linename":"887路(城铁回龙观站-南口北站)7:00,9:30,17:00,19:30","consumetime":"14","stopcnt":"2","swdist":"107","usid":"48948","usname":"城铁回龙观站","spx":"53608236","spy":"18464851","dsid":"48950","dsname":"北郊农场桥东","epx":"53600135","epy":"18466654","clistcnt":null,"clist":null},{"walkdist":"0.0","stationName":"回龙观西大街","walkLine":"53600134,18466654,53600113,18466648,53600113,18466648,53600090,18466689,53600261,18466736","linename":"753路(马连店-郎辛庄)","consumetime":"76","stopcnt":"34","swdist":"30","usid":"53146","usname":"北郊农场桥东","spx":"53600262","spy":"18466736","dsid":"53180","dsname":"慈云寺桥","epx":"53678478","epy":"18392052","clistcnt":null,"clist":null}],"toEndDist":"1.4","distName":"未知路段","toDistLine":"53678477,18392052,53678472,18391058,53678472,18391058,53678463,18391030,53678454,18390970,53678306,18390745,53677924,18390247,53677924,18390247,53677518,18389998,53677048,18389851,53677048,18389851,53675970,18389800,53675970,18389800,53675583,18389800,53675583,18389800,53675583,18389938,53675583,18389938,53675417,18389924,53675164,18390017,53675164,18390017,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"32.548","brltime":"107","linecnt":"2","lineInfo":[{"walkdist":"0.5","stationName":"同成街","walkLine":"53607655,18464809,53609320,18464786,53609320,18464786,53609320,18464832,53608235,18464848","linename":"548路(城铁回龙观站-二拨子新村)","consumetime":"15","stopcnt":"4","swdist":"107","usid":"101","usname":"城铁回龙观站","spx":"53608236","spy":"18464851","dsid":"105","dsname":"北郊农场桥东","epx":"53600135","epy":"18466654","clistcnt":null,"clist":null},{"walkdist":"0.0","stationName":"回龙观西大街","walkLine":"53600134,18466654,53600113,18466648,53600113,18466648,53600090,18466689,53600261,18466736","linename":"753路(马连店-郎辛庄)","consumetime":"76","stopcnt":"34","swdist":"30","usid":"53146","usname":"北郊农场桥东","spx":"53600262","spy":"18466736","dsid":"53180","dsname":"慈云寺桥","epx":"53678478","epy":"18392052","clistcnt":null,"clist":null}],"toEndDist":"1.4","distName":"未知路段","toDistLine":"53678477,18392052,53678472,18391058,53678472,18391058,53678463,18391030,53678454,18390970,53678306,18390745,53677924,18390247,53677924,18390247,53677518,18389998,53677048,18389851,53677048,18389851,53675970,18389800,53675970,18389800,53675583,18389800,53675583,18389800,53675583,18389938,53675583,18389938,53675417,18389924,53675164,18390017,53675164,18390017,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"33.683","brltime":"108","linecnt":"2","lineInfo":[{"walkdist":"1.7","stationName":"未知路段","walkLine":"53607655,18464809,53609320,18464786,53609320,18464786,53609325,18465873,53609325,18465873,53607039,18465919,53607039,18465919,53607177,18464924,53607177,18464924,53607182,18463556,53607154,18463514,53607154,18463514,53607154,18463482,53607113,18463477,53607109,18463143","linename":"临2路(新龙城东站-地铁西小口站)","consumetime":"14","stopcnt":"3","swdist":"416","usid":"49240","usname":"新龙城东站","spx":"53607103","spy":"18463144","dsid":"49243","dsname":"北新科技园","epx":"53612495","epy":"18459843","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"609路(建材城东里-四惠枢纽站)","consumetime":"81","stopcnt":"40","swdist":"0","usid":"58262","usname":"北新科技园","spx":"53612495","spy":"18459843","dsid":"58302","dsname":"八王坟东","epx":"53675542","epy":"18389615","clistcnt":null,"clist":null}],"toEndDist":"0.6","distName":"未知路段","toDistLine":"53675542,18389620,53674947,18389620,53674947,18389620,53674952,18389805,53674952,18389805,53675150,18389805,53675150,18389805,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"32.529","brltime":"107","linecnt":"2","lineInfo":[{"walkdist":"0.5","stationName":"同成街","walkLine":"53607655,18464809,53609320,18464786,53609320,18464786,53609320,18464832,53608235,18464848","linename":"昌61路(龙锦苑东五区-生命科学园)","consumetime":"16","stopcnt":"5","swdist":"107","usid":"27505","usname":"城铁回龙观站","spx":"53608236","spy":"18464851","dsid":"27510","dsname":"北郊农场桥东","epx":"53600135","epy":"18466654","clistcnt":null,"clist":null},{"walkdist":"0.0","stationName":"回龙观西大街","walkLine":"53600134,18466654,53600113,18466648,53600113,18466648,53600090,18466689,53600261,18466736","linename":"753路(马连店-郎辛庄)","consumetime":"76","stopcnt":"34","swdist":"30","usid":"53146","usname":"北郊农场桥东","spx":"53600262","spy":"18466736","dsid":"53180","dsname":"慈云寺桥","epx":"53678478","epy":"18392052","clistcnt":null,"clist":null}],"toEndDist":"1.4","distName":"未知路段","toDistLine":"53678477,18392052,53678472,18391058,53678472,18391058,53678463,18391030,53678454,18390970,53678306,18390745,53677924,18390247,53677924,18390247,53677518,18389998,53677048,18389851,53677048,18389851,53675970,18389800,53675970,18389800,53675583,18389800,53675583,18389800,53675583,18389938,53675583,18389938,53675417,18389924,53675164,18390017,53675164,18390017,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"},{"brldist":"32.114","brltime":"113","linecnt":"2","lineInfo":[{"walkdist":"0.8","stationName":"育知路","walkLine":"53607655,18464809,53604846,18464850,53604846,18464850,53604864,18464901,53604706,18465931","linename":"519路(城铁龙泽站-二六一医院)","consumetime":"13","stopcnt":"3","swdist":"609","usid":"10623","usname":"育知路南口","spx":"53604702","spy":"18465931","dsid":"10626","dsname":"北郊农场桥东","epx":"53600262","epy":"18466736","clistcnt":null,"clist":null},{"walkdist":null,"stationName":null,"walkLine":null,"linename":"753路(马连店-郎辛庄)","consumetime":"75","stopcnt":"34","swdist":"0","usid":"53146","usname":"北郊农场桥东","spx":"53600262","spy":"18466736","dsid":"53180","dsname":"慈云寺桥","epx":"53678478","epy":"18392052","clistcnt":null,"clist":null}],"toEndDist":"1.4","distName":"未知路段","toDistLine":"53678477,18392052,53678472,18391058,53678472,18391058,53678463,18391030,53678454,18390970,53678306,18390745,53677924,18390247,53677924,18390247,53677518,18389998,53677048,18389851,53677048,18389851,53675970,18389800,53675970,18389800,53675583,18389800,53675583,18389800,53675583,18389938,53675583,18389938,53675417,18389924,53675164,18390017,53675164,18390017,53675164,18390394,53675164,18390394,53674279,18390422,53674279,18390422,53674316,18390523,53674478,18390714"}]}}};
	/**
	 * 关键字搜索
	 * @param {String} key 关键字
	 * @param {Ojbect} scope 
	 */
	function busTransferQueryHandler(acode, strategy, spx, spy, epx, epy, scope) {
		//组织JSONP请求参数
		var params = {
			acode : acode,
			strategy : strategy,
			shpinfoflag : 1,
			spx : spx,
			spy : spy,
			epx : epx,
			epy : epy
		};
		var QUERYURL = gsu.bustransferQueryUrl();
		
		loadingElemZ.show();

		hu.sendJsonpRequest(QUERYURL, params, function(res, data) {
			// res = demoData1;
			this.showResult(res, data);
		}, scope, {
			strategy : params.strategy
		});
	};

	var tipIndex = ["A","B","C","D","E","F","G","H","J","K"];
	var busInfos = [];
	function createLiHtml(data) {
		var htmls = [];
		busInfos = [];
		for (var i = 0, len = data.length; i < len; i++) {
			busInfos[i] = data[i];
			htmls.push("<li onclick='openlihandler(this,"+i+");'>");
			htmls.push("<a>");
			var details = [];
			details.push("<div class='more'>");
			var temp = "";
			var lineInfo = data[i].lineInfo;

			if (lineInfo.length > 0) { //起点
				details.push("<p class='m1'>");
				details.push("<span>" + startObj[0] + "</span>");
				details.push("</p>");
			}

			for (var j = 0, lenj = lineInfo.length; j < lenj; j++) {
				if (j == 0) {
					temp = lineInfo[j].linename;
				} else {
					temp = temp + "<span class='jtz'></span>" + lineInfo[j].linename;
				}

				if (lineInfo[j].walkdist) { //步行
					details.push("<p class='m3'>");
					details.push("步行约" + lineInfo[j].walkdist + "公里至" + lineInfo[j].usname);
					details.push("</p>");
				}
				details.push("<p class='m2'>");
				details.push("乘坐");
				details.push("<span>" + lineInfo[j].linename + "</span>");
				details.push("在<span>" + lineInfo[j].dsname + "</span>下车");
				details.push("</p>");
			}

			if (details.length > 0) { //终点
				details.push("<p class='m3'>");
				details.push("步行");
				details.push(data[i].toEndDist + "公里到达");
				details.push("<span>" + endObj[0] + "</span>");
				details.push("</p>");
				details.push("<p class='m4'>");
				details.push("<span>" + endObj[0] + "</span>");
				details.push("</p>");
			}
			details.push("</div>");

			htmls.push("<h2>换乘方案 " + tipIndex[i] + "</h2>");
			htmls.push("<span class='jtd' onclick=lookTransferMap()></span>");
			htmls.push("</a>");

			htmls.push(details.join(""));
			htmls.push("</li>");
		}
		return htmls.join("");
	};

	var resultContainerElemZ = $("#resultcontainerid");
	var showResultHandler = {
		resultData : {},
		resultHtml : {},
		transferQuery : function(strategy) {
			strategy = strategy || 0;
			var acode = 110000;
			var spx = Math.round(startObj[1] * 3600 * 128);
			var spy = Math.round(startObj[2] * 3600 * 128);
			var epx = Math.round(endObj[1] * 3600 * 128);
			var epy = Math.round(endObj[2] * 3600 * 128);

			var me = this;
			var key = "strategy" + strategy;
			if (me.resultData[key] && me.resultHtml[key]) {
				var html = me.resultHtml[key];
				resultContainerElemZ.html(html);
			} else {
				busTransferQueryHandler(acode, strategy, spx, spy, epx, epy, me);
			}
		},
		showResult : function(data, param) {
			var me = this;
			var key = "strategy" + param.strategy; 
			if (data.response.result.busInfo && data.response.result.busInfo.length > 0) {
				me.resultData[key] = data.response.result.busInfo;
				var html = createLiHtml(data.response.result.busInfo);
				me.resultHtml[key] = html;
				resultContainerElemZ.html(html);
			}
			loadingElemZ.hide();
			resultContainerElemZ.show();
		},
		clean : function() {
			this.resultData = {};
			this.resultHtml = {};
		}
	};

	var startObj, endObj;
	var selectprojectElemZ = $("#selectproject");
	global.setStartEnd = function(startData, endData) {
		selectprojectElemZ.show();
		startObj = [startData.name, startData.lon, startData.lat];
		endObj = [endData.name, endData.lon, endData.lat];
		showResultHandler.clean();
		showResultHandler.transferQuery(tabLiIndex);
	};

	var openLiElemZ = null;
	var isOpenli = true;
	window.openlihandler = function (evt, i) {
		if (isOpenli) {
			var liElemZ = $(evt);
			var aElem = liElemZ.children()[0];
			var divElem = liElemZ.children()[1];
			if (openLiElemZ) {
				var temp_aElem = openLiElemZ.children()[0];
				var temp_divElem = openLiElemZ.children()[1];
				$(temp_aElem).removeClass("curr");
				$(temp_divElem).hide();

			}
			$(aElem).addClass("curr");
			$(divElem).show();
			openLiElemZ = liElemZ;
		} else {
			isOpenli = true;

			var str = global.jsonUtil.toJsonStr(busInfos[i]);
			var sDataStr = os.get("busStartData");
			var sData = global.jsonUtil.toJsonObj(sDataStr);

			var eDataStr = os.get("busEndData");
			var eData = global.jsonUtil.toJsonObj(eDataStr);

			var slon = sData.lon;
			var slat = sData.lat;
			var elon = eData.lon;
			var elat = eData.lat;

			if (global.mobilePlatform.android) {
				window.JSAndroidBridge.displayRouteInMap(slon, slat, elon, elat, str);
			} else if (global.mobilePlatform.iPhone) {
				window.location.href="objc:??displayRouteInMap::?"+slon+":?"+slat+":?"+elon+":?"+elat+":?"+str;
			} else {
				alert("调用本地invation方法,PC不支持.");
			}
		}
	};

	var tabLiElemZs = [$("#tabli0"), $("#tabli1"), $("#tabli2"), $("#tabli3")]
	var tabLiIndex = 0;
	window.setStrategy = function (flag) {
		tabLiElemZs[tabLiIndex].removeClass("curr");
		tabLiElemZs[flag].addClass("curr");
		tabLiIndex = flag;
		showResultHandler.transferQuery(flag);
	};

	window.lookTransferMap = function() {
		isOpenli = false;
		return false;
	};
}());