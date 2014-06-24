 (function(window) {
    function UserInfoManager() {
        this.userinfo = null;
        this.ua = null;
        this.pid = null;
    };
    UserInfoManager.prototype = {
        setInfo : function(data) {
            this.userinfo = data;
        },
        setPid : function(pid) {
            this.pid = pid;
        },
        setUa : function(ua) {
            this.ua = ua;
        }
    };

    function PageManager() {
        //ID元素对象集合
        this.elems = {
            "backpagebtn" : null,
            "ruleride" : null
        };
        //当点击请求提示框的关闭按钮，意味着中断请求，在关闭提示框后，如果请求得到响应，也不进行下一步业务处理。
        this.isStopReq = false;
        //页面对象是否初始化完成
        this.inited = false;
    };
    PageManager.prototype = {
        /**
         * 初始化页面对象
         */
        init : function() {
            var me = this;
            me.userInfoManager = new UserInfoManager();
            me.initElems();
            me.initEvents();
            me.inited = true;
        },
        /**
         * 初始化页面元素对象
         */
        initElems : function() {
            var me = this,
                elems = me.elems;
                me.elems = Trafficeye.queryElemsByIds(elems);
        },
        
        /**
         * 初始化页面元素事件
         */
        initEvents : function() {
            var me = this,
                backpagebtnElem = me.elems["backpagebtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
        },
        /**
         * 按钮按下事件处理器
         * @param  {Event} evt
         */
        btnDown : function(evt) {
            this.addClass("curr");
        },
        backpagebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            var fromSource = Trafficeye.fromSource();
            Trafficeye.toPage(fromSource.sourcepage);
        },
        //跳转到我要搭车，请求要是送人的请求,type为2
        carpool : function(evt) {
            var me = this;
            //把来源信息存储到本地
             var fromSource = {"flag" : "ride","type" : "2"};
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_pcar_flag", fromSourceStr);
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                if(document.getElementById("ruleride").checked){
                    Trafficeye.toPage("pcar_ride.html");
                }else{
                    Trafficeye.trafficeyeAlert("请阅读并同意《路况交通眼》拼车服务条款");
                }
            }),Trafficeye.MaskTimeOut);     
        },
        //我能送人，跳转到送人的节目，请求是搭车的请求，type为1
        passenger : function(evt) {
            var me = this;
            var fromSource = {"flag" : "away","type" : "1"};
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_pcar_flag", fromSourceStr);
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                // Trafficeye.toPage("pcar_ride.html");
                if(document.getElementById("ruleride").checked){
                    Trafficeye.toPage("pcar_ride.html");
                }else{
                    Trafficeye.trafficeyeAlert("请阅读并同意《路况交通眼》拼车服务条款");
                }
            }),Trafficeye.MaskTimeOut);     
        },
        //我的发布
        publish : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                if(document.getElementById("ruleride").checked){
                    Trafficeye.toPage("pcar_mypublish.html");
                }else{
                    Trafficeye.trafficeyeAlert("请阅读并同意《路况交通眼》拼车服务条款");
                }
            }),Trafficeye.MaskTimeOut);     
        },
         //发布拼车信息
         publishInfo: function(evt) {
             var me = this;
             var elem = $(evt).addClass("curr");
             setTimeout((function() {
                 $(elem).removeClass("curr");
                 //清楚缓存信息
                 if(document.getElementById("ruleride").checked){
                     Trafficeye.offlineStore.remove("publishInfo_week");
                     Trafficeye.offlineStore.remove("publishInfo_time");
                     Trafficeye.offlineStore.remove("publishInfo_startloc");
                     Trafficeye.offlineStore.remove("publishInfo_endloc");
                     Trafficeye.offlineStore.remove("publishInfo_type");
                     Trafficeye.toPage("pcar_publishinfo.html");
                }else{
                    Trafficeye.trafficeyeAlert("请阅读并同意《路况交通眼》拼车服务条款");
                }
             }), Trafficeye.MaskTimeOut);
         }
    };
    
    $(function(){
         Trafficeye.httpTip.closed();
         // 初始化页面函数
        window.callbackInitPage = function(isLogin,usersInfoClient,ua,pid,dataClient){
            Trafficeye.httpTip.closed();
        
            // alert(isEdit);
            if(isLogin == 0){
                var dataClient1 = Trafficeye.str2Json(dataClient);
                //pid,ua,userinfo存入到浏览器本地缓存
                var userinfodata = {
                    "pid" : pid,
                    "ua" : ua,
                    "uid" : "",
                    "userinfo" : "",
                    "dataclient" : dataClient1
                };
                var dataStr = Trafficeye.json2Str(userinfodata);
                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
               // Trafficeye.trafficeyeAlert("未登录,请您重新登录");
            }else if(isLogin == 1)//蒙版效果暂不取消，跳转到pre_info.html页面再取消
            {
                var data = Trafficeye.str2Json(usersInfoClient);
                var dataClient1 = Trafficeye.str2Json(dataClient);
                //pid,ua,userinfo存入到浏览器本地缓存
                var userinfodata = {
                    "pid" : pid,
                    "ua" : ua,
                    "uid" : data.uid,
                    "userinfo" : data,
                    "dataclient" : dataClient1
                };
                var dataStr = Trafficeye.json2Str(userinfodata);
                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
            }else if(isLogin == 2){
                var userinfodata = {
                    "pid" : pid,
                    "ua" : ua,
                    "uid" : "",
                    "userinfo" : "",
                    "dataclient" : ""
                };
                var dataStr = Trafficeye.json2Str(userinfodata);
                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
                Trafficeye.httpTip.opened();
                Trafficeye.trafficeyeAlert("正在登录中,请稍后");
            }
        };
        
        window.initPageManager = function() {
            Trafficeye.httpTip.closed();
            //把来源信息存储到本地
             var fromSource = {"sourcepage" : "pcar_index.html","currpage" : "pcar_index.html","prepage" : "pcar_index.html"}
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);

            var pm = new PageManager();

            Trafficeye.pageManager = pm;
            //初始化用户界面
            pm.init();
            //启动等待动画，等待客户端回调函数            
            //Trafficeye.httpTip.opened();
        };
        
        window.publish = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.publish(evt);
            }
        };
        
        window.passenger = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.passenger(evt);
            }
        };
        
        window.carpool = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.carpool(evt);
            }
        };
        
        window.term = function(evt) {
            if (Trafficeye.mobilePlatform.android) {
                window.JSAndroidBridge.gotoServicePage();
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                window.location.href=("objc:??gotoServicePage");
            } else {
                alert("调用修改用户信息接口,PC不支持.");
            }
        };
        
        //发布
         window.publishInfo = function(evt) {
             var pm = Trafficeye.pageManager;
             if (pm.init) {
                 pm.publishInfo(evt);
             }
         };
        
        window.initPageManager();
        // window.callbackInitPage(1,"{\"badgeNum\":12,\"avatarUrl\":\"http://mobile.trafficeye.com.cn/media/avatars/29178/image.jpg\",\"wxNum\":\"建立起来\",\"level\":18,\"eventNum\":43,\"mobile\":\"13581604288\",\"frineds\":16,\"idNum\":\"\",\"totalMilage\":1147.8,\"nextLevel\":19,\"city\":\"福建 永泰县\",\"realName\":\"董杉\",\"ownedBadges\":[{\"name\":\"诚信用户\",\"id\":2,\"obtainTime\":\"2014-03-23 20:53:24\",\"smallImgName\":\"badge_register_complete.png\",\"imgName\":\"badge_big_register_complete.png\",\"desc\":\"个人资料完整度100%\"},{\"name\":\"上报 20 件交通事件\",\"id\":21,\"obtainTime\":\"2013-10-15 15:59:41\",\"smallImgName\":\"badge_event_20.png\",\"imgName\":\"badge_big_event_20.png\",\"desc\":\"上报 20 件交通事件\"},{\"name\":\"上报 10 件交通事件\",\"id\":22,\"obtainTime\":\"2013-10-14 16:00:58\",\"smallImgName\":\"badge_event_10.png\",\"imgName\":\"badge_big_event_10.png\",\"desc\":\"上报 10 件交通事件\"},{\"name\":\"路况贡献 100km\",\"id\":27,\"obtainTime\":\"2013-09-29 16:55:02\",\"smallImgName\":\"badge_track_100km.png\",\"imgName\":\"badge_big_track_100km.png\",\"desc\":\"路况贡献 100km\"},{\"name\":\"上报 5 件交通事件\",\"id\":23,\"obtainTime\":\"2013-09-11 17:25:14\",\"smallImgName\":\"badge_event_5.png\",\"imgName\":\"badge_big_event_5.png\",\"desc\":\"上报 5 件交通事件\"},{\"name\":\"路况贡献 50km\",\"id\":28,\"obtainTime\":\"2013-08-29 15:02:45\",\"smallImgName\":\"badge_track_50km.png\",\"imgName\":\"badge_big_track_50km.png\",\"desc\":\"路况贡献 50km\"},{\"name\":\"路况贡献 10km\",\"id\":29,\"obtainTime\":\"2013-08-28 18:56:24\",\"smallImgName\":\"badge_track_10km.png\",\"imgName\":\"badge_big_track_10km.png\",\"desc\":\"路况贡献 10km\"},{\"name\":\"一鸣惊人\",\"id\":4,\"obtainTime\":\"2013-08-09 18:32:24\",\"smallImgName\":\"badge_weibo_first.png\",\"imgName\":\"badge_big_weibo_first.png\",\"desc\":\"第一次分享微博\"},{\"name\":\"首次上报交通事件\",\"id\":17,\"obtainTime\":\"2013-08-09 18:31:52\",\"smallImgName\":\"badge_event_1.png\",\"imgName\":\"badge_big_event_1.png\",\"desc\":\"首次上报交通事件\"},{\"name\":\"忠实用户\",\"id\":3,\"obtainTime\":\"2013-07-17 10:44:10\",\"smallImgName\":\"badge_login_7days.png\",\"imgName\":\"badge_big_login_7days.png\",\"desc\":\"连续七日登录\"},{\"name\":\"路况贡献 3km\",\"id\":30,\"obtainTime\":\"2013-07-14 15:51:20\",\"smallImgName\":\"badge_track_3km.png\",\"imgName\":\"badge_big_track_3km.png\",\"desc\":\"路况贡献 3km\"},{\"name\":\"新人徽章\",\"id\":1,\"obtainTime\":\"2013-07-11 14:31:49\",\"smallImgName\":\"badge_register.png\",\"imgName\":\"badge_big_register.png\",\"desc\":\"注册账号\"}],\"email\":\"\",\"totalBadges\":30,\"totalTrackMilage\":321,\"fans\":14,\"carNum\":\"海伦凯勒15\",\"totalCoins\":0,\"username\":\"董小杉\",\"userType\":\"sinaweibo\",\"levelPoint\":2222,\"levelPercent\":68,\"uid\":\"29178\",\"birthdate\":\"1988-07-11\",\"gender\":\"M\",\"totalPoints\":2451,\"nextLevelPoint\":2555,\"mobileValidate\":1,\"qq\":\"16685265\",\"description\":\"\",\"userGroup\":0}","I_7.1,i_2.2.6","A527E98B-27AC-47AA-9293-AACAE23BAB59","{\"lon\":\"116.407923\",\"lat\":\"39.909103\"}");
        }); 
    
 }(window));