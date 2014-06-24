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

	var sData, eData;

	var backpagebtnElemZ = $("#backpagebtn");
	eu.addEventListener(backpagebtnElemZ, "click", function() {
		//调用本地接口
		if (global.mobilePlatform.android) {
			window.JSAndroidBridge.routeCloseThisPage();
		} else if (global.mobilePlatform.iPhone) {
			window.location.href="objc:??routeCloseThisPage";
		} else {
			alert("调用本地invation方法,PC不支持.");
		}
	});

	var searchType = 3;
	var driverbtnElemZ = $("#driverbtn");
	var warkbtnElemZ = $("#warkbtn");
	var busbtnElemZ = $("#busbtn");
	eu.addEventListener(driverbtnElemZ, "click", function() {
		driverbtnElemZ.addClass("curr");
		warkbtnElemZ.removeClass("curr");
		busbtnElemZ.removeClass("curr");
		searchType = 1;
	});
	eu.addEventListener(warkbtnElemZ, "click", function() {
		warkbtnElemZ.addClass("curr");
		busbtnElemZ.removeClass("curr");
		driverbtnElemZ.removeClass("curr");
		searchType = 2;
	});
	eu.addEventListener(busbtnElemZ, "click", function() {
		busbtnElemZ.addClass("curr");
		warkbtnElemZ.removeClass("curr");
		driverbtnElemZ.removeClass("curr");
		searchType = 3;
	});
	//注册加载取消按钮事件
	var loadingidbtnElemZ = $("#loadingid");
	eu.addEventListener(loadingidbtnElemZ, "mousedown", function() {
		loadingidbtnElemZ.hide();
	});

	//注册互换起始点按钮事件
	var changebtnElemZ = $("#changebtn");
	eu.addEventListener(changebtnElemZ, "mousedown", function() {
		changebtnElemZ.addClass("curr");
	});
	eu.addEventListener(changebtnElemZ, "mouseup", function() {
		changebtnElemZ.removeClass("curr");
		var startKey = startSiteInputElemZ.html();
		var endKey = endSiteInputElemZ.html();
		if (endKey == "请设置终点") {
			endKey = "请设置起点";
		}
		if (startKey == "请设置起点") {
			startKey = "请设置终点";
		}
		startSiteInputElemZ.html(endKey);
		if (endKey == "我的位置") {
			startSiteInputElemZ.addClass("lantext");
		} else {
			startSiteInputElemZ.removeClass("lantext");
		}
		endSiteInputElemZ.html(startKey);
		if (startKey == "我的位置") {
			endSiteInputElemZ.addClass("lantext");
		} else {
			endSiteInputElemZ.removeClass("lantext");
		}

		var temp = cloneData(sData);
		sData = cloneData(eData);
		eData = cloneData(temp);
	});

	//起点
	var startSiteInputId = "startsiteid";
	var startSiteInputElemZ = $("#" + startSiteInputId);
	eu.addEventListener(startSiteInputElemZ, "click", function() {
		pu.toPage("bus_selectstartsite.html");
	});

	//终点
	var endSiteInputId = "endsiteid";
	var endSiteInputElemZ = $("#" + endSiteInputId);
	eu.addEventListener(endSiteInputElemZ, "click", function() {
		pu.toPage("bus_selectendsite.html");
	});

	function initInfo() {
		var startDataStr = os.get("busStartData");
		var endDataStr = os.get("busEndData");
		if (startDataStr) {
			var startData = global.jsonUtil.toJsonObj(startDataStr);
			sData = startData;
			startSiteInputElemZ.html(sData.name);
			if (sData.name == "我的位置") {
				startSiteInputElemZ.addClass("lantext");
			}
		}
		if (endDataStr) {
			var endData = global.jsonUtil.toJsonObj(endDataStr);
			eData = endData;
			endSiteInputElemZ.html(eData.name);
			if (eData.name == "我的位置") {
				endSiteInputElemZ.addClass("lantext");
			}
		}
	};
	initInfo();

	function cleanLocalStore() {
		os.remove("defaultData");
		os.remove("busStartData");
		os.remove("busEndData");
		startSiteInputElemZ.html("请输入起点");
		endSiteInputElemZ.html("请输入终点");
		sData = null;
		eData = null;
	};

	//本地代码调用JS方法
	window.callbackInitSettingStartEndPage = function(intisLogin,stringuserInfoJSON,stringua,stringpid,Stringjson) {
		var obj = global.jsonUtil.toJsonObj(Stringjson);
		if (obj) {
			cleanLocalStore();
			var defaultData = {
				key : "我的位置",
				name : "我的位置",
				lon : obj.lon,
				lat : obj.lat
			};
			os.set("defaultData", global.jsonUtil.toJsonStr(defaultData));
			os.set("busStartData", global.jsonUtil.toJsonStr(defaultData));
			sData = cloneData(defaultData);
			startSiteInputElemZ.html("我的位置");
			startSiteInputElemZ.addClass("lantext");
		}
	};

	function cloneData(data) {
		var temp =  {};
		for (var i in data) {
			temp[i] = data[i];
		}
		return temp;
	};

	//注册点击搜索按钮事件
	var searchbtnElemZ = $("#searchbtn");
	eu.addEventListener(searchbtnElemZ, "mousedown", function(evt, data) {
		searchbtnElemZ.addClass("curr");
	});
	eu.addEventListener(searchbtnElemZ, "mouseup", function(evt, data) {
		searchbtnElemZ.removeClass("curr");
		if (sData.lon > 0 && eData.lon > 0) {
			if (searchType == 1) {
				//调用本地接口
				if (global.mobilePlatform.android) {
					window.JSAndroidBridge.displayWalkDriveRouteInMap(sData.lon, sData.lat, eData.lon, eData.lat, 1);
				} else if (global.mobilePlatform.iPhone) {
					window.location.href="objc:??displayWalkDriveRouteInMap::?"+sData.lon+":?"+sData.lat+":?"+eData.lon+":?"+eData.lat+":?"+1;
				} else {
					alert("调用本地invation方法,PC不支持.");
				}
			}
			if (searchType == 2) {
				//调用本地接口
				if (global.mobilePlatform.android) {
					window.JSAndroidBridge.displayWalkDriveRouteInMap(sData.lon, sData.lat, eData.lon, eData.lat, 2);
				} else if (global.mobilePlatform.iPhone) {
					window.location.href="objc:??displayWalkDriveRouteInMap::?"+sData.lon+":?"+sData.lat+":?"+eData.lon+":?"+eData.lat+":?"+2;
				} else {
					alert("调用本地invation方法,PC不支持.");
				}
			}
			if (searchType == 3) {
				global.setStartEnd(sData, eData);
			}
		}
	});
}());