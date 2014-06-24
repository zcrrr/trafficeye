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
            "medaldesc" : null,
            "medaldetails" : null
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
            var fromSource = Trafficeye.fromSource();
            Trafficeye.toPage(fromSource.sourcepage);
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
            medaldescElem = me.elems["medaldesc"],
            medaldetailsElem = me.elems["medaldetails"];
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
            //徽章部分
            medaldescElem.html("<h3>获得徽章    <s>"+dataSource.badgeNum+"</s>  枚</h3><h3>徽章总数    <s>"+dataSource.totalBadges+"</s>  枚</h3>");
            //徽章详情
            var medallist = [];
            for (var i = 0, len = dataSource.ownedBadges.length; i < len; i++) {
                medallist.push(this.createMedalListHtml(dataSource.ownedBadges[i]));
            }
            if(dataSource.badgeNum < dataSource.totalBadges)
            {
                for (var i = 0, len = dataSource.totalBadges-dataSource.badgeNum ; i < len; i++) {
                    medallist.push(this.createbadge_unknownListHtml());
                }
            }
            // for
            medaldetailsElem.html(medallist.join(""));
         },
         //创建徽章列表函数
         createMedalListHtml : function(data) {
            var me = this;
            var htmls = [];
            var avatarSrc="";
            if (data.smallImgName) {
                avatarSrc = "per_img/drawable/"+data.smallImgName;
            }
            htmls.push("<div class='m-img' onclick=\"gotoMedalDetails('per_img/drawable/" + data.imgName +"','"+data.name+"','"+ data.desc + "',this);\"><img src=" + avatarSrc + " width='70' height='70'/></div>");
            return htmls.join("");
        },
        //创建未知徽章列表函数
         createbadge_unknownListHtml : function() {
            var me = this;
            var htmls = [];
            var avatarSrc="";
            avatarSrc = "per_img/drawable/badge_unknown.png";
            htmls.push("<div class='m-img'><img src=" + avatarSrc + " width='70' height='70'/></div>");
            return htmls.join("");
        },
        //发送消息的onclick事件响应函数
        messagebtn : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_medal.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //添加关注的onclick事件响应函数
        addlookbtn : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_medal.html");
            }),Trafficeye.MaskTimeOut);     
        },
        //编辑个人信息的onclick事件响应函数
        editbtn : function(evt) {
            var me = this;
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_baseinfo.html");
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
                            var state = data.state.code;
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
        //跳转到徽章详情页面
        gotoMedalDetails : function(avatarSrc,name,desc,evt) {
             var me = this;
             var medaldata = {
                "avatarSrc" : avatarSrc,
                "name" : name,
                "desc" : desc
            };
            var dataStr = Trafficeye.json2Str(medaldata);
            Trafficeye.offlineStore.set("traffic_medaldetails", dataStr);
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("pre_medaldetails.html");
            }),Trafficeye.MaskTimeOut);     
        }
    };
    
    $(function(){
       
        //把来源信息存储到本地
         var presource = Trafficeye.fromSource();
         var fromSource = {"sourcepage" : presource.sourcepage,"currpage" : "pre_medal.html","prepage" : presource.currpage}
         var fromSourceStr = Trafficeye.json2Str(fromSource);
         Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
         //获取我的用户信息
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
                pm.reqUserInfo(myInfo.uid,myInfo.friend_uid); //请求朋友的页面信息
            }
        }else{
            //让用户重新登录
            Trafficeye.toPage("pre_login.html");
        }
        // 设置头像成功的回调函数
        window.callbackSetUserAvatar = function(data){
            Trafficeye.httpTip.closed();
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
        //跳转到徽章详情页面
        window.gotoMedalDetails = function(avatarSrc,name,desc,evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.gotoMedalDetails(avatarSrc,name,desc,evt);
            }
        };
        //注销
        window.exitbtn = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.exitbtn(evt);
            }
        };
    }); 
    
 }(window));