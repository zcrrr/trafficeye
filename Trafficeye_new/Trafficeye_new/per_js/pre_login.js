 (function(window) {
    function UserInfoManager() {
        this.info = null;
        this.uid = null;
        this.pid = null;
    };
    UserInfoManager.prototype = {
        setInfo : function(data) {
            this.info = data;
        },
        setUid : function(uid) {
            this.uid = uid;
        },
        setPid : function(pid) {
            this.pid = pid;
        }
    };

    function PageManager() {
        //ID元素对象集合
        this.elems = {
            "loginsina" : null,
            "loginqqweibo" : null,
            "loginqq" : null,
            "logintrafficeye" : null,
            "register" : null
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
        loginSina : function(evt) {
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                if (Trafficeye.mobilePlatform.android) {
                    window.JSAndroidBridge.getSNSUserInfo("sinaweibo");
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc:??getSNSUserInfo::?sinaweibo");
                } else {
                    alert("调用本地getSNSUserInfo方法,PC不支持.");
                }
            }),Trafficeye.MaskTimeOut);       
        },
        
        loginQQWeibo : function(evt) {
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                if (Trafficeye.mobilePlatform.android) {
                    window.JSAndroidBridge.getSNSUserInfo("qqweibo");
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc:??getSNSUserInfo::?qqweibo");
                } else {
                    alert("调用本地getSNSUserInfo方法,PC不支持.");
                }
            }),Trafficeye.MaskTimeOut);          
        },
        
        loginQq : function(evt) {
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                if (Trafficeye.mobilePlatform.android) {
                    window.JSAndroidBridge.getSNSUserInfo("qzone");
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc:??getSNSUserInfo::?qzone");
                } else {
                    alert("调用本地getSNSUserInfo方法,PC不支持.");
                }
            }),Trafficeye.MaskTimeOut);     
        },
        
        loginTrafficeye : function(evt) {
            var me = this,
            elem = me.elems["logintrafficeye"];
            elem.addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_trafficeyelogin.html");
            }),Trafficeye.MaskTimeOut);       
        },
        
        loginRegister : function(evt) {
            $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_register.html");
            }),Trafficeye.MaskTimeOut);     
        }
    };

    //离线存储个人主页最新数据
    // var offlineStoreData = {
    //     userUid : "",
    //     userPid : "",
    //     userData : {},
    //     timestamp : Trafficeye.getDateTime()
    // };

    $(function(){
        // 初始化页面函数
        window.callbackInitPage = function(isLogin,dataClient,isEdit,ua,pid,param,baseinfoflag){
            Trafficeye.httpTip.closed();
            
            // alert(isEdit);
            if(isLogin == 0){
                var data = Trafficeye.str2Json(dataClient);
                //pid,ua,userinfo存入到浏览器本地缓存
                var userinfodata = {
                    "pid" : pid,
                    "ua" : ua,
                    "uid" : "",
                    "friend_uid" : "",
                    "isEdit" : isEdit,
                    "userinfo" : ""
                };
                var dataStr = Trafficeye.json2Str(userinfodata);
                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
               // Trafficeye.trafficeyeAlert("未登录,请您重新登录");
            }else if(isLogin == 1)//蒙版效果暂不取消，跳转到pre_info.html页面再取消
            {
                var data = Trafficeye.str2Json(dataClient);
                //pid,ua,userinfo存入到浏览器本地缓存
                var userinfodata = {
                    "pid" : pid,
                    "ua" : ua,
                    "uid" : data.uid,
                    "friend_uid" : data.uid,
                    "isEdit" : isEdit,
                    "userinfo" : Trafficeye.str2Json(dataClient)
                };
                var dataStr = Trafficeye.json2Str(userinfodata);
                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
                //个人编辑页面点击回退按钮：“初始化个人页面”接口，传递参数isEdit为1（外界直接进入编辑页面），则调用该接口，如果isEdit为0（是从个人中心进入的编辑页面），则直接html里面处理回退。
                if(isEdit == 1)
                {
                    Trafficeye.offlineStore.set("traffic_infosurveycar",baseinfoflag);
                    Trafficeye.toPage("pre_baseinfo.html");
                }else if(isEdit == 0){
                    Trafficeye.toPage("pre_info.html");
                }else if(isEdit == 2)
                {
                    var paramFriend = Trafficeye.str2Json(param);
                     userinfodata = {
                        "pid" : pid,
                        "ua" : ua,
                        "uid" : data.uid,
                        "friend_uid" : paramFriend.friend_uid,
                        "isEdit" : isEdit,
                        "userinfo" : Trafficeye.str2Json(dataClient)
                    };
                    var dataStr1 = Trafficeye.json2Str(userinfodata);
                    Trafficeye.offlineStore.set("traffic_myinfo", dataStr1);
                    Trafficeye.toPage("pre_info.html");
                }
            }else if(isLogin == 2){
                var userinfodata = {
                    "pid" : pid,
                    "ua" : ua,
                    "uid" : "",
                    "friend_uid" : "",
                    "isEdit" : isEdit,
                    "userinfo" : ""
                };
                var dataStr = Trafficeye.json2Str(userinfodata);
                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
                Trafficeye.httpTip.opened();
                Trafficeye.trafficeyeAlert("正在登录中,请稍后");
            }
        };
        
        // 自动登录成功通知js
        window.callbackAutoLoginDone = function(data){
            Trafficeye.httpTip.closed();
            var myInfo = Trafficeye.getMyInfo();
            //把用户信息写入到本地
            //pid,ua,userinfo存入到浏览器本地缓存
            var userinfodata = {
                "pid" : myInfo.pid,
                "ua" : myInfo.ua,
                "uid" : myInfo.uid,
                "friend_uid" : myInfo.uid,
                "isEdit" : myInfo.isEdit,
                "userinfo" : Trafficeye.str2Json(data)
            };
            var dataStr = Trafficeye.json2Str(userinfodata);
            Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
            Trafficeye.toPage("pre_info.html");
        };
        
        // 获取SNS平台用户信息，回调函数
        window.callbackGetSNSUserInfo  = function(data){
            // console.log(data);
            Trafficeye.httpTip.closed();
            var ThirdPlatformUserData = Trafficeye.str2Json(data)
            //把第三方账号返回的用户信息写入到本地
            // Trafficeye.offlineStore.set("traffic_ThirdPlatformUserData", Trafficeye.json2Str(data));
            Trafficeye.offlineStore.set("traffic_ThirdPlatformUserData", data);
            // var data1 = Trafficeye.str2Json(Trafficeye.offlineStore.get("traffic_ThirdPlatformUserData"));
            // console.log(data1.sex);
            if(ThirdPlatformUserData.unitId && ThirdPlatformUserData.userType && ThirdPlatformUserData.username){
                Trafficeye.toPage("pre_thrid_info.html");
            }else{
                Trafficeye.trafficeyeAlert("第三方登录失败,请重试");
            }
        };
        
        window.initPageManager = function() {
            //把来源信息存储到本地
             var fromSource = {"sourcepage" : "pre_login.html","currpage" : "pre_login.html","prepage" : "pre_login.html"}
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);

            var pm = new PageManager();

            Trafficeye.pageManager = pm;
            //初始化用户界面
            pm.init();
            //启动等待动画，等待客户端回调函数            
            Trafficeye.httpTip.opened();
        };
        
        window.loginSina = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loginSina(evt);
            }
        };
        
        window.loginQQWeibo = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loginQQWeibo(evt);
            }
        };
        
        window.loginQq = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loginQq(evt);
            }
        };
        
        window.loginTrafficeye = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loginTrafficeye(evt);
            }
        };
        
        window.loginRegister = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loginRegister(evt);
            }
        };
      window.initPageManager();
      // window.callbackInitPage(1,"{\"badgeNum\":1,\"avatarUrl\":\"\",\"wxNum\":\"\",\"level\":0,\"eventNum\":0,\"mobile\":\"\",\"frineds\":0,\"idNum\":\"\",\"totalMilage\":0,\"nextLevel\":1,\"city\":\"\",\"realName\":\"\",\"ownedBadges\":[{\"name\":\"新人徽章\",\"id\":1,\"obtainTime\":\"2014-05-28 22:33:56\",\"smallImgName\":\"badge_register.png\",\"imgName\":\"badge_big_register.png\",\"desc\":\"注册账号\"}],\"email\":\"wgy52@wgy.wgy\",\"totalBadges\":30,\"totalTrackMilage\":0,\"fans\":0,\"carNum\":\"\",\"totalCoins\":0,\"username\":\"Wgy52\",\"userType\":\"trafficeye\",\"levelPoint\":0,\"levelPercent\":36,\"uid\":\"40324\",\"birthdate\":\"\",\"gender\":\"S\",\"totalPoints\":11,\"nextLevelPoint\":30,\"mobileValidate\":0,\"qq\":\"\",\"description\":\"\",\"userGroup\":0}",0,"I_7.1,i_2.2.6","58D8C0E9-1DD1-4141-8D17-984DC9057037","","info");
      });
 }(window));