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
            "backpagebtn" : null,
            "nickname" : null,
            "registerbtn" : null
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
        /**
         * 注册请求函数
         */
        reqRegisterbtnUp : function(evt) {
            var me = this;
            
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }
          
            var pid = myInfo.pid;
            var ua = myInfo.ua;

            // var textMail = me.elems["mail"].attr("value");
            var textNickname = me.elems["nickname"].attr("value");
            // var textPwd = me.elems["pwd"].attr("value");
            
             if(textNickname.length>30 || textNickname.length < 2)
             {
                Trafficeye.trafficeyeAlert("昵称请您输入2-30个字符");
                return;
             }
             
            var thirdPlatformUserData = Trafficeye.str2Json(Trafficeye.offlineStore.get("traffic_ThirdPlatformUserData"));
            var registerBtnUp_url = Trafficeye.BASE_USER_URL + "unitLogin";
            var registerBtnUp_data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "unitId" : thirdPlatformUserData.unitId,
                "userType" : thirdPlatformUserData.userType,
                "birthdate" : thirdPlatformUserData.birthdate,
                "gender" : thirdPlatformUserData.gender,
                "username" : textNickname,
                "avatarUrl" : thirdPlatformUserData.avatarUrl
            };
            me.reqRegisterbut(registerBtnUp_url, registerBtnUp_data);
            
        },
        /**
         * 注册用户请求函数
         */
        reqRegisterbut : function(url, data) {
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
                            console.log(data);
                            if (state == 0) {
                                // console.log(data);
                                var myInfo = Trafficeye.getMyInfo();
                                //把用户信息写入到本地
                                //pid,ua,userinfo存入到浏览器本地缓存
                                var userinfodata = {
                                    "pid" : myInfo.pid,
                                    "ua" : myInfo.ua,
                                    "uid" : data.state.uid,
                                    "friend_uid" : data.userInfo.uid,
                                    "isEdit" : myInfo.isEdit,
                                    "userinfo" : data.userInfo
                                };
                                var dataStr = Trafficeye.json2Str(userinfodata);
                                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
                                //写入徽章，里程信息到浏览器缓存
                                var dataReward = Trafficeye.json2Str(data.reward);
                                var dataUserInfo = Trafficeye.json2Str(data.userInfo);
                                Trafficeye.offlineStore.set("traffic_reward",dataReward);
                                if (Trafficeye.mobilePlatform.android) {
                                    window.JSAndroidBridge.updateUserInfo(dataUserInfo,dataReward);
                                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                                    var content = encodeURI(encodeURI(dataUserInfo));
                                    var rewardContent = encodeURI(encodeURI(dataReward));
                                    window.location.href = ("objc:??updateUserInfo::?"+content+":?"+rewardContent);
                                } else {
                                    alert("调用修改用户信息接口,PC不支持.");
                                }
                               Trafficeye.toPage("pre_info.html");
                            } else{
                                //注册失败
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
        },
        //注册的onclick事件响应函数
        registerFun : function(evt) {
            var me = this;
            $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                me.reqRegisterbtnUp(evt);//注册请求处理函数
            }),Trafficeye.MaskTimeOut);     
        }
    };
    
    $(function(){
        
        //把来源信息存储到本地
         var presource = Trafficeye.fromSource();
         var fromSource = {"sourcepage" : presource.sourcepage,"currpage" : "pre_third_info.html","prepage" : presource.currpage}
         var fromSourceStr = Trafficeye.json2Str(fromSource);
         Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
         //通过web缓存读取第三方用户账号信息
         var thirdPlatformUserDataStr = Trafficeye.offlineStore.get("traffic_ThirdPlatformUserData");
         thirdPlatformUserData = Trafficeye.str2Json(thirdPlatformUserDataStr);
         // console.log(thirdPlatformUserData);
         //获取我的用户信息, by dongyl
        var myInfo = Trafficeye.getMyInfo();
         
        var pm = new PageManager();

        Trafficeye.pageManager = pm;
        //初始化用户界面
        pm.init();
        pm.myInfo = myInfo;
        
        window.registerReq = function(evt){
            var registerBtnUp_url = Trafficeye.BASE_USER_URL + "unitLogin";
            var registerBtnUp_data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "unitId" : thirdPlatformUserData.unitId,
                "userType" : thirdPlatformUserData.userType,
                "birthdate" : thirdPlatformUserData.birthdate,
                "gender" : thirdPlatformUserData.gender,
                "username" : thirdPlatformUserData.username,
                "avatarUrl" : thirdPlatformUserData.avatarUrl
            };
            pm.reqRegisterbut(registerBtnUp_url,registerBtnUp_data);
        };
        
       window.registerFun = function(evt) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.registerFun(evt);
            }
        };
        window.registerReq();
    }); 
    
 }(window));