/**
 * 思路
 * 1、通过宽高初始化界面结构。
 * 2、创建轮播图IMG对象，此时用空白图片把IMG撑起来，并保存IMG对象。显示正在加载进度条。
 * 3、对本地存储进行逻辑处理，并跳转到上次显示的简图位置，记录当前图像位置。
 * 4、开始定时刷新定时器。
 * 5、每次跳转轮播图时，记录当前图像位置。
 */

//var paramDemo = '{"area":[{"city":"北京","city_code":"000000000","route_id":"1","route_name":"北京西站"},{"city":"北京","city_code":"101010100","route_id":"S100071","route_name":"全市路况","timep":"03:50"}],"width":400,"height":460,"url":"http://mobile.trafficeye.com.cn:8000/api2/v2/pics/","density":"2.0"}';
var paramDemo = '{"area":[{"city":"北京","city_code":"000000000","route_id":"1","route_name":"北京西站"},{"city":"北京","city_code":"101010100","route_id":"S100071","route_name":"全市路况","timep":"03:50"},{"city":"上海","city_code":"101020100","route_id":"0021_103_001","route_name":"全市路况(新)"},{"city":"上海","city_code":"101020100","route_id":"0021_103_001","route_name":"全市路况(新)"},{"city":"北京","city_code":"101010100","route_id":"0010_106_015","route_name":"北苑路"}],"width":400,"height":460,"url":"http://mobile.trafficeye.com.cn:8000/api2/v2/pics/","density":"2.0"}';
var REQPICURL = "http://mobile.trafficeye.com.cn:8088/GraphicService_trafficeyeServlet/getPic";
var REQTIMESTAMPURL = "http://mobile.trafficeye.com.cn:8088/GraphicService_trafficeyeServlet/timeStampMainServlet";

//上bar和下bar的高度之和
var imgOffsetW = 20;
var imgOffsetH = 160;
var localStore = window.localStorage,
undefinedType = void 0,
    //判断浏览器是否支持本地存储
    isEnableStore = "localStorage" in window && localStore !== null && localStore !== undefinedType;
var STOREKEY = "traffic_jiantu";
//交通简图容器元素对象
var trafficContainerElem = document.getElementById("trafficContainer"); 
//交通简图容器背景图片元素对象
var trafficBgImgElem = document.getElementById("trafficBgImg"); 
//轮播图视口容器元素对象
var mySwipeElem = document.getElementById("mySwipe"); 
//轮播图列表容器元素对象
var indexConElem = $("#indexCon"); 
//轮播图焦点列表容器元素对象
var tabNavElem = $("#tabNav"); 
//根据不同的areaKey，保存相关城市区域的信息
var areas = {};
var temp_areaKey = "";
var save_areaKey = "";
var cityCodes = [];
//保存设备信息
var deviceInfo = {};
var inited = false;
//城市区域类
function area() {
	this.city = "";
	this.cityCode = "";
	this.routeId = "";
	this.routeName = "";
	//与area对象一一对应的唯一ID，并以键值对的形式存放在areas对象中。
	this.key = "";
	//与轮播焦点一一对应的下标，起始点是0。
	this.tabIndex = 0;
	//简图相关元素对象ID集合
	this.elemIds = [];
	this.elems = {};
	//isLoaded为true时：表示加载完最新简图，并同步在页面上更新完时间戳。反之没有。
	this.isLoaded = false; 
	this.timep = "";
	this.imageUrlPrefix = "";
};
area.prototype = {
	addActiveClass : function() {
		this.elems[this.elemIds[6]].setAttribute("class", "active");
	},
	removeActiveClass : function() {
		this.elems[this.elemIds[6]].setAttribute("class", "");	
	},
	/**
	 * 根据时间戳判断，是否处置标志位。
	 * @param  {String} timep
	 */
	resetIsLoadedByTimep : function(timep) {
		if (timep && this.timep != timep) {
			this.timep = timep;
			this.isLoaded = false;
		}
	},
	loadImage : function() {
		var me = this;
		if (!me.isLoaded) {
			var imageUrl = me.imageUrlPrefix + "&timep=" + getDateTime();
			var timepElem = me.elems[this.elemIds[2]];
			var imgElem = me.elems[this.elemIds[4]];
			var loadingElem = me.elems[this.elemIds[5]];
			timepElem.innerHTML = "---";
			imgElem.style.display = "none";
			loadingElem.style.display = "";
			var image = new Image();
			image.onload = function() {
				me.isLoaded = true;
                imgElem.src = imageUrl;
                imgElem.style.display = "";
                loadingElem.style.display = "none";
                timepElem.innerHTML = me.timep;
                imageUrl = null;
				image.onload = null;
                image.onerror = null;
                image = null;
			};
			image.onerror = function() {
				me.isLoaded = false;
				imageUrl = null;
				image.onload = null;
                image.onerror = null;
                image = null;
				alert("加载简图失败");
			};
			image.src = imageUrl;
//            alert(imageUrl);
		}
	}
};

window.onscroll = function(){ 
	window.scrollTo(0,0)
};

/**
 * 返回毫秒级时间戳
 * @return {Int}
 */
function getDateTime() {
	return new Date().getTime();
};
//通过js调用Objective-C
function settingClick(cmd)
{
    window.location.href="objc://"+cmd;
}
function share(shareText){
    shareTextEncode1 = encodeURI(shareText);
    shareTextEncode2 = encodeURI(shareTextEncode1);
    window.location.href="objc://"+"share:"+":/"+shareTextEncode2;
}
/**
 * 通过在本地存储中保存城市区域key值，记录当前显示简图对应的城市信息
 * @param  {String} key
 */
function saveAreaKey(key) {
	if (isEnableStore) {
		localStore.setItem(STOREKEY, key);
	}
};

/**
 * 返回在本地存储中保存城市区域key值
 * @return {String/Boolean} 
 */
function getAreaKey() {
	if (isEnableStore) {
		return localStore.getItem(STOREKEY);
	} else {
		return false;
	}
};

/**
 * 通过简图唯一ID，获取简图唯一Key
 * @param  {String} routeId 
 * @return {String}
 */
function generalAreaKey(routeId) {
	return "routeid_" + routeId;
};

/**
 * 添加城市区域请求结果数据
 * @param {Array} data
 */
function addAreaData(data) {
	for (var i = 0, len = data.length; i < len; i++) {
		var obj = new area();
		obj.city = data[i].city;
		obj.cityCode = data[i].city_code;
		obj.routeId = data[i].route_id;
		obj.routeName = data[i].route_name;
		var key = generalAreaKey(obj.routeId);
		obj.key = key;
		areas[key] = obj;
		cityCodes.push(data[i].city_code);
	}
};

/**
 * 通过传输简图信息初始化简图界面
 * @param  {String} param JSON字符串
 */
function initByParam(param) {
	if (param) {
		//JSON字符串对象化
		var paramObj = $.parseJSON(param);
		if (paramObj) {
			var areaData = paramObj.area;
			var width = paramObj.width;
			var height = paramObj.height;
			var pixelRatio = paramObj.density || 1;

			if (areaData && areaData.length > 0) {
				setContainer(width, height);
				deviceInfo["width"] = width;
				deviceInfo["height"] = height;
				deviceInfo["density"] = pixelRatio;
				addAreaData(areaData);
				initHtml(areas, deviceInfo);
				initEvents();
				initSwipe();
				inited = true;
				getTime();
				startTimer();
			}
		}
	}
};

/**
 * 设置容器大小
 * @param {Int} width 
 * @param {Int} height
 */
function setContainer(width, height) {
	var trafficContainerW = width || 320;
	var trafficContainerH = height || 360;
	trafficContainerElem.style.width = trafficContainerW + "px";
	trafficContainerElem.style.height = trafficContainerH + "px";
	trafficBgImgElem.style.width = trafficContainerW + "px";
	trafficBgImgElem.style.height = trafficContainerH + "px";
	trafficBgImgElem.style.display = "";
	mySwipeElem.style.top = -trafficContainerH + "px";
	deviceInfo["width"] = trafficContainerW;
	deviceInfo["height"] = trafficContainerH;
};

/**
 * 生成轮播图DOM结构HTML
 * @param  {String} key 城市简图唯一ID
 * @param  {String} area 城市区域名称
 * @param  {String} city 城市名称
 * @param  {int} imageW 简图图片宽度
 * @param  {int} imageH 简图图片高度
 */
function generalHtml(key, area, city, imageW, imageH) {
	var areaElemId = "area_" + key;
	var cityElemId = "city_" + key;
	var timeElemId = "time_" + key;
	var shareElemId = "share_" + key;
	var imgElemId = "img_" + key;
	var loadingElemId = "loading_" + key;
	var liElemId = "li_" + key;

	var htmls = [];
	htmls.push("<div class='wgay' key='" + key+ "'>");
	htmls.push("<div class='t'>");
	htmls.push("<div style='height:30px;width:100%;'>");
	htmls.push("<span class='area'><strong id='" + areaElemId + "'>"+area+"</strong></span>");
	htmls.push("<span class='city'><strong id='" + cityElemId + "'>"+city+"</strong></span></div>");
	htmls.push("<div class='aa'><div style='height:30px;line-height:30px;padding-left:50x;'>发布时间：<span id ='" + timeElemId + "'>---</span></div>");
	htmls.push("<img id='" + shareElemId + "' src='images/icon_share.png' class='img1'/></div>");
	htmls.push("<div class='wimg' style='width:" + imageW + "px;height:" + imageH + "px;text-align:center;'>");
	htmls.push("<img id='" + imgElemId + "' src='images/blank.gif' style='width:" + imageW + "px;height:" + imageH + "px;overflow:hidden;'/>");
	htmls.push("<b id ='" + loadingElemId + "'style='margin:0 auto;position:absolute;top:50%;left:30%;'>正在努力加载中...</b>");
	htmls.push("</div><div class='ly'></div>");

	var tabHtmls = ["<li id='" + liElemId + "'></li>"];

	return {
		html : htmls.join(""),
		tabHtml : tabHtmls.join(""),
		elemIds : [areaElemId, cityElemId, timeElemId, shareElemId, imgElemId, loadingElemId, liElemId]
	};
};

/**
 * 初始化页面结构
 * @param  {Object} data 简图信息
 * @param  {Object} deviceInfo 设备信息
 */
function initHtml(data, deviceInfo) {
	var index = 0;
	var imageW = deviceInfo.width - imgOffsetW;
	var imageH = deviceInfo.height - imgOffsetH;
	var density = deviceInfo.density;
	var urlSuffix = "?width=640&height=480";
	for (var k in data) {
		var key = k;
		var area = data[k];
		area.tabIndex = index;
		if (index == 0) {
			temp_areaKey = key;
		}
		var url = "";
		if (area.cityCode == "000000000") {
			url = REQPICURL + urlSuffix + "&no=" + area.routeId;
		} else {
			url = REQPICURL + urlSuffix + "&cityId=" + area.cityCode + "&id=" + area.routeId;
		}
		area.imageUrlPrefix = url;
		var obj = generalHtml(key, area.city, area.routeName, imageW, imageH);
		indexConElem.append(obj.html);
		tabNavElem.append(obj.tabHtml);
		area.elemIds = obj.elemIds;
		area.elems = initElems(area.elemIds);
		index++;
	}
};

/**
 * 初始化元素
 * @param  {Array} elemIds 元素ID集合
 * @return {Object}
 */
function initElems(elemIds) {
	var elems = {};
	for (var i = 0, len = elemIds.length; i < len; i++) {
		var elemId = elemIds[i];
		elems[elemId] = document.getElementById(elemId);
	}
	return elems;
};

/**
 * 初始化事件监听器
 */
function initEvents() {
	for (var key in areas) {
		var area = areas[key];
		if (area) {
			var shareElem = area.elems[area.elemIds[3]];
			if (shareElem) {
				shareElem.addEventListener("touchstart", function(evt) {
					evt.target.src = "images/icon_share_pressed.png";
				});

				shareElem.addEventListener("touchend", function(evt) {
					var elemId = evt.target.id;
					var areaKey = elemId.substring(elemId.indexOf("_") + 1, elemId.length);
					share(areas[areaKey].city + " " + areas[areaKey].routeName);
					evt.target.src = "images/icon_share.png";
				});
			}
		}
	}
};

/**
 * 初始化轮播图
 */
function initSwipe() {
	var slideNum = 0;
	//延迟请求时间戳定时器
	var timer = null;
	if (isEnableStore) {
		var areaKey = getAreaKey();
		if (areaKey && areas[areaKey]) {
			slideNum = areas[areaKey].tabIndex;
		} else {
			slideNum = 0;
			saveAreaKey(temp_areaKey);
			areaKey = temp_areaKey;
		}
		if (areas[areaKey]) {
			areas[areaKey].addActiveClass();
			save_areaKey = areaKey;
		}
	}
	Swipe(mySwipeElem, {
		startSlide : slideNum,
		continuous : false,
		disableScroll : false,
//		auto:3000,
		callback : function(index, elem) {
			var key = elem.getAttribute("key");
			if (areas[save_areaKey]) {
				areas[save_areaKey].removeActiveClass();
			}
			if (areas[key]) {
				areas[key].addActiveClass();
				save_areaKey = key;
				saveAreaKey(save_areaKey);
			}
		},
        //transitionEnd用于整体轮播图动画结束后触发的回调函数
        transitionEnd: function(index, elem) {
            var key = elem.getAttribute("key");
            saveAreaKey(key);
            if (timer) {
            	window.clearTimeout(timer);
            	timer = null;
            }
            var area = areas[key];
            if (area.timep) {
        		//如果已记录过时间戳，表示已经加载过图幅，需要做延迟请求
            	timer = setTimeout(function() {
            		getTime();
            	}, 30000);
            } else {
            	//如果没有记录过时间戳，表示当前简图从来没有加载过，应该及时请求
            	getTime();
            }
        }
	});
};

/**
 * 获取最新简图时间戳
 */
function getTime() {
	var areaKey = getAreaKey();
	var area = areas[areaKey];
	var param = "?";
	var cityCode = area.cityCode;
	var routeId = area.routeId;
	if (cityCode == "000000000") {
		param = param + "no=" + routeId;
	} else {
		param = param + "cityId=" + cityCode + "&id=" + routeId;
	}
	var reqUrl = REQTIMESTAMPURL + param;
	$.ajax({
		url : reqUrl,
		type : 'get',
		dataType : 'jsonp',
		jsonp : 'callback',
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert("网络不给力,数据请求超时！");
		},
		success : function(result) {
			var timeps = result.time;
			if (timeps) {
				//截取时分时间戳
				var time = timeps.substring(11, 16);
				var routeId = result.id;
				var key = generalAreaKey(routeId);
				var area = areas[key];
				area.resetIsLoadedByTimep(time);
				area.loadImage();
				// for (var i = 0, len = timeps.length; i < len; i++) {
				// 	var cityCode = timeps[i].cityid;
				// 	for (var k in areas) {
				// 		if (areas[k].cityCode == cityCode) {
				// 			areas[k].resetIsLoadedByTimep(timeps[i].timep);
				// 		}
				// 	}
				// }
			}
		}
	});	
};

/**
 * 刷新简图信息
 */
function reflesh() {
	if (inited) {
		getTime();	
	}
};

/**
 * 定时刷新简图信息
 */
function startTimer() {
	setInterval(function() {
		reflesh();
	}, 5 * 60 * 1000);
};

$(function() {
//	initByParam(paramDemo);

	var setElem = document.getElementById("setting");
	var refreshElem = document.getElementById("refresh");
	setElem.addEventListener("touchstart", function(evt) {
		evt.target.src = "images/icon_setting_pressed.png";
	});
	setElem.addEventListener("touchstart", function(evt) {
		evt.target.src = "images/icon_setting.png";
		settingClick('goSetting');
	});
	refreshElem.addEventListener("touchstart", function(evt) {
		evt.target.src = "images/icon_refresh_pressed.png";
	});
	refreshElem.addEventListener("touchstart", function(evt) {
		evt.target.src = "images/icon_refresh.png";
		reflesh();
	});
});