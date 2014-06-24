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

	var keyWord;

	var toIndexBtnElemZ = $("#toindexbtn");
	eu.addEventListener(toIndexBtnElemZ, "click", function(evt, data) {
		pu.toPage("bus_index.html");
	});
	
	//注册加载取消按钮事件
	var loadingidbtnElemZ = $("#loadingid");
	eu.addEventListener(loadingidbtnElemZ, "mousedown", function() {
		loadingidbtnElemZ.hide();
	});
	
	/**
	 * 关键字搜索
	 * @param {String} key 关键字
	 * @param {Ojbect} scope 
	 */
	function keyQueryHandler(key, pn, scope) {
		//组织JSONP请求参数
		var params = {
			adcode : 110000,
			key : key,
			searchtype : "poi,road,cross",
			language : 0,
			pageNumber : pn,
			pageCount : 10
		}
		var KEYQUERYURL = gsu.keyQueryUrl();
		
		loadingElemZ.show();

		hu.sendJsonpRequest(KEYQUERYURL, params, function(res, data) {
			this.showResult(res);
		}, scope);
	};

	function createItemHtml(name, address, tel, resultDataIndex, resultDataIndexIndex, flag) {
		var htmls = [];
		htmls.push("<li onclick=setSite(" + resultDataIndex + "," + resultDataIndexIndex + "," + flag + ") ><a>");
		htmls.push("<h2>" + name + "</h2>");
		if (address) {
			htmls.push("<p>地址：" + address + "</p>");
		}
		if (tel) {
			htmls.push("<p>电话：" + tel + "</p>");
		}
		htmls.push("<span class='jtd' onclick=lookSiteMap()></span>");
		htmls.push("</a></li>");
		return htmls.join("");
	};

	var selectContainerElemZ = $("#selectcontainerid");
	var showStartResultHandler = {
		resultData : [],
		resultHtmls : [],
		totalCount : 0,
		pageCount : 0,
		reqQueryKey : function(key, pn) {
			keyWord = key;
			var me = this;
			selectContainerElemZ.html("");
			var index = pn - 1;
			if (me.resultData[index] && me.resultHtmls[index]) {
				selectContainerElemZ.html(me.resultHtmls[index]);
			} else {
				keyQueryHandler(key, pn, me);
			}
		},
		showResult : function(data) {
			loadingElemZ.hide();
			var me = this;
			var result = data.response.result;
			if (result) {
				var pageCount = me.count(result.totalCount);
				me.pageCount = pageCount;
				var keyRes = result.keyresult;
				if (keyRes && keyRes.length > 0) {
					var index = result.pageNumber - 1;
					me.resultData[index] = keyRes;
					var htmls = [];
					// htmls.push("<ul class='h-list-t'>");
					for (var i = 0, len = keyRes.length; i < len; i++) {
						var html = createItemHtml(keyRes[i].name, keyRes[i].address, keyRes[i].tel, index, i, 1);
						htmls.push(html);
					}
					// htmls.push("</ul>");
					htmls.push(me.createPerNextBtn(index));
					var resultHtml = htmls.join("");
					me.resultHtmls[index] = resultHtml;
					selectContainerElemZ.html(resultHtml);
				}
			}
		},
		createPerNextBtn : function(index) {
			var htmls = [];
			htmls.push("<div class='footerPage'>");
			if (index > 0) {
				htmls.push("<div class='Page_pre' onclick='preNextBtnHandler(" + (index - 1) + ",1)'>上一页</div>");
			}
			if (index < (this.pageCount - 1)) {
				htmls.push("<div class='Page_next' onclick='preNextBtnHandler(" + (index - 0 + 1) + ",1)'>下一页</div>");
			}
			htmls.push("</div>");
			return htmls.join("");
		},
		count : function(total) {
			if (total > 0) {
				return Math.ceil(total / 10);
			}
		},
		clean : function() {
			var me = this;
			me.resultData = [];
		    me.resultHtmls = [];
		    me.totalCount = 0;
		    me.pageCount = 0;
		}
	};

	var selectSiteInputElemZ =  $("#selectsiteinput");
	selectSiteInputElemZ.focus();
	var selectsitesearchbtnElemZ = $("#selectsitesearchbtn");
	eu.addEventListener(selectsitesearchbtnElemZ, "mousedown", function(evt, data) {
		selectsitesearchbtnElemZ.addClass("curr");
	});
	eu.addEventListener(selectsitesearchbtnElemZ, "mouseup", function(evt, data) {
		selectsitesearchbtnElemZ.removeClass("curr");
		var key = selectSiteInputElemZ.val();
		if (key) {
			showStartResultHandler.clean();
			showStartResultHandler.reqQueryKey(key, 1);
		}
	});

	var toIndexBtnElemZ = $("#toindexbtn");
	eu.addEventListener(toIndexBtnElemZ, "click", function(evt, data) {
		global.toIndexPage();
	});

	var mylocbtnElemZ = $("#mylocbtn");
	eu.addEventListener(mylocbtnElemZ, "mousedown", function(evt, data) {
		mylocbtnElemZ.addClass("curr");
	});
	eu.addEventListener(mylocbtnElemZ, "mouseup", function(evt, data) {
		mylocbtnElemZ.removeClass("curr");
		var data = os.get("defaultData");
		os.set("busStartData", data);
		pu.toPage("bus_index.html");
	});

	var clickmapbtnElemZ = $("#clickmapbtn");
	eu.addEventListener(clickmapbtnElemZ, "mousedown", function(evt, data) {
		clickmapbtnElemZ.addClass("curr");
	});
	eu.addEventListener(clickmapbtnElemZ, "mouseup", function(evt, data) {
		clickmapbtnElemZ.removeClass("curr");
		if (isSelectEndSite) {
			if (global.mobilePlatform.android) {
				window.JSAndroidBridge.chooseLocation("end");
			} else if (global.mobilePlatform.iPhone) {
				window.location.href="objc:??chooseLocation::?end";
			} else {
				alert("调用本地invation方法,PC不支持.");
			}
		} else {
			if (global.mobilePlatform.android) {
				window.JSAndroidBridge.chooseLocation("start");
			} else if (global.mobilePlatform.iPhone) {
				window.location.href="objc:??chooseLocation::?start";
			} else {
				alert("调用本地invation方法,PC不支持.");
			}
		}
	});

	window.callbackChooseLocation = function(type, lon, lat, addr) {
		var busStartData = {
			name : addr,
			lon : parseFloat(lon),
			lat : parseFloat(lat)
		};
		os.set("busStartData", global.jsonUtil.toJsonStr(busStartData));
		pu.toPage("bus_index.html");
	};

	var startNameElemZ = $("#startnameid");
	var endNameElemZ = $("#endnameid");
	var isSelectEndSite = false;
	var isSetSite = true;
	window.setSite = function (resultDataIndex, resultDataIndexIndex, flag) {
		if (isSetSite) {
			var data = showStartResultHandler.resultData[resultDataIndex][resultDataIndexIndex];
			var lonLat = data.geom.coordinates[0];
			var busStartData = {
				name : data.name,
				lon : parseFloat(lonLat[0]),
				lat : parseFloat(lonLat[1])
			};
			var jsonStr = global.jsonUtil.toJsonStr(busStartData);
			os.set("busStartData", jsonStr);
			pu.toPage("bus_index.html");
			return false;
		} else {
			isSetSite = true;
			var data = showStartResultHandler.resultData[resultDataIndex][resultDataIndexIndex];
			var lonLat = data.geom.coordinates[0];
			//调用本地接口
			if (global.mobilePlatform.android) {
				window.JSAndroidBridge.displayPointInMap(lonLat[0], lonLat[1], data.name, data.address, 2);
			} else if (global.mobilePlatform.iPhone) {
				window.location.href="objc:??displayPointInMap::?"+lonLat[0]+":?"+lonLat[1]+":?"+data.name+":?"+data.address+":?"+2;
			} else {
				alert("调用本地invation方法,PC不支持.");
			}
		}
	};

	window.callbackDisplayPointInMap = function(lon, lat, name, type) {
		var busStartData = {
			name : name,
			lon : parseFloat(lon),
			lat : parseFloat(lat)
		};
		if (type == 0) {
			selectSiteInputElemZ.val(name);
		} else {
			os.set("busStartData", global.jsonUtil.toJsonStr(busStartData));
			pu.toPage("bus_index.html");
		}
		
	};

	window.preNextBtnHandler = function (index, flag) {
		if (flag == 1) {
			showStartResultHandler.reqQueryKey(keyWord, index + 1);
		} else if (flag == 2) {
			showEndResultHandler.reqQueryKey(keyWord, index + 1);
		}
	};

	window.lookSiteMap = function() {
		isSetSite = false;
		return false;
	};
}());