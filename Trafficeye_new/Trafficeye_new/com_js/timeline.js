 (function(window) {


    function UserInfoManager() {
        this.info = null;
        this.uid = null;
        this.isMySelf = false;
    };
    UserInfoManager.prototype = {
        setInfo : function(data) {
            this.info = data;
        },
        setUid : function(uid) {
            this.uid = uid;
        },
        setIsMySelf : function(flag) {
            this.isMySelf = !flag;
        }
    };

    function PraiseAvatorManager() { 
        this.userInfoManager = null;
    };
    PraiseAvatorManager.prototype = {//方法挂载在原型链

        setUserInfoManager : function(manger) {
            this.userInfoManager = manger;
        },
        
        getPraiseAvatorHtml : function(praiseavator) {
            var data = praiseavator;
            var htmls = [];
            htmls.push("<li><div class=\"zan\">");
            for (var i = 0, len = data.length; i < len; i++) {
                if(len-i == 1){
                    htmls.push("<span  onclick=\"gotoTimeline('" + data[i].uid + "',this);\">"+data[i].name+"</span>");
                }else{
                    htmls.push("<span  onclick=\"gotoTimeline('" + data[i].uid + "',this);\">"+data[i].name+" 、</span>");
                }
            }
            htmls.push("</div></li>");
            return htmls.join("");
        }
    };

    function UserTimelineManager() {
        //加载成功的用户的所有时间线数据
        this.allTimelineData = [];
        //用户最近一次加载的时间线数据
        this.newTimelineData = [];
        //关联用户信息管理器
        this.userInfoManager = null;
    };
    UserTimelineManager.prototype = {
        getTimeInfo : function(time) {
            if (time > 3600) {
                return Math.ceil(time / 3600) + "小时前";
            } else if (time > 60) {
                return Math.ceil(time / 60) + "分钟前";
            } else {
                return time + "秒前";
            }
        },
        setUserInfoManager : function(manger) {
            this.userInfoManager = manger;
        },
        setNewTimelineData : function(data) {
            this.newTimelineData = data;
        },
        mergeNewTimelineData : function() {
            this.allTimelineData.concat(this.newTimelineData);
        },
      
        createMediaHtml : function(url,publishId) {
            var htmls = ["<div class='nxx' onclick=\"gotoEvtdetail('" + publishId + "',this);\">"];
            htmls.push("<img src='" + url + "' width='300' height/>");
            htmls.push("</div>");
            return htmls.join("");
        },
        createCommentHtml : function(data) {
            var me = this;
            var htmls = ["<li>"];
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            htmls.push("<div class='l-img' onclick=\"gotoTimeline('" + data.comment_uid + "',this);\"><img src=" + avaterSrc + " width='40' height='40'/></div>");
            htmls.push("<div class='l-text'><h3>" + data.followers_name + "   <span>"+data.comment_time+"前</span></h3>");
            htmls.push("<span>" + data.comment_content + "</span>");
            htmls.push("</div></li>");
            return htmls.join("");
        },
        createTimelineHtml : function(data) {
            var me = this;
            var uid = me.userInfoManager.uid;
            var htmls = [];
            if (data && data.publish_id) {
                var publishId = data.publish_id;
                
                htmls.push("<ul class='l-list'><li>");
                //判断是否是自己发布的事件，如果不是，显示攒按钮
               // if (!me.userInfoManager.isMySelf) {
                    publishId = data.publish_id;
                    htmls.push("<div class='l-r' onclick=\"gotoPraise('" + publishId + "','" + data.uid + "', this);\"><a class='z'> 赞 " + data.praise_count + " </a></div>");
              //  }
                if (!me.userInfoManager.info.avatar) {
                    avaterSrc = "com_images/default.png";
                } else {
                    avaterSrc = me.userInfoManager.info.avatar;
                }
                htmls.push("<div class='l-img' onclick=\"gotoTimeline('" + uid + "',this);\"><img src='" + avaterSrc + "' width='40' height='40'/></div>");
                htmls.push("<div class='l-text' onclick=\"gotoTimeline('" + uid + "',this);\"><h3>" + me.userInfoManager.info.username + "</h3></div>");
                htmls.push("<div class='l-cont'>" + data.content + "</div>");
                if (data.media) {
                    htmls.push(me.createMediaHtml(data.media,publishId));
                }
                htmls.push("<h4>" + data.time + "前</h4></li>");
                htmls.push("<ul class='l-pl'>");
                if(data.praiseList && data.praiseList.length > 0){
                    htmls.push("<li><div class=\"zan\">");
                    for (var i = 0, len = data.praiseList.length; i < len; i++) {
                        if(len-i == 1){
                            htmls.push("<span  onclick=\"gotoTimeline('" + data.praiseList[i].uid + "',this);\">"+data.praiseList[i].name+"</span>");
                        }else{
                            htmls.push("<span  onclick=\"gotoTimeline('" + data.praiseList[i].uid + "',this);\">"+data.praiseList[i].name+" 、</span>");
                        }
                        //htmls.push("<span  onclick=\"gotoTimeline('" + data.praiseList[i].uid + "',this);\">"+data.praiseList[i].name+"</span>                    ");
                    }
                    htmls.push("</div></li>");
                }
                if (data.comments && data.comments.length > 0) {
                    for (var i = 0, len = data.comments.length; i < len; i++) {
                        htmls.push(me.createCommentHtml(data.comments[i]));
                    }
                }
                htmls.push("</ul>");
                 if(data.comment_count<4)
                {
                    htmls.push("<div class='qpl' onclick=\"gotoEvtdetail('" + publishId + "',this);\">查看并发表评论</div></ul>")
                }else{
                    htmls.push("<div class='qpl' onclick=\"gotoEvtdetail('" + publishId + "',this);\">查看全部" + data.comment_count + "条评论</div></ul>")
                }    
            }
            return htmls.join("");
        },
        getNewTimelineHtml : function() {
            var data = this.newTimelineData;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.createTimelineHtml(data[i]));
            }
            return htmls.join("");
        },
        
        getPraiseAvatorHtml : function(praiseavator) {
            var data = praiseavator;
            var htmls = [];
            htmls.push("<li><div class=\"zan\">");
            for (var i = 0, len = data.length; i < len; i++) {
                if(len-i == 1){
                    htmls.push("<span  onclick=\"gotoTimeline('" + data[i].uid + "',this);\">"+data[i].name+"</span>");
                }else{
                    htmls.push("<span  onclick=\"gotoTimeline('" + data[i].uid + "',this);\">"+data[i].name+" 、</span>");
                }
            }
            htmls.push("</div></li>");
            return htmls.join("");
        }
    };

    function PageManager() {
        //ID元素对象集合
        this.elems = {
            "header_nicknameid" : null,
            "backpagebtn" : null,
            "headimgbtn" : null,
            "detailbtn" : null,
            "looklistbtn" : null,
            "fanslistbtn" : null,
            "looknum" : null,
            "fansnum" : null,
            "headimgid" : null,
            "nc_nicknameid" : null,
            "nc_mid" : null,
            "nc_wid" : null,
            "infobtn" : null,
            "lookbtn" : null,
            "refreshbtn" : null,
            "loadmorebtn" : null,
            "infolookbtn" : null,
            "commentlistid" : null
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
        init : function(flag) {
            var me = this;
            me.pageNumManager = new Trafficeye.PageNumManager();
            me.userInfoManager = new UserInfoManager();
            me.userTimelineManager = new UserTimelineManager();
            me.PraiseAvatorManager = new PraiseAvatorManager();
            me.PraiseAvatorManager.setUserInfoManager(me.userInfoManager);
            me.userTimelineManager.setUserInfoManager(me.userInfoManager);
            me.userInfoManager.setIsMySelf(flag);
            me.initElems();
            if (flag) {
                var infolookbtnElem = me.elems["infolookbtn"];
                infolookbtnElem.css("display", "");
            }
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
                detailbtnElem = me.elems["detailbtn"],
                headimgbtnElem = me.elems["headimgbtn"],
                looklistbtnElem = me.elems["looklistbtn"],
                fanslistbtnElem = me.elems["fanslistbtn"],
                infobtnElem = me.elems["infobtn"],
                refreshbtnElem = me.elems["refreshbtn"],
                loadmorebtnElem = me.elems["loadmorebtn"];
                //lookbtnElem = me.elems["lookbtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            //详情按钮
            detailbtnElem.onbind("touchend",me.detailbtnUp,me);
            //修改头像按钮
            headimgbtnElem.onbind("touchend",me.headimgbtnUp,me);
            //查看关注列表按钮
            looklistbtnElem.onbind("touchend",me.looklistbtnUp,me);
            //查看粉丝列表按钮
            fanslistbtnElem.onbind("touchend",me.fanslistbtnUp,me);
            //消息按钮
            infobtnElem.onbind("touchstart",me.btnDown,infobtnElem);
            infobtnElem.onbind("touchend",me.infobtnUp,me);
            //关注按钮
          //  lookbtnElem.onbind("touchstart",me.btnDown,lookbtnElem);
          //  lookbtnElem.onbind("touchend",me.lookbtnUp,me);
            //刷新按钮
            refreshbtnElem.onbind("touchstart",me.btnDown,refreshbtnElem);
            refreshbtnElem.onbind("touchend",me.refreshbtnUp,me);
            //加载更多按钮
            loadmorebtnElem.onbind("touchstart",me.loadmorebtnDown,loadmorebtnElem);
            loadmorebtnElem.onbind("touchend",me.loadmorebtnUp,me);
        },
        /**
         * 按钮按下事件处理器
         * @param  {Event} evt
         */
        btnDown : function(evt) {
            this.addClass("curr");
        },
        detailbtnUp : function(evt) {
            //仅能显示本人头像
                var myInfo = Trafficeye.getMyInfo();
                var timeline_user = Trafficeye.offlineStore.get("traffic_timeline_user");
                //如果是自己才显示详细资料按钮
                if(myInfo.uid == timeline_user){
                    if (Trafficeye.mobilePlatform.android) {
                        window.init.goPersonal();
                    } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                        Trafficeye.toPage("objc://goUserCenter");
                    } else {
                        alert("调用本地goPersonal方法,PC不支持.");
                    }
                }else{
                    var data = {
                        "uid" : myInfo.uid,
                        "friend_uid" : timeline_user
                    };
                    var dataStr = Trafficeye.json2Str(data);
                    if (Trafficeye.mobilePlatform.android) {
                        window.init.gotoPersonalDetail(dataStr);
                    } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                        var content = encodeURI(encodeURI(dataStr));
                        Trafficeye.toPage("objc://gotoPersonalDetail::/"+content);
                    } else {
                        alert("调用本地goPersonal方法,PC不支持.");
                    }
                }
            },
        //头像位置
        headimgbtnUp : function(evt) {
            //仅能显示本人头像
             $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            var myInfo = Trafficeye.getMyInfo();
            var timeline_user = Trafficeye.offlineStore.get("traffic_timeline_user");
            if(myInfo.uid == timeline_user){
                    setTimeout((function(){
                    $(elem).removeClass("curr");  
                    if (Trafficeye.mobilePlatform.android) {
                        window.init.goPersonal();
                    } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                        Trafficeye.toPage("objc://goUserEdit");
                    } else {
                        alert("调用本地goPersonal方法,PC不支持.");
                    }
                    }),Trafficeye.MaskTimeOut);
            }else{
                // alert("非本人操作");
            }
        },
        looklistbtnUp : function(evt) {
            Trafficeye.toPage("looklist.html");
        },
        fanslistbtnUp : function(evt) {
            Trafficeye.toPage("fanslist.html");
        },
        infobtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            Trafficeye.toPage("chat.html");
        },
        lookbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            var uid = me.userInfoManager.uid;
           // me.addLook(uid,evt);
        },
        backpagebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
           me.backPage();
        },
        refreshbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            var uid = me.userInfoManager.uid;
            if (uid) {
                me.pageNumManager.reset();
                me.elems["loadmorebtn"].css("display", "none");
                me.elems["commentlistid"].html("");
                me.refreshHandler(uid);
            }
        },
        loadmorebtnDown : function(evt) {
            this.addClass("bblue");
        },
        loadmorebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("bblue");
            var uid = me.userInfoManager.uid;
            if (uid) {
                me.loadmoreHander(uid);
            }
        },
        /**
         * 请求用户信息
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqUserInfo : function(url, data) {
            var me = this;
            var userData = data;
            var reqParams = Trafficeye.httpData2Str(data);
            if (url) {
                me.userInfoManager.setUid(userData.uid);
                Trafficeye.httpTip.opened(function() {
                    me.isStopReq = true;
                }, me);
                me.isStopReq = false;
                var reqUrl = url + reqParams;
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        if (data && !me.isStopReq) {
                            me.reqUserInfoSuccess(data, userData);
                        } else {
                            me.reqUserInfoFail();
                        }
                    }
                })
            }
        },
        /**
         * 请求用户信息成功后的处理函数，存储的为个人时间线的用户信息
         * @param  {JSON Object} data
         */
        reqUserInfoSuccess : function(data, userData) {
            var me = this,
                headerNickElem = me.elems["header_nicknameid"],
                ncNickElem = me.elems["nc_nicknameid"],
                lookNumElem = me.elems["looknum"],
                fansNumElem = me.elems["fansnum"],
                headImgElem = me.elems["headimgid"],
                mElem = me.elems["nc_mid"],
                wElem = me.elems["nc_wid"];
            if (data) {
                me.userInfoManager.setInfo(data);
                var userName = data.username;
                var avatar = data.avatar;
                var gender = data.gender;
                var userType = data.usertype;
                var lookNum = data.friends_count;
                var fansNum = data.followers_count;

                headerNickElem.html(userName);
                ncNickElem.html(userName);
                lookNumElem.html(lookNum);
                fansNumElem.html(fansNum);
                switch(gender) {
                    case "M" :
                        mElem.show();
                        break;
                    case "F" :
                        wElem.show();
                        break;
                    case "S" :
                        break;
                }

                var myInfo = Trafficeye.getMyInfo();
                var timeline_user = Trafficeye.offlineStore.get("traffic_timeline_user");
                //如果是自己才显示详细资料按钮
                if(myInfo.uid == timeline_user){
                    var detailbtnElem = me.elems["detailbtn"];
                    detailbtnElem.html("详细<br />资料");
                   // detailbtnElem.onbind("touchend",me.detailbtnUp,me);
                }

                Trafficeye.imageLoaded(headImgElem, avatar);

                me.loadmoreHander(userData.uid);
            }
        },
        /**
         * 请求用户关系信息
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqRelationShipInfo : function(url, data) {
            var me = this,
                lookbtnElem = me.elems["lookbtn"];
            var userData = data;
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
                        if (data) {
                            var timelineuid = Trafficeye.offlineStore.get("traffic_timeline_user");
                            var me = this;
                            //var htmls = ["<li><span class='g-cancel' onclick=\"cancelLook('" + data.uid + "');\">取消关注</span>"];
                            var htmls = [];
                            if (data.relationship == 0) {
                                htmls.push("<a onclick=\"addLook('" + timelineuid + "',this);\">加关注</a>");
                            } else if(data.relationship == 1) {
                                htmls.push("<a onclick=\"cancelLook('" + timelineuid + "',this);\">已关注</a>");
                            }else if(data.relationship == 2) {
                                htmls.push("<a onclick=\"addLook('" + timelineuid + "',this);\">加关注</a>");
                            }else if(data.relationship == 3) {
                                htmls.push("<a style=\"width:80px\" onclick=\"cancelLook('" + timelineuid + "',this);\">互相关注</a>");
                            }
                            lookbtnElem.html(htmls.join(""));

                        } else {
                            me.reqUserInfoFail();
                        }
                    }
                })
            }
        },        
        /**
         * 请求用户信息失败后的处理函数
         */
        reqUserInfoFail : function() {

        },
        /**
         * 加载更多数据处理函数
         */
        loadmoreHander : function(uid) {
            var me = this;
            if (uid) {
                //请求用户时间线协议
                var userTimeline_url = BASE_URL + "user_timeline";
                var userData = {};
                userData.uid = uid;
                // userData.start = me.pageNumManager.getStart();
                // userData.end = me.pageNumManager.getEnd();
                userData.page = me.pageNumManager.getStart()/me.pageNumManager.BASE_NUM;
                userData.count = me.pageNumManager.BASE_NUM;
                var userTimeline_data = userData;
                me.reqUserTimeline(userTimeline_url, userTimeline_data);
            }
        },
        /**
         * 请求用户时间线
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqUserTimeline : function(url, data) {
            var me = this;
            var reqParams = Trafficeye.httpData2Str(data);
            if (url) {
                var reqUrl = url + reqParams;
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        Trafficeye.httpTip.closed();
                        if (data && !me.isStopReq) {
                            var state = data.state.code;
                            if (state == 0) {
                                me.reqUserTimelineSuccess(data.timeline);
                            } else if(state == -99){
                                me.reqLoadNo();
                            } else {
                                me.reqUserTimelineFail(data);
                            }
                        } else {
                            me.reqUserTimelineFail(data);
                        }
                    }
                })
            } else {
                me.reqUserTimelineSuccess(commentDemo);
            }
        },
        
        reqLoadNo : function() {
            var me = this;
            Trafficeye.httpTip.closed();
            me.elems["loadmorebtn"].css("display", "none");
        },
        // /**
        //  * 请求用户时间线成功后的处理函数
        //  * @param  {JSON Object} data
        //  */
        // reqUserTimelineSuccess : function(data) {
        //     var me = this;
        //     if ($.isArray(data) && me.userTimelineManager) {
        //         me.userTimelineManager.setNewTimelineData(data);
        //         var html = me.userTimelineManager.getNewTimelineHtml(data);
        //         me.userTimelineManager.mergeNewTimelineData();
        //         me.elems["commentlistid"].append(html);
        //     }
        // },
        /**
         * 请求用户时间线成功后的处理函数
         * @param  {JSON Object} data
         * @param  {Boolean} isOffline 是否是离线数据
         */
        reqUserTimelineSuccess : function(data, isOffline) {
            var me = this;
            if ($.isArray(data) && me.userTimelineManager) {
                var pageNumMger = me.pageNumManager;
                //传入的数据是非离线存储数据时
                if (!isOffline) {
                    //判断是否是最新的10条数据
                    var flag = false;
                    if (pageNumMger.start == 0) {
                        flag = true;
                    }
                    //console.log(offlineStoreData);
                }
                //当前结果集请求的结束位置
                var currentEnd = pageNumMger.getEnd();
                //更新下次请求分页起始位置
                pageNumMger.start = currentEnd + 1;
                //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
                if (data.length < pageNumMger.BASE_NUM) {
                    pageNumMger.setIsShowBtn(false);
                } else {
                    pageNumMger.setIsShowBtn(true);
                }

                
                me.userTimelineManager.setNewTimelineData(data);
                var html = me.userTimelineManager.getNewTimelineHtml(data);
                me.userTimelineManager.mergeNewTimelineData();
                me.elems["commentlistid"].append(html);
                if (pageNumMger.getIsShowBtn()) {
                    me.elems["loadmorebtn"].css("display", "");
                    me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp(this)\";>加载更多</div>");
                } else {
                    me.elems["loadmorebtn"].css("display", "none");
                }
            }
        },
        /**
         * 点击攒按钮处理函数
         */
        praisebtnUp : function(publishId, friendId,evt) {
            var me = this;
            var myInfo = Trafficeye.getMyInfo();
            var uid = myInfo.uid;
            var friendid = friendId;
            var publishid = publishId;
            var pid = myInfo.pid;
            var reqType = "line";
            me.reqPraiseServer(uid, friendid, publishid, pid, reqType,evt);
        },

        reqPraiseServer : function (uid, friendid, publishid, pid, reqType,evt) {
            var me = this,elem,ememazn;
                elem = evt.firstChild;
                elemzan = evt.parentNode.nextSibling;
            var BASE_PRAISE_URL = "http://mobile.trafficeye.com.cn:21290/TrafficeyeCommunityService/sns/v1/praise";
            var data = {
                "uid" : uid,
                "friend_id" : friendid,
                "publish_id" : publishid,
                "type" : "event",
                "pid" : pid,
                "requestType" : reqType
            };
            var reqParams = Trafficeye.httpData2Str(data);
            var reqUrl = BASE_PRAISE_URL + reqParams;
            $.ajaxJSONP({
                url : reqUrl,
                success: function(data){
                    $(elem).removeClass("curr");
                    if (data.state.code == 0) {
                        elem.innerHTML = " 赞 " + data.state.extras;
                         var praiseavatorhtml = me.PraiseAvatorManager.getPraiseAvatorHtml(data.praiseList);
                         var elemzanTemp = $(elemzan);
                            var children = elemzanTemp.children(); //获得ul标签下的所有子元素
                            if (children.length > 0) { 
                                //如果ul下面有子元素，查找赞元素
                                var elems = $(children[0]).find("div.zan");
                                if (elems.length > 0) {//有赞元素，则删除
                                    elems.parent().remove();
                                    //判断是否有评论元素
                                    if (children.length > 1) {
                                        //获取第一个评论元素，并在此元素签名添加赞元素
                                        children.eq(1).before(praiseavatorhtml);
                                    } else {
                                        //直接在ul元素下添加赞元素
                                        elemzanTemp.append(praiseavatorhtml);
                                    }
                                } else { //没有赞元素，只有评论元素
                                    //获取第一个评论元素，并在此元素签名添加赞元素
                                    children.eq(0).before(praiseavatorhtml);
                                }
                            } else {
                                //直接在ul元素下添加赞元素
                                elemzanTemp.append(praiseavatorhtml);
                            }
                    }
                }
            })
        },
        /**
         * 点击查看所有评论处理函数
         */
        lookAllCommentbtnUp : function(publishId,evt) {
            var publishid = publishId;
            var userInfoManager = this.userInfoManager;
            var data = {};
            data.uid = userInfoManager.uid;
            var info = userInfoManager.info;
            if (info) {
                data.username = info.username;
                data.publishid = publishid;
            }
            var dataStr = Trafficeye.json2Str(data);
            Trafficeye.offlineStore.set("traffic_evtdetail", dataStr);
            
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("personaldetails.html");
            }),Trafficeye.MaskTimeOut);
        },
        /**
         * 请求用户时间线失败后的处理函数
         */
        reqUserTimelineFail : function(data) {
            var me = this;
            var html = [];
                 html.push("<div class='qplnone'>"+data.state.desc+"</div>");
                 me.elems["commentlistid"].append(html.join(""));
        },
        /**
         * 查看评论者时间线
         * @param  {Int} uid
         */
        lookOtherTimeline : function(uid,evt) {
            var data = Trafficeye.offlineStore.get("traffic_timeline");
                data = data + "," + uid;
                Trafficeye.offlineStore.set("traffic_timeline", data);
                
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("timeline.html");
            }),Trafficeye.MaskTimeOut);
        },
        /**
         * 返回上一页面
         */
        backPage : function() {
            // var data = Trafficeye.offlineStore.get("traffic_timeline");
            // var arr = data.split(",");
            // arr.pop();
            // var data = Trafficeye.offlineStore.set("traffic_timeline", arr.join(","));
            var fromSource = Trafficeye.offlineStore.get("traffic_fromsource");
            // var fromSource = Trafficeye.fromSource();
            if(fromSource == "trafficeye_personal"){
            // 
                if (Trafficeye.mobilePlatform.android) {
                    window.init.finish();
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc://closeSelf");
                } else {
                    alert("调用本地goPersonal方法,PC不支持.");
                }
            }else{
                // Trafficeye.toPage(fromSource.prepage);
                Trafficeye.toPage("com_index.html");
            }
            // Trafficeye.toPage("com_index.html");
        },
         /**
         * 加关注按钮处理函数
         * @return {uid} 被关注的用户ID
         */
        addLook : function(friend_id,evt) {
            var me = this;
            //获取本人UID
            var myInfo = Trafficeye.getMyInfo();
            me.reqAddLook(myInfo.uid, friend_id, myInfo.pid,evt);
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
                            reqAddLookSuccess(data,friendId,evt);
                        } else {
                            alert("关注未成功");
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
                    evt.setAttribute("onclick","cancelLook('"+friendId+"',this)");
                }else if(data.friendShip == 3){
                    evt.textContent = "相互关注";
                    //evt.target.setAttribute("onclick","cancelLook('"+friendId+"',this)");
                    evt.setAttribute("onclick","cancelLook('"+friendId+"',this)");
                    evt.setAttribute("style","width:80px");
                }
            }else{
                alert(data.desc);                
            }
        },
        /**
         * 取消关注按钮处理函数
         * @return {uid} 被取消关注的用户ID
         */
        cancelLook : function(uid,evt) {            
            var me = this;
            var myInfo = Trafficeye.getMyInfo();
            me.reqCancelLook(myInfo.uid, uid, myInfo.pid,evt);
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
            var url = BASE_FRIENDSSHIP_URL + "destroy";
            if (url) {
                Trafficeye.httpTip.opened(function() {
                    me.isStopReq = true;
                }, me);
                me.isStopReq = false;
                var reqUrl = url + reqParams;
                //console.log(reqUrl);
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        console.log(data);
                        if (data && !me.isStopReq) {
                            me.reqCancelLookSuccess(data,friendId,evt);
                        } else {
                            me.reqCancelLookFail();
                        }
                    }
                })
            }
        },
        reqCancelLookSuccess : function(data,friendId,evt) {      
                Trafficeye.httpTip.closed();   
               // console.log(data);   
                if (data && data.code == 0) {
                   if(data.friendShip == 0){
                     //   evt.target.innerHTML = "加关注";
                      //  evt.target.setAttribute("onclick","addLook('"+friendId+"',this)");
                         evt.textContent = "加关注";    
                        evt.setAttribute("onclick","addLook('"+friendId+"',this)");
                    }else if(data.friendShip == 2){
                     //   evt.textContent = "加关注";
                    //    evt.setAttribute("onclick","addLook('"+friendId+"',this)");
                         evt.textContent = "加关注";    
               evt.setAttribute("onclick","addLook('"+friendId+"',this)");
                    }      
                }else{
                    alert(data.desc);                    
                }            
        },
        reqCancelLookFail : function() {

        },
        /**
         * 刷新按钮处理函数
         */
        refreshHandler : function(uid) {
            var me = this;
            //请求用户信息协议
            var userInfo_url = BASE_URL + "userinfo";
            //22390、10924
            var userInfo_data = {"uid" : uid};
            this.reqUserInfo(userInfo_url, userInfo_data);
        }
    };

    //请求赞服务延时对象
    var praiseTimer = null;
    //基础URL
    var BASE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/user/";
    //赞URL
    var BASE_PRAISE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/";
    //请求关系URL
    var BASE_FRIENDSSHIP_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/friendships/";

    $(function(){
        
        // 获取从个人项目跳转过来的数据，回调函数
        window.personalGotoCommunityPage  = function(dataClient){
            Trafficeye.httpTip.closed();
            var dataStr = Trafficeye.str2Json(dataClient);
    
            Trafficeye.offlineStore.set("traffic_myinfo", Trafficeye.json2Str(dataStr.myInfo));
            Trafficeye.offlineStore.set("traffic_timeline",dataStr.traffic_timeline);
            Trafficeye.offlineStore.set("traffic_fromsource",dataStr.prepage);
            window.initPageManager();
        };
        
        window.initPageManager = function(){
            //请求用户信息协议
            var userInfo_url = BASE_URL + "userinfo";
            var friendsshipInfo_url = BASE_FRIENDSSHIP_URL + "find";
            var data = Trafficeye.offlineStore.get("traffic_timeline");
            if (data) {
                var arr = data.split(",");
                var userTimeline_uid = arr[arr.length - 1];
                var userTimeline_data = {"uid":userTimeline_uid};

                //存储当前显示时间线页面的用户信息
                Trafficeye.offlineStore.set("traffic_timeline_user", userTimeline_uid);

                //获取本人UID
                var myInfo = Trafficeye.getMyInfo();
                //存储跳转到消息关注页面需要的数据
                var chatData = {
                    "uid" : myInfo.uid,
                    "friend_id" : userTimeline_uid
                };
                
                var chatDataStr = Trafficeye.json2Str(chatData);

                Trafficeye.offlineStore.set("traffic_chat", chatDataStr);

                var flag = false;
                
                if (myInfo.uid != userTimeline_uid) {
                    flag = true;
                }
                var pm = new PageManager();

                Trafficeye.pageManager = pm;
                //初始化用户界面
                pm.init(flag);
                //请求用户数据，填充用户界面元素
                pm.reqUserInfo(userInfo_url, userTimeline_data);
                //判断是否是本人的时间线页面，如果是，不显示消息关注按钮，否则显示
                if (myInfo.uid != userTimeline_uid) {
                    //请求用户界面关系内容
                    pm.reqRelationShipInfo(friendsshipInfo_url,chatData);
                }            
            }
        }

        window.gotoTimeline = function(uid,evt) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.lookOtherTimeline(uid,evt);
            }
        };

        window.gotoEvtdetail = function(publishId,evt) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.lookAllCommentbtnUp(publishId,evt);
            }
        };

        window.gotoPraise = function(publishId, friendId, evt) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {               
                $(evt.firstChild).addClass("curr");
                if (praiseTimer) {
                    window.clearTimeout(praiseTimer);
                    praiseTimer = null;
                }
                praiseTimer = window.setTimeout(function() {
                    pm.praisebtnUp(publishId, friendId,evt);
                }, 1000);
            }
        };

        window.addLook = function(uid,evt) {
            var pm = Trafficeye.pageManager;
                    if (pm.init) {
                        pm.addLook(uid,evt);
                    }
                };

        window.cancelLook = function(uid,evt) {
            var pm = Trafficeye.pageManager;
                    if (pm.init) {
                        pm.cancelLook(uid,evt);
                    }
                };
                
        window.reqAddLookSuccess = function(data,uid,evt) {
            var pm = Trafficeye.pageManager;
                    if (pm.init) {
                        pm.reqAddLookSuccess(data,uid,evt);
                    }
                };
                
         window.loadmorebtnUp = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loadmorebtnUp(evt);
            }
        };

        window.backPage = function() {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.backPage();
            }
        };
        window.initPageManager();
        // window.personalGotoCommunityPage("{\"prepage\":\"trafficeye_personal\",\"pid\":\"BB7CAB21-2A8C-48D0-860B-C8B79EB2DE9C\",\"uid\":\"40324\",\"traffic_timeline\":\"40293\",\"myInfo\":{\"badgeNum\":1,\"avatarUrl\":\"\",\"wxNum\":\"1234\",\"level\":1,\"eventNum\":0,\"mobile\":\"13581604288\",\"frineds\":0,\"idNum\":\"\",\"totalMilage\":0,\"nextLevel\":2,\"city\":\"甘肃 兰州市\",\"realName\":\"张3\",\"ownedBadges\":[{\"name\":\"新人徽章\",\"id\":1,\"obtainTime\":\"2014-05-28 22:33:56\",\"smallImgName\":\"badge_register.png\",\"imgName\":\"badge_big_register.png\",\"desc\":\"注册账号\"}],\"email\":\"wgy52@wgy.wgy\",\"totalBadges\":30,\"totalTrackMilage\":0,\"fans\":0,\"carNum\":\"345345\",\"totalCoins\":0,\"username\":\"Wgy52\",\"userType\":\"trafficeye\",\"levelPoint\":30,\"levelPercent\":11,\"uid\":\"40324\",\"birthdate\":\"2014-01-09\",\"gender\":\"M\",\"totalPoints\":34,\"nextLevelPoint\":65,\"mobileValidate\":1,\"qq\":\"123321444\",\"description\":\"\",\"userGroup\":0}}");
    }); 
    
 }(window));