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

	//跳转到搜索页面
	var indexPageElemZ =  $("#page_index");
	var selectSitePageElemZ =  $("#page_selectsite");
	var selectSiteInputElemZ =  $("#selectsiteinput");
	global.toSelectSitePage = function() {
		indexPageElemZ.hide();
		selectContainerElemZ.html("");
		if (!global.busStartData.lon) {
			//选择起点
			selectSiteInputElemZ.attr("placeholder", "请输入起点");
			selectSiteInputElemZ.attr("value", global.busStartData.key);
			isSelectEndSite = false;
			selectSitePageElemZ.show();

			if (global.busStartData.key && global.busStartData.key != global.defaultData.key) {
				showStartResultHandler.clean();
				showStartResultHandler.reqQueryKey(global.busStartData.key, 1);
			}
		} else if (!global.busEndData.lon) {
			//选择终点
			selectSiteInputElemZ.attr("placeholder", "请输入终点");
			selectSiteInputElemZ.attr("value", global.busEndData.key);
			isSelectEndSite = true;
			selectSitePageElemZ.show();

			if (global.busEndData.key && global.busEndData.key != global.defaultData.key) {
				showStartResultHandler.clean();
				showEndResultHandler.reqQueryKey(global.busEndData.key, 1);
			}
		}
	};

	var loadingElemZ = $("#loadingid");

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

	var showEndResultHandler = {
		resultData : [],
		resultHtmls : [],
		totalCount : 0,
		pageCount : 0,
		reqQueryKey : function(key, pn) {
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
						var html = createItemHtml(keyRes[i].name, keyRes[i].address, keyRes[i].tel, index, i, 2);
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
				htmls.push("<div class='Page_pre' onclick='preNextBtnHandler(" + (index - 1) + ",2)'>上一页</div>");
			}
			if (index < (this.pageCount - 1)) {
				htmls.push("<div class='Page_next' onclick='preNextBtnHandler(" + (index - 0 + 1) + ",2)'>下一页</div>");
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

	function cloneData(data) {
		var temp =  {};
		for (var i in data) {
			temp[i] = data[i];
		}
		return temp;
	};

	var selectsitesearchbtnElemZ = $("#selectsitesearchbtn");
	eu.addEventListener(selectsitesearchbtnElemZ, "mousedown", function(evt, data) {
		selectsitesearchbtnElemZ.addClass("curr");
	});
	eu.addEventListener(selectsitesearchbtnElemZ, "mouseup", function(evt, data) {
		selectsitesearchbtnElemZ.removeClass("curr");
		var key = selectSiteInputElemZ.val();
		if (key) {
			if (isSelectEndSite) {
				showStartResultHandler.clean();
				showEndResultHandler.reqQueryKey(key, 1);
			} else {
				showStartResultHandler.clean();
				showStartResultHandler.reqQueryKey(key, 1);
			}
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
		if (isSelectEndSite) {
			global.busEndData = cloneData(global.defaultData);
			global.setStartEndInput();
			global.toIndexPage();
		} else {
			isSelectEndSite = true;

			global.busStartData = cloneData(global.defaultData);

			selectContainerElemZ.html("");
			selectSiteInputElemZ.attr("placeholder", "请输入终点");
			selectSiteInputElemZ.attr("value", "");
			if (global.busEndData.key) {
				selectSiteInputElemZ.attr("value", global.busEndData.key);
				showEndResultHandler.clean();
				showEndResultHandler.reqQueryKey(global.busEndData.key, 1);
			}
		}
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
		if (type == "start") {
			global.busStartData.name = addr;
			global.busStartData.lon = parseFloat(lon);
			global.busStartData.lat = parseFloat(lat);
			
			isSelectEndSite = true;

			selectContainerElemZ.html("");
			selectSiteInputElemZ.attr("placeholder", "请输入终点");
			selectSiteInputElemZ.attr("value", "");
			if (global.busEndData.key) {
				selectSiteInputElemZ.attr("value", global.busEndData.key);
				showEndResultHandler.clean();
				showEndResultHandler.reqQueryKey(global.busEndData.key, 1);
			}
		} else if (type == "end") {
			isSelectEndSite = false;

			global.busEndData.name = addr;
			global.busEndData.lon = parseFloat(lon);
			global.busEndData.lat = parseFloat(lat);
			global.setStartEndInput();
			global.toIndexPage();
		}
	};

	var startNameElemZ = $("#startnameid");
	var endNameElemZ = $("#endnameid");
	var isSelectEndSite = false;
	var isSetSite = true;
	window.setSite = function (resultDataIndex, resultDataIndexIndex, flag) {
		if (isSetSite) {
			if (flag == 1) {
				var data = showStartResultHandler.resultData[resultDataIndex][resultDataIndexIndex];
				var lonLat = data.geom.coordinates[0];
				global.busStartData.name = data.name;
				global.busStartData.lon = parseFloat(lonLat[0]);
				global.busStartData.lat = parseFloat(lonLat[1]);
				
				isSelectEndSite = true;

				selectContainerElemZ.html("");
				selectSiteInputElemZ.attr("placeholder", "请输入终点");
				selectSiteInputElemZ.attr("value", "");
				if (global.busEndData.key) {
					selectSiteInputElemZ.attr("value", global.busEndData.key);
					showEndResultHandler.clean();
					showEndResultHandler.reqQueryKey(global.busEndData.key, 1);
				}
			} else if (flag == 2) {
				isSelectEndSite = false;

				var data = showEndResultHandler.resultData[resultDataIndex][resultDataIndexIndex];
				var lonLat = data.geom.coordinates[0];
				global.busEndData.name = data.name;
				global.busEndData.lon = parseFloat(lonLat[0]);
				global.busEndData.lat = parseFloat(lonLat[1]);
				global.setStartEndInput();
				global.toIndexPage();
			}
			return false;
		} else {
			isSetSite = true;
			var type, data;
			if (flag == 1) {
				data = showStartResultHandler.resultData[resultDataIndex][resultDataIndexIndex];
				type = 2;
			} else if (flag == 2) {
				data = showEndResultHandler.resultData[resultDataIndex][resultDataIndexIndex];
				type = 3;
			}
			console.log(data);
			var lonLat = data.geom.coordinates[0];
			//调用本地接口
			if (global.mobilePlatform.android) {
				window.JSAndroidBridge.displayPointInMap(lonLat[0], lonLat[1], data.name, data.address, type);
			} else if (global.mobilePlatform.iPhone) {
				window.location.href="objc:??displayPointInMap::?"+lonLat[0]+":?"+lonLat[1]+":?"+data.name+":?"+data.address+":?"+type;
			} else {
				alert("调用本地invation方法,PC不支持.");
			}
		}
	};

	window.callbackDisplayPointInMap = function(lon, lat, name, type) {
		if (2 == parseInt(type)) {
			type = "start";
		} else if (3 == parseInt(type)) {
			type = "end";
		}
		window.callbackChooseLocation(type, lon, lat, name);
	};

	window.preNextBtnHandler = function (index, flag) {
		if (flag == 1) {
			showStartResultHandler.reqQueryKey(global.busStartData.key, index + 1);
		} else if (flag == 2) {
			showEndResultHandler.reqQueryKey(global.busEndData.key, index + 1);
		}
	};

	window.lookSiteMap = function() {
		isSetSite = false;
		return false;
	};
}());