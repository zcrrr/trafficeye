 (function(window) { //闭包
    

     function UserFriends() {  
        //加载成功的用户的所有数据
        this.allUserFriendsData = [];
        //用户最近一次加载的数据
        this.newUserFriendsData = [];
    };
    UserFriends.prototype = {//方法挂载在原型链
        setNewUserFriendsData : function(data) {
            this.newUserFriendsData = data;
        },
        mergeNewUserFriendsData : function() {
            this.allUserFriendsData.concat(this.newUserFriendsData);
        },
        
        creatFriendsListHtml : function(data) {

            var me = this;
            var htmls = [];
            if (data.friendShip == 0) {
                htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.uid + "',this);\">加关注</span>");
            } else if(data.friendShip == 1) {
                htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.uid + "',this);\">已关注</span>");
            }else if(data.friendShip == 2) {
                htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.uid + "',this);\">加关注</span>");
            }else if(data.friendShip == 3) {
                htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.uid + "',this);\">互相关注</span>");
            }else if(data.friendShip == 4){
                htmls.push("<li>");
            }
            htmls.push("<div class='h-img' onclick=\"gotoTimeline('" + data.uid + "',this);\">");
            
            if(data.avatar){
                htmls.push("<img src = '" + data.avatar + "' alt='' width='40' height='40' /></div>");
            }else{
                htmls.push("<img src = 'com_images/default.png' alt='' width='40' height='40' /></div>");
            }
            htmls.push("<div class='h-text' onclick=\"gotoTimeline('" + data.uid + "',this);\">" + data.name );
            htmls.push("</div></li>");
            return htmls.join("");
        },

        getFriendsListHtml : function(friendsList) {
            var data = friendsList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatFriendsListHtml(data[i]));
            }
            return htmls.join("");
        }
    };

    function PageManager() {
        //ID元素对象集合,关注列表、粉丝列表
        this.elems = {
            "userlist" : null,
            "loadmorebtn" : null,
            "backpagebtn" : null
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
            me.UserFriends = new UserFriends();
            me.pageNumManager = new Trafficeye.PageNumManager();
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
                backpagebtnElem = me.elems["backpagebtn"], 
                loadmorebtnElem = me.elems["loadmorebtn"],
                userlist = me.elems["userlist"];    

            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);        
            //隐藏加载更多按钮
            loadmorebtnElem.css("display" , "none");    
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
           me.backPage();
        },
        /**
         * 返回上一页面
         */
        backPage : function() {
            // var fromSource = Trafficeye.fromSource();
            Trafficeye.toPage("timeline.html");
            // Trafficeye.toPage(fromSource.prepage);
        },
        /**
         * 取消关注按钮处理函数
         * @return {uid} 被取消关注的用户ID
         */
        cancelLook : function(uid,evt) {            
            var me = this;
            me.reqCancelLook(me.myInfo.uid, uid, me.myInfo.pid,evt);
        },
        /**
         * 请求取消关注用户服务
         * @param  {Number} uid     
         * @param  {Number} friendId
         */
        reqCancelLook : function(uid, friendId, pid,evt) {
            var me = this;
            var reqData = {
                "uid" : uid,
                "friend_id" : friendId,
                "pid" : pid
            };
            var reqParams = Trafficeye.httpData2Str(reqData);
            var url = BASE_URL + "destroy";
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
                            me.reqCancelLookSuccess(data,uid,friendId,evt);
                        } else {
                            me.reqCancelLookFail();
                        }
                    }
                })
            }
        },
        reqCancelLookSuccess : function(data,uid,friendId,evt) {
            Trafficeye.httpTip.closed(); 
            if (data && data.code == 0) {                
               evt.textContent = "加关注";    
               evt.setAttribute("onclick","addLook('"+friendId+"',this)");
            }else{                
                var content = encodeURI(encodeURI(data.desc));
                Trafficeye.toPage("objc://showAlert::/"+content);
            }
        },
        reqCancelLookFail : function() {
            Trafficeye.httpTip.closed(); 
        },

        /**
         * 加关注按钮处理函数
         * @return {uid} 被取消关注的用户ID
         */
        addLook : function(uid,evt) {
            var me = this;
            me.reqAddLook(me.myInfo.uid, uid, me.myInfo.pid,evt);
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
            var url = BASE_URL + "create";
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
                            me.reqAddLookSuccess(data,uid,friendId,evt);
                        } else {
                            me.reqAddLookFail();
                        }
                    }
                })
            }
        },
        reqAddLookSuccess : function(data,uid,friendId,evt) {
            Trafficeye.httpTip.closed(); 
            if (data && data.code == 0) {   
               if(data.friendShip == 1){
                    evt.textContent = "已关注";
                    evt.setAttribute("onclick","cancelLook('"+friendId+"',this)");
                }else if(data.friendShip == 3){
                    evt.textContent = "相互关注";
                    evt.setAttribute("onclick","cancelLook('"+friendId+"',this)");
                }
            }else{ 
                var content = encodeURI(encodeURI(data.desc));
                Trafficeye.toPage("objc://showAlert::/"+content);   
            }
        },
        reqAddLookFail : function() {
            console.log("请求失败");
        },

        /**
         * 请求用户信息
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqFriendsInfo : function(url, data) {
            var me = this;
               // lookcss = me.getElementsByTagName("lookbtn");

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
                        if (data && !me.isStopReq) {
                            if(data.state.code==0){
                                me.reqFriendsInfoSuccess(data);
                            }else if(data.state.code == -99){//没有加载更多
                                me.reqLoadNo();
                            }else{
                                me.reqFriendsInfoFail(data);
                            }
                        } else {
                            me.reqFriendsInfoFail(data);
                        }
                    }
                })
            }
        },
        /**
         * 请求用户时间线失败后的处理函数
         */
        reqFriendsInfoFail : function(data) {
            var me = this;
            Trafficeye.httpTip.closed();
            var html = [];
            html.push("<div class='qplnone'>"+data.state.desc+"</div>");
            me.elems["userlist"].append(html.join(""));
        },
        /**
         * 请求关注信息成功后的处理函数
         * @param  {JSON Object} data
         */
        reqFriendsInfoSuccess : function(data) {
            var me = this,     
                pageNumMger = me.pageNumManager, //判断是否加载更多
                userlistidElem = me.elems["userlist"];
                
                Trafficeye.httpTip.closed();

            if (data) {              
                //当前结果集请求的结束位置
                var currentEnd = pageNumMger.getEnd();
                //更新下次请求分页起始位置
                pageNumMger.start = currentEnd + 1;
                //用户信息更新
                me.UserFriends.setNewUserFriendsData(data.friends);
                var friendshtml = me.UserFriends.getFriendsListHtml(data.friends); 
                if (data.friends_counts < pageNumMger.BASE_NUM) {
                    pageNumMger.setIsShowBtn(false);
                } else {
                    pageNumMger.setIsShowBtn(true);
                } 
                if((pageNumMger.start/pageNumMger.BASE_NUM)==1){
                    userlistidElem.html(friendshtml);
                }else{
                    userlistidElem.append(friendshtml);
                }      
                    //判断是否显示加载更多按钮
                if (pageNumMger.getIsShowBtn()) {
                    me.elems["loadmorebtn"].css("display", "");
                    me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp(this)\";>加载更多</div>");
                } else {
                    me.elems["loadmorebtn"].css("display", "none");
                }        
            }
        },
        /**
         * 查看评论者时间线
         * @param  {Int} uid
         */
        lookOtherTimeline : function(uid,evt) {
            Trafficeye.offlineStore.set("traffic_timeline", uid);
            $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("timeline.html");
            }),Trafficeye.MaskTimeOut);
        },
        reqLoadNo : function() {
            var me = this;
            Trafficeye.httpTip.closed();
            me.elems["loadmorebtn"].css("display", "none");
        },
        //加载更多
        loadmorebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            //获取当前用户的uid
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }
            //获取当前显示时间线页面的用户信息ß
            var userTimeline_uid = Trafficeye.offlineStore.get("traffic_timeline_user");
            if (!userTimeline_uid) {
                return;
            }
            $(elem).removeClass("bblue");
            var uid = myInfo.uid;
            if (uid && userTimeline_uid) {
                me.loadmoreHander(uid,userTimeline_uid);
            }
        },
        /**
         * 加载更多数据处理函数
         */
        loadmoreHander : function(uid,friend_id) {
            var me = this;
            
            if (uid) {
                var userData = {};
                userData.uid = uid;
                userData.page = me.pageNumManager.getStart()/me.pageNumManager.BASE_NUM;
                userData.count = me.pageNumManager.BASE_NUM;
                //请求关注与粉丝用户信息协议
                var reqUrl = BASE_URL + "followers";
                userData.friend_id = friend_id;
                var reqData = userData;
                me.reqFriendsInfo(reqUrl, reqData);
            }
        }
    };

    //基础URL
    var BASE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/friendships/";
    $(function(){
        //获取当前显示时间线页面的用户信息 by dongyl
        var userTimeline_uid = Trafficeye.offlineStore.get("traffic_timeline_user");
        if (!userTimeline_uid) {
            return;
        }

        //获取本人UID
        var myInfo = Trafficeye.getMyInfo();
        if (!myInfo) {
            return;
        }
        
        //请求用户信息协议
        var friendsInfo_url = BASE_URL + "followers";
      //  var followersInfo_url = BASE_URL + "followers";
        var friendsInfo_data = {"uid" : myInfo.uid,"friend_id" : userTimeline_uid};
      //  var followersInfo_data = {"uid" : 357};

        var pm = new PageManager();
        //初始化用户界面
        pm.init();
        pm.myInfo = myInfo;
        pm.uid = userTimeline_uid;
        //请求用户数据，填充用户界面元素
        pm.reqFriendsInfo(friendsInfo_url, friendsInfo_data);

        window.removeFans = function(uid) {
            if (pm.init) {
                pm.removeFans(uid);
            }
        };

        window.gotoTimeline = function(uid,evt) {
            if (pm.init) {
                pm.lookOtherTimeline(uid,evt);
            }
        };

        window.cancelLook = function(uid,evt) {
            if (pm.init) {
                pm.cancelLook(uid,evt);
            }
        };

        window.addLook = function(uid,evt) {
            if (pm.init) {
                pm.addLook(uid,evt);
            }
        };
        
        window.loadmorebtnUp = function(evt) {
            if (pm.init) {
                pm.loadmorebtnUp(evt);
            }
        };
    }); 
    
 }(window));