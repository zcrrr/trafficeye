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
            "infoa" : null,
            "infob" : null,
            "infoc" : null,
            "infod" : null
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
                infoabtnElem = me.elems["infoa"],
                infobbtnElem = me.elems["infob"],
                infocbtnElem = me.elems["infoc"],
                infodbtnElem = me.elems["infod"],
                backpagebtnElem = me.elems["backpagebtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            infoabtnElem.onbind("touchstart",me.btnDown,infoabtnElem);
            infoabtnElem.onbind("touchend",me.infoabtnUp,me);
            infobbtnElem.onbind("touchstart",me.btnDown,infobbtnElem);
            infobbtnElem.onbind("touchend",me.infobbtnUp,me);
            infocbtnElem.onbind("touchstart",me.btnDown,infocbtnElem);
            infocbtnElem.onbind("touchend",me.infocbtnUp,me);
            infodbtnElem.onbind("touchstart",me.btnDown,infodbtnElem);
            infodbtnElem.onbind("touchend",me.infodbtnUp,me);
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
        infoabtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
             me.elems["infoa"].addClass("highlight");
             me.elems["infob"].removeClass("highlight");
             me.elems["infoc"].removeClass("highlight");
             me.elems["infod"].removeClass("highlight");
            var fromSource = {"whichCar" : "A"}
            var fromSourceStr = Trafficeye.json2Str(fromSource);
            Trafficeye.offlineStore.set("survey_whichCar", fromSourceStr);
        },
        infobbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
             me.elems["infoa"].removeClass("highlight");
             me.elems["infob"].addClass("highlight");
             me.elems["infoc"].removeClass("highlight");
             me.elems["infod"].removeClass("highlight");
            var fromSource = {"whichCar" : "B"}
            var fromSourceStr = Trafficeye.json2Str(fromSource);
            Trafficeye.offlineStore.set("survey_whichCar", fromSourceStr);
        },
        infocbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
             me.elems["infoa"].removeClass("highlight");
             me.elems["infob"].removeClass("highlight");
             me.elems["infoc"].addClass("highlight");
             me.elems["infod"].removeClass("highlight");
            var fromSource = {"whichCar" : "C"}
            var fromSourceStr = Trafficeye.json2Str(fromSource);
            Trafficeye.offlineStore.set("survey_whichCar", fromSourceStr);
        },
        infodbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
             me.elems["infoa"].removeClass("highlight");
             me.elems["infob"].removeClass("highlight");
             me.elems["infoc"].removeClass("highlight");
             me.elems["infod"].addClass("highlight");
            var fromSource = {"whichCar" : "D"}
            var fromSourceStr = Trafficeye.json2Str(fromSource);
            Trafficeye.offlineStore.set("survey_whichCar", fromSourceStr);
        },
        //保存用户昵称
        saveFunction : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                var whichCar = Trafficeye.offlineStore.get("survey_whichCar");
                var prize = Trafficeye.str2Json(whichCar);
                var url = Trafficeye.BASE_USER_URL + "updatePrize";
                var myInfo = Trafficeye.getMyInfo();
                var data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "uid" : myInfo.uid,
                "income" : "",
                "ways" : "",
                "driveTime" : "",
                "whichCar" : prize.whichCar,
                "brand" : "",
                "buyTime" : "",
                "licenseTime" : ""
                };
                me.saveSurveyFunction(url,data);
            }),Trafficeye.MaskTimeOut);     
        },
        /**
         * 用户信息修改请求函数
         */
        saveSurveyFunction : function(url,data) {
            var me = this;
            var reqParams = Trafficeye.httpData2Str(data);
            if (url) {
                Trafficeye.httpTip.opened(function() {
                                     me.isStopReq = true;
                                }, me);
                                me.isStopReq = false;
                var reqUrl = url + reqParams;
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        Trafficeye.httpTip.closed();
                        if (data && !me.isStopReq) {
                            var state = data.state.code;
                            if (state == 0) {
                                //更新用户信息成功
                                // Trafficeye.trafficeyeAlert(data.state.desc);
                                var myInfo = Trafficeye.getMyInfo();
                                //把用户信息写入到本地
                                //pid,ua,userinfo存入到浏览器本地缓存
                                var userinfodata = {
                                    "pid" : myInfo.pid,
                                    "ua" : myInfo.ua,
                                    "uid" : myInfo.uid,
                                    "friend_uid" : data.userInfo.uid,
                                    "isEdit" : myInfo.isEdit,
                                    "userinfo" : data.userInfo
                                };
                                var dataStr = Trafficeye.json2Str(userinfodata);
                                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
                                //写入用户信息和徽章，里程信息到浏览器缓存
                                var dataReward = Trafficeye.json2Str(data.reward);
                                var dataUserInfo = Trafficeye.json2Str(data.userInfo);
//                                console.log(dataReward);
                                Trafficeye.offlineStore.set("traffic_reward",dataReward);
                                if (Trafficeye.mobilePlatform.android) {
                                    window.JSAndroidBridge.updateUserInfo(dataUserInfo,dataReward);
                                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                                    var rewardContent = encodeURI(encodeURI(dataReward));
                                    var content = encodeURI(encodeURI(dataUserInfo));
                                    window.location.href=("objc:??updateUserInfo::?"+content+":?"+rewardContent);
                                } else {
                                    alert("调用修改用户信息接口,PC不支持.");
                                }
                                Trafficeye.offlineStore.set("traffic_infosurveycar","survey");
                                Trafficeye.toPage("pre_baseinfo.html");
                            } else{
                                Trafficeye.trafficeyeAlert(data.state.desc+"("+data.state.code+")");
                            }
                        } else {
                            //me.reqPraiseFail();
                        }
                    }
                })
            } else {
               // me.reqPraiseFail();
            }
        }
    };
    
    $(function(){

         //获取我的用户信息
        var myInfo = Trafficeye.getMyInfo();
        if (!myInfo) {
            return;
        }
        
        var pm = new PageManager();

        Trafficeye.pageManager = pm;
        //初始化用户界面
        pm.init();
                //判断缓存中是否有userinfo信息
        if(myInfo.userinfo){
            Trafficeye.offlineStore.set("traffic_infosurveycar","survey");
        }else{
            //让用户重新登录
            Trafficeye.toPage("pre_login.html");
        }
        
        window.saveFunction = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.saveFunction(evt);
            }
        };
        
    }); 
    
 }(window));