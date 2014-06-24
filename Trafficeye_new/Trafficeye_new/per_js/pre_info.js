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
            "infousername" : null,
            "looknum" : null,
            "fansnum" : null,
            "looklistbtn" : null,
            "fanslistbtn" : null,
            "headimgbtn" : null,
            "headimgid" : null,
            "nc_mid" : null,
            "nc_wid" : null,
            "nc_weixin" : null,
            "nc_sinaweibo" : null,
            "nc_qqweibo" : null,
            "btn_message" : null,
            "btn_addlook" : null,
            "btn_edit" : null,
            "btn_exit" : null,
            "introduce" : null,
            "road" : null,
            "event" : null,
            "level" : null,
            "integral" : null,
            "mileage" : null,
            "badge" : null,
            "nextlevel" : null,
            "schedule" : null,
            "nextintegral" : null
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
                looklistbtnElem = me.elems["looklistbtn"],
                fanslistbtnElem = me.elems["fanslistbtn"],
                backpagebtnElem = me.elems["backpagebtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            //查看关注列表按钮
            looklistbtnElem.onbind("touchend",me.looklistbtnUp,me);
            //查看粉丝列表按钮
            fanslistbtnElem.onbind("touchend",me.fanslistbtnUp,me);
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
            // Trafficeye.toPage(fromSource.prepage);closeThisPage
             if (Trafficeye.mobilePlatform.android) {
                window.JSAndroidBridge.closeThisPage();
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc:??closeThisPage");
            } else {
                alert("调用修改用户信息接口,PC不支持.");
            }
        },
        //点击关注按钮，跳转到社区的关注页面
        looklistbtnUp : function(evt) {
            var myInfo = Trafficeye.getMyInfo();
            var data = {
                "prepage" : "trafficeye_personal",
                "pid" : myInfo.pid,
                "uid" : myInfo.uid,
                "uidFriend" : myInfo.userinfo.uid,
                "traffic_lookfans" : "look"
            };
            var dataStr = Trafficeye.json2Str(data);
            if (Trafficeye.mobilePlatform.android) {
                window.JSAndroidBridge.gotoCommunity("lookfans",dataStr);
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                var rewardContent = encodeURI(encodeURI(dataStr));
                Trafficeye.toPage("objc:??gotoCommunity::?lookfans:?"+rewardContent);
            } else {
                alert("调用修改用户信息接口,PC不支持.");
            }
        },
        //点击粉丝按钮，跳转到社区的粉丝页面
        fanslistbtnUp : function(evt) {
            var myInfo = Trafficeye.getMyInfo();
            var data = {
                "prepage" : "trafficeye_personal",
                "pid" : myInfo.pid,
                "uid" : myInfo.uid,
                "uidFriend" : myInfo.userinfo.uid,
                "traffic_lookfans" : "fans"
            };
            // console.log(data);
            var dataStr = Trafficeye.json2Str(data);
            if (Trafficeye.mobilePlatform.android) {
                window.JSAndroidBridge.gotoCommunity("lookfans",dataStr);
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                var rewardContent = encodeURI(encodeURI(dataStr));
                Trafficeye.toPage("objc:??gotoCommunity::?lookfans:?"+rewardContent);
            } else {
                alert("调用修改用户信息接口,PC不支持.");
            }
        },
        /**
         * 用户信息请求函数
         */
        reqUserInfo : function(uid,uidfriend) {
            var url = Trafficeye.BASE_USER_URL + "userInfo";
            var myInfo = Trafficeye.getMyInfo();
            var data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "uid" : uid,
                "uidFriend" : uidfriend
            };
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
                                me.reqUserInfoSuccess(data.userInfo,false);
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
        /**
         * 获取到用户信息后，页面展现函数
         * @param  {JSON Object} data
         * @param  {Boolean} flag 是否是自己的信息界面
         */
        reqUserInfoSuccess : function(dataSource,flag) {
            var me = this,
            infousernameElem = me.elems["infousername"],
            looknumElem = me.elems["looknum"],
            fansnumElem = me.elems["fansnum"],
            headimgbtnElem = me.elems["headimgbtn"],
            headimgidElem = me.elems["headimgid"],
            nc_midElem = me.elems["nc_mid"],
            nc_widElem = me.elems["nc_wid"],
            nc_weixinElem = me.elems["nc_weixin"],
            nc_sinaweiboElem = me.elems["nc_sinaweibo"],
            nc_qqweiboElem = me.elems["nc_qqweibo"],
            btn_messageElem = me.elems["btn_message"],
            btn_addlookElem = me.elems["btn_addlook"],
            btn_editElem = me.elems["btn_edit"],
            btn_exitElem = me.elems["btn_exit"],
            introduceElem = me.elems["introduce"],
            roadElem = me.elems["road"],
            eventElem = me.elems["event"],
            levelElem = me.elems["level"],
            integralElem = me.elems["integral"],
            mileageElem = me.elems["mileage"],
            badgeElem = me.elems["badge"],
            nextlevelElem = me.elems["nextlevel"],
            scheduleElem = me.elems["schedule"],
            nextintegralElem = me.elems["nextintegral"];
            //渲染页面
            if(dataSource.username){//用户名称
                infousernameElem.html(dataSource.username);
            }else{
                infousernameElem.html("交通眼用户登录");
            }
            //关注与粉丝
            if(dataSource.frineds)
            {
                looknumElem.html(dataSource.frineds);
            }
            if(dataSource.fans){
                fansnumElem.html(dataSource.fans);
            }
            //头像设置
            Trafficeye.imageLoaded(headimgidElem, dataSource.avatarUrl);
            //性别
            var gender = dataSource.gender;
            // nc_midElem.show();
            switch(gender) {
                    case "M" :
                        nc_midElem.show();
                        break;
                    case "F" :
                        nc_widElem.show();
                        break;
                    case "S" :
                        break;
                }
            //第三方登录信息显示
            var groupName = dataSource.groupName;
            switch(groupName){
                case "qqweibo":
                nc_qqweiboElem.show();
                break;
                case "sinaweibo":
                nc_sinaweiboElem.show();
                break;
                case "qzoneqq":
                nc_weixinElem.show();
                break;
            }
            //判断是自己的或是其他人的主页
            if(flag){
                btn_editElem.css("display", "");
                btn_exitElem.css("display", "");
                btn_messageElem.css("display", "none");
                btn_addlookElem.css("display", "none");
            }else{
                btn_editElem.css("display", "none");
                btn_exitElem.css("display", "none");
                btn_messageElem.css("display", "");
                btn_addlookElem.css("display", "");
                btn_messageElem.html("<span id=\"btn_message\" onclick = \"messagebtn("+dataSource.uid+",this);\" >发消息</span>");
                btn_addlookElem.html("<span id=\"btn_addlook\" onclick = \"addlookbtn("+dataSource.uid+",this);\" >加关注</span>");
            }
            //一句话简介
            var descriptionhtml = dataSource.description;
            if(descriptionhtml == ""){
                descriptionhtml = "这个家伙很懒,什么都没有说.";
            }
            introduceElem.html(descriptionhtml);
            //贡献路况
            var totalTrackMilage = dataSource.totalTrackMilage;
            if(totalTrackMilage=="")
            {
                totalTrackMilage = 0;
            }
            roadElem.html("贡献路况  "+totalTrackMilage+"<s>公里</s>");
            //事件上报
            var eventNum = dataSource.eventNum;
            if(eventNum=="")
            {
                eventNum = 0;
            }
            eventElem.html("事件上报  "+eventNum+"<s>件</s>");
            //等级
            var level = dataSource.level;
            if(level=="")
            {
                level = 0;
            }
            levelElem.html("等级  "+level+"<s>级</s>");
            //积分
            var totalPoints = dataSource.totalPoints;
            if(totalPoints=="")
            {
                totalPoints = 0;
            }
            integralElem.html("积分  "+totalPoints+"<s>分</s>");
            //行驶里程，公里数
            var totalMilage = dataSource.totalMilage;
            if(totalMilage=="")
            {
                totalMilage = 0;
            }
            //级别
            nextlevelElem.html("<span>"+dataSource.nextLevel+"</span>"+dataSource.level);
            nextintegralElem.html("<span>"+dataSource.nextLevelPoint+"</span>"+dataSource.levelPoint);
            scheduleElem.css("display","width:"+dataSource.levelPercent+"%");
            mileageElem.html("<span class=\"icon\"></span>行驶里程    "+totalMilage+"<s>公里</s><span class=\"libg_arrow\"></span>");
            //徽章
            badgeElem.html("<span class=\"icon\"></span>徽章    "+dataSource.ownedBadges.length+"<s>枚</s><span class=\"libg_arrow\"></span>");
        },
        //里程的onclick事件响应函数
        mileageHtml : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_distance.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //徽章的onclick事件响应函数
        badgeHtml : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_medal.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //发送消息的onclick事件响应函数
        messagebtn : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                var myInfo = Trafficeye.getMyInfo(); 
                var fromSource = {"uid" : myInfo.uid,"friend_id" : myInfo.friend_uid}
                var fromSourceStr = Trafficeye.json2Str(fromSource);
                Trafficeye.offlineStore.set("traffic_chat", fromSourceStr);
                Trafficeye.toPage("pre_message.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //添加关注的onclick事件响应函数
        addlookbtn : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                var myInfo = Trafficeye.getMyInfo();
            me.reqAddLook(myInfo.uid, myInfo.friend_uid, myInfo.pid,evt);
            }),Trafficeye.MaskTimeOut);     
        },
        /**
         * 加关注用户服务
         * @param  {Number} uid     
         * @param  {Number} friendId
         */
        reqAddLook : function(uid, friendId, pid,evt) {
            var me = this;
            var reqData = {
                "uid" : uid,
                "friend_id" : friendId,
                "pid" : pid
            };
            var reqParams = Trafficeye.httpData2Str(reqData);
            var url = BASE_FRIENDSSHIP_URL + "create";
            if (url) {
                Trafficeye.httpTip.opened(function() {
                    me.isStopReq = true;
                }, me);
                me.isStopReq = false;
                var reqUrl = url + reqParams;
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        if (data && !me.isStopReq) {
                            me.reqAddLookSuccess(data,friendId,evt);
                        } else {
                            Trafficeye.trafficeyeAlert("错误描述:关注未成功");
                        }
                    }
                })
            }
        },
        reqAddLookSuccess : function(data,friendId,evt) {
            Trafficeye.httpTip.closed();
            if (data && data.code == 0) {                
               //var arr = evt.childNodes;
               if(data.friendShip == 1){
                    // evt.target.innerHTML = "已关注";
                    evt.textContent = "已关注";
                }else if(data.friendShip == 3){
                    evt.textContent = "相互关注";
                    evt.setAttribute("style","width:80px");
                }
            }else{
                Trafficeye.trafficeyeAlert("错误描述:"+data.desc);  
            }
        },
        //编辑个人信息的onclick事件响应函数
        editbtn : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.offlineStore.set("traffic_infosurveycar","info");
                Trafficeye.toPage("pre_baseinfo.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //贡献里程的onclick事件响应函数
        trafficHtml : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_info_traffichtml.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //上报事件的onclick事件响应函数
        eventHtml : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_info_event.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //积分的onclick事件响应函数
        integralHtml : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_info_integral.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //注销,退出登录的onclick事件响应函数
        exitbtn : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                me.reqExit();
            }),Trafficeye.MaskTimeOut);     
        },
        //
        /**
         * 用户退出登录请求函数
         */
        reqExit : function() {
            var url = Trafficeye.BASE_USER_URL + "logout";
            var myInfo = Trafficeye.getMyInfo();
            var data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid
            };
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
                            var state = data.code;
                            if (state == 0) {
                                // 注销用户信息，userInfo为""
                                if (Trafficeye.mobilePlatform.android) {
                                    window.JSAndroidBridge.updateUserInfo("{}","{}");
                                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                                    window.location.href = ("objc:??updateUserInfo::?{}:?{}");
                                } else {
                                    alert("调用注销用户信息接口,PC不支持.");
                                }
                                //返回到登录界面
                                 Trafficeye.toPage("pre_login.html");
                            } else{
                                Trafficeye.trafficeyeAlert(data.desc+"("+data.code+")");
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
    
    //关注与取消URL
    var BASE_FRIENDSSHIP_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/friendships/";
    
    $(function(){
       
        //把来源信息存储到本地
         var presource = Trafficeye.fromSource();
         var fromSource = {"sourcepage" : "pre_info.html","currpage" : "pre_info.html","prepage" : presource.currpage}
         var fromSourceStr = Trafficeye.json2Str(fromSource);
         Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
         //获取我的用户信息, by dongyl
        var myInfo = Trafficeye.getMyInfo();
        if (!myInfo) {
            return;
        }
        
        var pm = new PageManager();

        Trafficeye.pageManager = pm;
        //初始化用户界面
        pm.init();
        pm.myInfo = myInfo;
        //判断缓存中是否有userinfo信息
        if(myInfo.userinfo){
            if(myInfo.uid == myInfo.friend_uid){
                pm.reqUserInfoSuccess(myInfo.userinfo,true); //渲染自己的页面信息
            }else{
                if(myInfo.isEdit == "2")
                {
                    pm.elems["backpagebtn"].css("display","");
                }
                pm.reqUserInfo(myInfo.uid,myInfo.friend_uid); //请求朋友的页面信息
            }
        }else{
            //让用户重新登录
            Trafficeye.toPage("pre_login.html");
        }
        // 设置头像成功的回调函数，输入是字符串，要转成json对象
        window.callbackSetUserAvatar = function(data){
            Trafficeye.httpTip.closed();
            var pm =  Trafficeye.pageManager;
            
            var myInfo = Trafficeye.getMyInfo();
            var dataStrJson = Trafficeye.str2Json(data)
            //把用户信息写入到本地
            //pid,ua,userinfo存入到浏览器本地缓存
            var userinfodata = {
                "pid" : myInfo.pid,
                "ua" : myInfo.ua,
                "uid" : myInfo.uid,
                "friend_uid" : dataStrJson.uid,
                "isEdit" : myInfo.isEdit,
                "userinfo" : dataStrJson
            };
            var dataStr = Trafficeye.json2Str(userinfodata);
            Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
            var headimgidElem = pm.elems["headimgid"];
            // //头像设置
            Trafficeye.imageLoaded(headimgidElem, dataStrJson.avatarUrl);
        }
        //里程详细界面
        window.mileageHtml = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.mileageHtml(evt);
            }
        };
        //徽章界面
        window.badgeHtml = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.badgeHtml(evt);
            }
        };
        //编辑头像
        window.headimgbtnUp = function(evt) {
            if (Trafficeye.mobilePlatform.android) {
                window.JSAndroidBridge.setUserAvatar();
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc:??setUserAvatar");
            } else {
                alert("调用设置头像接口,PC不支持.");
            }
        };
        //发送消息
        window.messagebtn = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.messagebtn(evt);
            }
        };
        //添加关注
        window.addlookbtn = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.addlookbtn(evt);
            }
        };
        //个人信息编辑
        window.editbtn = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.editbtn(evt);
            }
        };
        //注销
        window.exitbtn = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.exitbtn(evt);
            }
        };
        //添加贡献路况跳转
        window.trafficHtml = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.trafficHtml(evt);
            }
        };
        //个人积分跳转
        window.integralHtml = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.integralHtml(evt);
            }
        };
        //个人事件上报
        window.eventHtml = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.eventHtml(evt);
            }
        };
}); 
    
 }(window));