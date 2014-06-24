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

    function UserDistanceManager() {
        //加载成功的用户的所有时间线数据
        this.allDistanceData = [];
        //用户最近一次加载的时间线数据
        this.newDistanceData = [];
    };
    
    UserDistanceManager.prototype = {

        setNewDistanceData : function(data) {
            this.newDistanceData = data;
        },
        mergeNewDistanceData : function() {
            this.allDistanceData.concat(this.newDistanceData);
        },
        
        creatDistanceListHtml : function(data) {

            var me = this;
            var htmls = [];
            htmls.push("<tr><td></td><td>"+data.desc+"</td><td><p>"+data.point+"<span>分</span></p></td><th>"+data.createdTime+"</th></tr>");
            return htmls.join("");
        },

        getDistanceListHtml : function(distanceList) {
            var data = distanceList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatDistanceListHtml(data[i]));
            }
            return htmls.join("");
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
            "distancedesc" : null,
            "loadmorebtn" : null,
            "distancelist" : null
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
            me.pageNumManager = new Trafficeye.PageNumManager();
            me.UserDistanceManager = new UserDistanceManager();
             me.pageNumManager.reset();
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
                loadmorebtnElem = me.elems["loadmorebtn"],
                backpagebtnElem = me.elems["backpagebtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            //隐藏加载更多按钮
            // loadmorebtnElem.style.display="none";//("display","none");
            loadmorebtnElem.css("display", "none");
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
            distancedescElem = me.elems["distancedesc"],
            distancelistElem = me.elems["distancelist"];
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
            distancedescElem.html("<h3>行驶里程    <s>"+dataSource.totalMilage+"</s>  公里</h3><h3>贡献路况    <s>"+dataSource.totalTrackMilage+"</s>  公里</h3>");
            //请求 里程列表函数
            me.distanclistUp(dataSource.uid,0);
         },
         /**
         * 用户里程信息列表请求函数
         */
        distanclistUp : function(distance_uid,page) {
            var url = Trafficeye.BASE_USER_URL + "objectList";
            var myInfo = Trafficeye.getMyInfo();
            var data = {
                "ua" : myInfo.ua,
                "pid" : myInfo.pid,
                "uid" : distance_uid,
                "type" : 1,
                "page" : page,
                "count" : 10
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
                                me.reqDistanceListSuccess(data);
                            } else if(data.state.code == -99){//没有加载更多
                                me.reqLoadNo();
                            }else{
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
        //没有更多数据
        reqLoadNo : function() {
            var me = this;
            Trafficeye.httpTip.closed();
            me.elems["loadmorebtn"].css("display", "none");
        },
        /**
         * 里程列表显示函数
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqDistanceListSuccess : function(data) {    
            // var data = Trafficeye.str2Json(data);
            var me = this, 
            pageNumMger = me.pageNumManager,//判断是否加载更多
            distancelistElem = me.elems["distancelist"];
            Trafficeye.httpTip.closed();

            if (data) {
                //当前结果集请求的结束位置
                var currentEnd = pageNumMger.getEnd();
                //更新下次请求分页起始位置
                pageNumMger.start = currentEnd + 1;
                //用户信息更新
                var distancehtml = me.UserDistanceManager.getDistanceListHtml(data.objectList); 
                if (data.nextPage == -1) {//nextPage 为 -1的时候，没有下一页
                    pageNumMger.setIsShowBtn(false);
                } else {
                    pageNumMger.setIsShowBtn(true);
                } 
                if((pageNumMger.start/pageNumMger.BASE_NUM)==1){
                    distancelistElem.html(distancehtml);
                }else{
                    distancelistElem.append(distancehtml);
                }      
                    //判断是否显示加载更多按钮
                if (pageNumMger.getIsShowBtn()) {
                    me.elems["loadmorebtn"].css("display", "");
                    me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp(this);\">加载更多</div>");
                } else {
                    me.elems["loadmorebtn"].css("display", "none");
                }
            } 
        },  
        //加载更多
        loadmorebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }
            $(elem).removeClass("bblue");
            var uid = myInfo.uid;
            if (uid) {
                me.loadmoreHander(uid);
            }
        },
        /**
         * 加载更多数据处理函数
         */
        loadmoreHander : function(uid) {
            var me = this;
            if (uid) {
                var userData = {};
                userData.uid = uid;
                userData.page = me.pageNumManager.getStart()/me.pageNumManager.BASE_NUM;
                
                me.distanclistUp(uid, userData.page);
            }
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
       
        //把来源信息存储到本地
         var presource = Trafficeye.fromSource();
         var fromSource = {"sourcepage" : presource.sourcepage,"currpage" : "pre_distance.html","prepage" : presource.currpage}
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
        // 设置头像成功的回调函数,输入是字符串，要转为json对象
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
        //加载更多
        window.loadmorebtnUp = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loadmorebtnUp(evt);
            }
        };
    }); 
    
 }(window));