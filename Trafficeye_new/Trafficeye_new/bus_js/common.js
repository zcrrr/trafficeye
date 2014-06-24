/**
 * 公交换乘公共JS库，依赖于zepto。
 */
(function() {
	//定义命名空间
	var NAMESPACE = "DRAGON";
	window["_MYNAMESPACE_"] = NAMESPACE;
	var myCommon = window[NAMESPACE] = window[NAMESPACE] || {};

	//定义空函数
	var emptyFun = function(){};

	var isSupportTouch = "createTouch" in document;

	var navigator = window.navigator;

	myCommon.mobilePlatform = {
		//当浏览器运行在iPhone时，iPhone为true；
		iPhone : /iPhone/i.test(navigator.platform),
		//当浏览器运行在Android时，Android为true；
		android : /Android/i.test(navigator.userAgent)
	};

	/**
	 * 返回浏览器支持的事件名称
	 * @param {String} eventName 
	 */
	function getBrowserEventName(eventName) {
		var eventNameMapping = {
			click : "touchend",
			mousedown : "touchstart",
			mouseup : "touchend",
			mousemove : "touchmove"
		};
		if (isSupportTouch) {
			return eventNameMapping[eventName] || eventName;
		}
		return eventName;
	};

	/**
	 * 返回时间戳
	 */
	function getTimetemp() {
		return new Date().getTime();
	};
	/**
	 * 兼容移动浏览器的事件机制
	 */
	myCommon.eventUtil = {
		/**
		 * 注册浏览器事件
		 * @param {String | Zepto} obj 元素ID或者Zepto对象
		 * @param {String} eventName 事件名称
		 * @param {Function} cbkFun 回调函数
		 * @param {Object} scope 作用域 默认为元素的zepto对象
		 * @param {Object} data 回传给回调函数的数据
		 * 
		 */
		addEventListener : function(obj, eventName, cbkFun, scope, data) {
			eventName = getBrowserEventName(eventName);
			var objType = $.type(obj);
			if (objType == "string") {
				obj = $("#" + obj);
			}
			scope = scope || obj;
			var myCbkFun = function(evt) {
				cbkFun.call(scope, evt, data);
			};
			obj.on(eventName, myCbkFun);
			return myCbkFun;
		},
		/**
		 * 清除DOM元素上注册某浏览器事件的所有监听器
		 * @param {String | Zepto} obj 元素ID或者Zepto对象
		 * @param {String} eventName 事件名称
		 * @param {Function} cbkFun 回调函数
		 * @param {Object} scope 作用域 默认为元素的zepto对象
		 * @param {Object} data 回传给回调函数的数据
		 */
		cleanEventListener : function(obj, eventName, cbkFun, scope, data) {
			var objType = $.type(obj);
			if (objType == "string") {
				obj = $("#" + obj);
			}
			obj.off();
			if (cbkFun) {
				scope = scope || obj;
				cbkFun.call(scope, data);
			}
		}
	};

	/**
	 * Http请求
	 */
	myCommon.httpUtil = {
		/**
		 * 发送JSONP请求
		 * @param  {String} url 请求的URL
		 * @param  {JSON Object} params 请求参数的JSON对象
		 * @param  {Function} cbkFun 请求得到响应后的回调函数
		 * @param  {Object} scope 回调函数的作用域
		 * @param  {Object} data 传入回调函数的参数
		 *
		 * 回调函数格式：
		 * function (res, data) {}
		 * res：请求响应后的数据
		 * data：参数data的值
		 */
		sendJsonpRequest : function(url, params, cbkFun, scope, data) {
			var myCbkFun = emptyFun;
			scope = scope || this;
			params = params || {};
			params.timer = getTimetemp();
			if (cbkFun) {
				myCbkFun = function(result) {
					cbkFun.call(scope, result, data);
				}
			}
			var cfg = {
				url : url,
				data : params,
				dataType : "jsonp",
				success : myCbkFun
			};
			$.ajax(cfg);
		}
	};

	/**
	 * 离线存储
	 */
	var	localStore = window.localStorage,
		undefinedType = void 0,
		isEnableStore = "localStorage" in window && localStore !== null && localStore !== undefinedType;
	myCommon.offlineStore = {
		 isEnableStore : isEnableStore,
		 set : function(key, value) {
			if (isEnableStore) {
				try {
					localStore.setItem(key, value);
				} catch (error) {
					localStore.clear();
				}
			}
		 },
		 get : function(key) {
			return isEnableStore && this.isExist(key) ? localStore.getItem(key) : false;
		 },
		 isExist : function(key) {
			return isEnableStore && !! localStore[key];
		 },
		 clean : function() {
		 	localStore.clear();
		 },
		 remove : function(key) {
		 	localStore.removeItem(key);
		 }
	};

	/**
	 * JSON工具
	 * @type {Object}
	 */
	myCommon.jsonUtil = {
		toJsonObj : function(str) {
			return JSON5.parse(str);
		},
		toJsonStr : function(obj) {
			return JSON5.stringify(obj);
		}
	};

	/**
	 * 跳转页面工具
	 * @type {Object}
	 */
	myCommon.pageUtil = {
		toPage : function(url) {
			window.location.href = url;
		}
	};

	var getDataTime = function() {
		var date = new Date();
		var month = date.getMonth()+1;
		if (month < 10) {
			month = "0" + month;
		} else {
			month = month.toString();
		}
		var d = date.getDate();
		if (d < 10) {
			d = "0" + d;
		} else {
			d = d.toString();
		}
		var hour = date.getHours();
		if (hour < 10) {
			hour = "0" + hour;
		} else {
			hour = hour.toString();
		}
		var min = date.getMinutes();
		if (min < 10) {
			min = "0" + min;
		} else {
			min = min.toString();
		}
		return date.getFullYear().toString() + month + d + hour + min;
	};

	/**
	 * 获取服务基础URL
	 */
	myCommon.getServerUrl = {
		key : "http://www.trafficeye.com.cn/fkgis-gateway/",
		tipKey : "/gis/smarttips.json",
		keyQueryKey : "/gis/keyquery.json",
		coordKey : "/gis/coordinate/encryption.json",
		bustransferquery : "/gis/busquery/bustransferquery.json",
		tipUrl : function() {
			var token = "TYMON_" + getDataTime();
			return this.key + token + this.tipKey;
		},
		keyQueryUrl : function() {
			var token = "TYMON_" + getDataTime();
			return this.key + token + this.keyQueryKey;
		},
		coordTranUrl : function() {
			var token = "TYMON_" + getDataTime();
			return this.key + token + this.coordKey;
		},
		bustransferQueryUrl : function() {
			var token = "TYMON_" + getDataTime();
			return this.key + token + this.bustransferquery;	
		}
	};
}());