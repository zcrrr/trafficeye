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
            "verifynumber" : null,
            "sendsms" : null,
            "limittime" : null
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
            var mylimittime = document.getElementById('limittime');
           
             mylimittime.innerHTML='重新发送';
             mylimittime.onclick = function(){
               me.sendsmsServer();
             }
               
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
            // var fromSource = Trafficeye.fromSource();
            Trafficeye.toPage("pre_baseinfo_mobile_verify.html");
        },
        //清除用户昵称
        trunce : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo_mobile.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //保存用户昵称
        saveFunction : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
            
            me.sendcheckServer();
            }),Trafficeye.MaskTimeOut);     
        },
        /**
         * 用户信息修改请求函数
         */
        sendcheckServer : function(url,data) {
            var me = this;
              var textNickname = me.elems["verifynumber"].attr("value");
                if(textNickname.length!=6)
                 {
                    Trafficeye.trafficeyeAlert("请输入6位验证码");
                    return;
                 }
            var url = Trafficeye.BASE_USER_URL + "phone/check";
            var myInfo = Trafficeye.getMyInfo();
            var phone = Trafficeye.offlineStore.get("traffic_mobile_verify");
            var mobile = Trafficeye.str2Json(phone);
            var data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "uid" : myInfo.uid,
                "phone" : mobile.phonenumber,
                "checkNum" : textNickname
            };
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
                                // Trafficeye.trafficeyeAlert("结果:"+data.state.desc);
                                
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
                                
                                Trafficeye.toPage("pre_baseinfo_mobile_success.html");
                            } else{
                                Trafficeye.trafficeyeAlert(data.state.desc+"("+data.state.code+")");
                                Trafficeye.toPage("pre_baseinfo_mobile_fail.html");
                            }
                        } else {
                             Trafficeye.toPage("pre_baseinfo_mobile_fail.html");
                        }
                    }
                })
            } else {
                Trafficeye.toPage("pre_baseinfo_mobile_fail.html");
            }
        },
        /**
         * 发送短信接口
         */
        sendsmsServer : function(evt) {
            var me = this;
             
             var mylimittime = document.getElementById('limittime');
            var tempTime=60;
            function time(){
                tempTime--;
                mylimittime.innerHTML='重新发送('+tempTime+')';
                if(tempTime==0){
                     mylimittime.innerHTML='重新发送';
                     mylimittime.onclick = function(){
                       me.sendsmsServer();
                     }
                    window.clearInterval(t);    
                }
            }
            var t=window.setInterval(time,1000);
             
             var url = Trafficeye.BASE_USER_URL + "phone/sendCheck";
            var myInfo = Trafficeye.getMyInfo();
            var phone = Trafficeye.offlineStore.get("traffic_mobile_verify");
            var mobile = Trafficeye.str2Json(phone);
            var data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "uid" : myInfo.uid,
                "phone" : mobile.phonenumber
            };
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
                            var state = data.code;
                            if (state == 0) {
                                Trafficeye.trafficeyeAlert(data.desc);
                            } else{
                                Trafficeye.trafficeyeAlert(data.desc+"("+data.code+")");
                              }
                        } else {
                        }
                    }
                })
            } else {
            }
        }
    };
    
    $(function(){

        //  获取我的用户信息
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
            // pm.sendsmsServer();
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
        
        window.sendsmsServer = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.sendsmsServer(evt);
            }
        };
        
        window.trunce = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.trunce(evt);
            }
        };
    }); 
    
 }(window));