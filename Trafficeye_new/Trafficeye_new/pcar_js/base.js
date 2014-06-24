(function(window) {
    var global = this;
    if (typeof Trafficeye === "undefined") {
        global.Trafficeye = {}
    }
    Trafficeye.global = global;

    var emptyFn = function() {};

    var mobilePlatform = {
        android: /android/i.test(navigator.userAgent),
        ipad: /ipad/i.test(navigator.userAgent),
        iphone: /iphone/i.test(navigator.userAgent),
        wphone: /Windows Phone/i.test(navigator.userAgent)
    };
    
    var UrlPort = 21290; //正式URL端口号为21290,测试URL端口号为8008,此处为了消息,加关注使用
    var BASE_RIDE_URL = "http://mobile.trafficeye.com.cn:8000";//正式的URL
   // var BASE_RIDE_URL = "http://mobile.trafficeye.com.cn:8008/TrafficeyeSevice_test";//测试的URL
 
   var BASE_USER_URL = "http://mobile.trafficeye.com.cn:8000/user/v4/";//正式的URL
    // var BASE_USER_URL = "http://mobile.trafficeye.com.cn:8008/TrafficeyeSevice_test/user/v4/";//测试的URL
 
 
    var MaskTimeOut = 1000; //蒙版效果等待时间
        
    /**
     * 判断是否是移动平台
     */
    var isMobilePlatform = (function() {
        return mobilePlatform.android || mobilePlatform.ipad || mobilePlatform.iphone || mobilePlatform.wphone;
    })();

    /**
     * 获得兼容PC事件名称
     * @return {String}
     */
    function getPlatformEventName(evtName) {
        var evtNames = {
            "tap": "click",
            "touchstart": "mousedown",
            "touchmove": "mousemove",
            "touchend": "mouseup",
            "doubleTap": "dblclick",
            "longTap": "dblclick"
        };
        if (isMobilePlatform) {
            return evtName;
        } else {
            return evtNames[evtName];
        }
    };

    (function($) {
        /**
         * 扩展Zepto事件绑定功能，支持PC事件
         * @param  {Sting} evtName 事件名称
         * @param  {function} fn 事件处理函数
         * @param  {Object} scope 事件处理函数作用域
         * @param  {Object} data 回传到事件处理函数的参数对象
         */
        $.fn.onbind = function(evtName, fn, scope, data) {
            var evtName = getPlatformEventName(evtName);
            fn = fn || emptyFn;
            var me = $(this);
            scope = scope || me;
            me.on(evtName, function(evt) {
                fn.apply(scope, [evt, me, data]);
                return false;
            });
        };
    })(Zepto);

    /**
     * 通过元素ID查找元素对象
     * @param  {Object} elems
     * @return {Object}
     * remark:
     * 对象格式为JSON格式：{"元素ID", "元素对象"}
     */
    function queryElemsByIds(elems) {
        if (elems) {
            for (var id in elems) {
                elems[id] = $("#" + id);
            }
        }
        return elems;
    };

    /**
     * 预加载图片资源
     * @param  {Zepto} imgElem Img元素对象
     * @param  {String} imgUrl 图片资源URL
     * @param  {Object} opts 可选参数
     * opts属性：
     * success ：图片加载成功后的回调函数
     * fail ：图片加载失败后的回调函数
     * scope ：回调函数的作用域，默认是Trafficeye对象
     */
    function imageLoaded(imgElem, imgUrl, opts) {
        if (!imgElem) {
            return;
        }
        var imgObj = new Image(),
            me = this,
            success = emptyFn,
            fail = emptyFn,
            scope = me;
        if (opts) {
            success = opts.success ? opts.success : emptyFn;
            fail = opts.fail ? opts.fail : emptyFn;
            scope = opts.scope ? opts.scope : me;
        }

        if (imgUrl) {
            imgObj.onload = function() {
                imgElem.attr("src", imgUrl);
                success.call(scope);
                imgObj.onload = null;
                imgObj.onerror = null;
                imgObj = null;
            };
            imgObj.onerror = function() {
                fail.call(scope);
                imgObj.onload = null;
                imgObj.onerror = null;
                imgObj = null;
            }
            imgObj.src = imgUrl;
        } else {
            fail.call(scope);
        }
    };

    /**
     * JSON对象转字符串
     * @param {JSON Object} data JSON对象
     * @return {String}
     */
    function json2Str(obj) {
        if (obj != null || obj != undefined) {
            //console.log(obj);
            // var strs = ['{'];
            // for (var k in data) {
            //     strs.push('"' + k + '":"' + (data[k] || null) + '",')
            // }
            // var str = strs.join("");
            // return str.substr(0, str.length - 1) + '}';
            switch (typeof(obj)) {
                case 'string':
                    return '"' + obj.replace(/(["\\])/g, '\\$1') + '"';
                case 'array':
                    return '[' + obj.map(json2Str).join(',') + ']';
                case 'object':
                    if (obj instanceof Array) {
                        var strArr = [];
                        var len = obj.length;
                        for (var i = 0; i < len; i++) {
                            strArr.push(json2Str(obj[i]));
                        }
                        return '[' + strArr.join(',') + ']';
                    } else if (obj == null) {
                        //return 'null';  
                        return 'null';
                        //return 'abc';
                    }else {
                        var string = [];
                        for (var property in obj) {
                            var objVal = json2Str(obj[property]);
                            if (objVal == undefined) {
                                objVal = '\"\"';
                                //objVal = null;
                            }
                            string.push(json2Str(property) + ':' + objVal);
                        }
                        return '{' + string.join(',') + '}';
                    }
                case 'number':
                    return obj;
                case false:
                    return obj;
            }
        }
    };

    /**
     * JSON对象字符串转化为JSON对象
     * @param  {String} data
     * @return {JSON Object}
     */
    function str2Json(data) {
        if (data) {
            return $.parseJSON(data);
        }
    };
    
    /**
     * 弹屏提示
     * @param  {String} data
     * @return {JSON Object}
     */
    function trafficeyeAlert(data) {
         if (mobilePlatform.android) {
                alert(data);
            } else if (mobilePlatform.iphone || mobilePlatform.ipad) {
                var content = encodeURI(encodeURI(data));
                toPage("objc:??showAlert::?"+content); 
            } else {
                alert(data);
            }
    };

    /**
     * 返回毫秒级时间戳
     * @return {Int}
     */
    function getDateTime() {
        return new Date().getTime();
    };

    /**
     * Http请求参数数据对象转换成字符串
     * @param  {JSON Object} data
     */
    function httpData2Str(data) {
        var strs = ["?"];
        if (data) {
            for (var key in data) {
                strs.push(key + "=" + data[key] + "&");
            }
        }
        var timer = "callback=?&timer=" + getDateTime();
        strs.push(timer);
        return strs.join("");
    };

    $(window).on("touchstart", function(evt) {
        if (httpTip.isOpened) {
            evt.preventDefault();
        }
    });

    var httpTip = {
        tipHTML: "<div id='httptipid' class='prompt_mask' style='position:fixed;z-index:1000;'><div class='p_load'><div class='loadimg'><span></span></div><div class='loadtext'>正在加载...</div><div id='closedtipbtn' class='loadqx'></div></div></div>",
        isOpened: false,
        isInit: false,
        tipElem: null,
        closedElem: null,
        closedFun: null,
        closedScope: null,
        opened: function(fun, scope) {
            var me = this;
            me.closedFun = fun || me.closedFun || emptyFn;
            me.closedScope = scope || me.closedScope || me;
            if (!me.isInit) {
                me.isInit = true;
                me.isOpened = true;
                $(document.body).append(me.tipHTML);
                setTimeout(function() {
                    me.tipElem = $("#httptipid");
                    me.closedElem = $("#closedtipbtn");
                    var evtName = getPlatformEventName("touchstart");
                    me.closedElem.on(evtName, function(evt) {
                        me.closed();
                        me.closedFun.call(me.closedScope, evt);
                        return false;
                    });
                }, 10);
            } else {
                me.isOpened = true;
                if (!me.tipElem) {
                    me.tipElem = $("#httptipid");
                }
                me.tipElem.show();
            }
        },
        closed: function() {
            this.isOpened = false;
            if (!this.tipElem) {
                this.tipElem = $("#httptipid");
            }
            this.tipElem.hide();
        }
    };

    var localStore = window.localStorage,
        undefinedType = void 0,
        isEnableStore = "localStorage" in window && localStore !== null && localStore !== undefinedType;
    //离线存储控制器
    var offlineStore = {
        _isEnableStore_: isEnableStore,
        /**
         * 离线存储某值
         * @param {String} key 存储的值索引
         * @param {String} value 存储的值
         * @private
         */
        set: function(key, value) {
            if (isEnableStore) {
                //删除本地以前存储的JS模块信息，先removeItem后setItem防止在iphone浏览器上报错
                for (var name = key, len = localStore.length, id; len--;) {
                    id = localStore.key(len); - 1 < id.indexOf(name) && localStore.removeItem(id);
                }
                try {
                    if (value) {
                        localStore.setItem(key, value);
                    }
                } catch (error) {
                    localStore.clear();
                }
            }
        },
        //清楚本地缓存
        remove: function(key){
            localStore.removeItem(key);
        },
        /**
         * 根据关键字获取某值
         * @param {String} key 关键字
         * @return {*}
         * @private
         */
        get: function(key) {
            return isEnableStore && this.isExist(key) ? localStore.getItem(key) : false;
        },
        /**
         * 根据关键字判断是否有本地存储
         * @param {String} key 关键字
         * @return {Boolean}
         * @private
         */
        isExist: function(key) {
            return isEnableStore && !! localStore[key];
        }
    };

    /**
     * 分页管理器类
     */
    function PageNumManager() {
        //分页起始条目
        this.start = 0;
        //每页显示个数
        this.BASE_NUM = 10;
        //微博界面显示个数
        this.BASE_WEIBO_NUM = 50;
        //是否显示加载更多按钮
        this.isShowBtn = false;
    };
    PageNumManager.prototype = {
        /**
         * 重置分页管理信息
         */
        reset: function() {
            this.start = 0;
            this.isShowBtn = false;
        },
        getStart: function() {
            return this.start;
        },
        getEnd: function() {
            return this.BASE_NUM + this.start - 1;
        },
        getWeiboEnd: function() {
            return this.BASE_WEIBO_NUM + this.start - 1;
        },
        setIsShowBtn: function(flag) {
            this.isShowBtn = flag;
        },
        getIsShowBtn: function() {
            return this.isShowBtn;
        }
    };

    /**
     * 从本地存储获取用户信息对象
     *
     * {
    "username": "傲梅雪舞", //用户昵称
    "avatar": "http://mobile.trafficeye.com.cn/media/test/avatars/22376/image.jpg", //用户头像图片
    "gender": "F", //用户性别
    "usertype": "1", //用户类型
    "friends_count": "4", //用户关注数量
    "followers_count": "0", //用户粉丝数量
    "uid": 22376, //用户ID
    "pid": 353617052835307 //用户PID
}
     */
    function getMyInfo() {
        var myInfoStr = offlineStore.get("traffic_myinfo");
        return str2Json(myInfoStr);
    };
    //判断页面来源
    function fromSource() {
        var myInfoStr = offlineStore.get("traffic_fromsource");
        return str2Json(myInfoStr);
    };

    /**
     * 跳转页面
     * @param  {[type]} url [description]
     * @return {[type]}     [description]
     */
    function toPage(url) {
        if (url) {
            setTimeout(function() {
                window.location.href = url;
            }, 1);
        }
    };

    Trafficeye.pageManager = null;
    Trafficeye.PageNumManager = PageNumManager;
    Trafficeye.mobilePlatform = mobilePlatform;
    Trafficeye.imageLoaded = imageLoaded;
    Trafficeye.queryElemsByIds = queryElemsByIds;
    Trafficeye.getDateTime = getDateTime;
    Trafficeye.httpData2Str = httpData2Str;
    Trafficeye.httpTip = httpTip;
    Trafficeye.offlineStore = offlineStore;
    Trafficeye.json2Str = json2Str;
    Trafficeye.str2Json = str2Json;
    Trafficeye.getMyInfo = getMyInfo;
    Trafficeye.fromSource = fromSource;
    Trafficeye.toPage = toPage;
    Trafficeye.trafficeyeAlert = trafficeyeAlert;
    Trafficeye.BASE_RIDE_URL = BASE_RIDE_URL;
    Trafficeye.BASE_USER_URL = BASE_USER_URL;
    Trafficeye.UrlPort = UrlPort;
    Trafficeye.MaskTimeOut = MaskTimeOut;
}(window));