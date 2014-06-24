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
        /*
            <div class="nxx">
                <img src="images/iimg.jpg" alt="" width="320" height="134" />
            </div>
         */
        createMediaHtml : function(url,publishId) {
            var htmls = ["<div class='nxx' onclick=\"gotoEvtdetail('" + publishId + "',this);\">"];
            //htmls.push("<img src='" + url + "'/>");
            htmls.push("<img src='" + url + "' width='300' height/>");
            htmls.push("</div>");
            return htmls.join("");
        },
        createCommentHtml : function(data) {
            var me = this;
            var avaterSrc = "";
                if (!data.avatar) {
                    avaterSrc = "com_images/default.png";
                } else {
                    avaterSrc = data.avatar;
                }
            var htmls = ["<li>"];
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
                //判断是否有头像数据，如果没有，显示默认头像
                var avaterSrc = "";
                if (!data.avatar) {
                    avaterSrc = "com_images/default.png";
                } else {
                    avaterSrc = data.avatar;
                }

                htmls.push("<ul class='l-list'><li>");
                //判断是否是自己发布的事件，如果不是，显示攒按钮
                //if (data.uid != uid) {
                    publishId = data.publish_id;
                    htmls.push("<div class='l-r' onclick=\"gotoPraise('" + publishId + "','" + data.uid + "', this);\"><a class='z'> 赞 " + data.praise_count + "  </a></div>");
                //}
                
                htmls.push("<div class='l-img' onclick=\"gotoTimeline('" + data.uid + "',this);\"><img src='" + avaterSrc + "' width='40' height='40'/></div>");
                htmls.push("<div class='l-text' onclick=\"gotoTimeline('" + data.uid + "',this);\"><h3>" + data.username + "</h3></div>");
                htmls.push("<div class='l-cont'>" + data.content + "</div>");
                if (data.media) {
                    htmls.push(me.createMediaHtml(data.media,publishId));
                }
                htmls.push("<h4>" + data.time + "前</h4>");
                htmls.push("</li>");
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
                    htmls.push("<div class='qpl' onclick=\"gotoEvtdetail('" + publishId + "',this);\">查看并发表评论</div></ul>");
                }else{
                    htmls.push("<div class='qpl' onclick=\"gotoEvtdetail('" + publishId + "',this);\">查看全部" + data.comment_count + "条评论</div></ul>");
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
            "editbtn" : null,
            "refreshbtn" : null,
            "loadmorebtn" : null,
            "lookdefault" : null,
            "addlook" : null,
            "invite" : null,
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
        init : function() {
            var me = this;
            me.pageNumManager = new Trafficeye.PageNumManager();
            me.userInfoManager = new UserInfoManager();
            me.userTimelineManager = new UserTimelineManager();
            me.userTimelineManager.setUserInfoManager(me.userInfoManager);
            me.PraiseAvatorManager = new PraiseAvatorManager();
            me.PraiseAvatorManager.setUserInfoManager(me.userInfoManager);
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
                detailbtnElem = me.elems["detailbtn"],
                headimgbtnElem = me.elems["headimgbtn"],
                looklistbtnElem = me.elems["looklistbtn"],
                fanslistbtnElem = me.elems["fanslistbtn"],
                refreshbtnElem = me.elems["refreshbtn"],
               //loadmorebtnElem = me.elems["loadmorebtn"],
                lookdefaultElem = me.elems["lookdefault"],
                editbtnElem = me.elems["editbtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            //详情按钮
            detailbtnElem.onbind("touchstart",me.btnDown,detailbtnElem);
            detailbtnElem.onbind("touchend",me.detailbtnUp,me);
            //修改头像按钮
            // headimgbtnElem.onbind("touchend",me.headimgbtnUp,me);
            headimgbtnElem.css("display", "");
            lookdefaultElem.css("display","none;");
            //查看关注列表按钮
            looklistbtnElem.onbind("touchend",me.looklistbtnUp,me);
            //查看粉丝列表按钮
            fanslistbtnElem.onbind("touchend",me.fanslistbtnUp,me);
            //编辑按钮
            editbtnElem.onbind("touchstart",me.btnDown,editbtnElem);
            editbtnElem.onbind("touchend",me.editbtnUp,me);
            //刷新按钮
            refreshbtnElem.onbind("touchstart",me.btnDown,refreshbtnElem);
            refreshbtnElem.onbind("touchend",me.refreshbtnUp,me);
            //加载更多按钮
          //  loadmorebtnElem.onbind("touchstart",me.loadmorebtnDown,loadmorebtnElem);
           // loadmorebtnElem.onbind("touchend",me.loadmorebtnUp,me);
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
            if (Trafficeye.mobilePlatform.android) {
                window.init.finish();
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc://closeSelf");
            } else {
                alert("调用本地goPersonal方法,PC不支持.");
            }
        },
        detailbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if (Trafficeye.mobilePlatform.android) {
                window.init.goPersonal();
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc://goUserCenter");
            } else {
                alert("调用本地goPersonal方法,PC不支持.");
            }
        },
        headimgbtnUp : function(evt) {
            $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                if (Trafficeye.mobilePlatform.android) {
                    window.init.goPersonal();
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc://goUserCenter");
                } else {
                    alert("调用本地goPersonal方法,PC不支持.");
                }
            }),Trafficeye.MaskTimeOut);       
        },
        
        looklistbtnUp : function(evt) {
            Trafficeye.offlineStore.set("traffic_lookfans", "look");
            Trafficeye.toPage("lookfans.html");
        },
        fanslistbtnUp : function(evt) {
            Trafficeye.offlineStore.set("traffic_lookfans", "fans");
            Trafficeye.toPage("lookfans.html");
        },
        editbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            if (Trafficeye.mobilePlatform.android) {
                window.init.goUserInfoMgr();
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc://goUserEdit");
            } else {
                alert("调用本地goUserInfoMgr方法,PC不支持.");
            }
        },
        refreshbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            var uid = me.userInfoManager.uid;
            var pid = me.userInfoManager.pid;
            if (uid && pid) {
                me.pageNumManager.reset();
                me.elems["loadmorebtn"].css("display", "none");
                me.elems["commentlistid"].html("");
                me.refreshHandler(uid,pid);
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
            //判断上次请求用户主页数据离现在超过5分钟没
            var myDataStr = Trafficeye.offlineStore.get("traffic_myhomepage_data");
            //console.log(myDataStr);
            //  if (myDataStr) {
            //    // console.log(myDataStr);
            //     var myData = Trafficeye.str2Json(myDataStr);
            //     var nowTime = Trafficeye.getDateTime();
               
            //     if ((myData.userUid == data.uid)) {
                   
            //         me.reqUserInfoSuccess(myData.userData, userData, myData.timelineData);
            //         return;
            //     }                
            // }
            
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
                            me.reqUserInfoSuccess(data, userData);
                        } else {
                            me.reqUserInfoFail();
                        }
                    }
                })
            }
        },

        /**
         * 请求用户信息
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqRreshUserInfo : function(url, data) {
            var me = this;
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
            var url = BASE_FRIEND_URL + "create";
            if (url) {
                Trafficeye.httpTip.opened(function() {
                    me.isStopReq = true;
                }, me);
                me.isStopReq = false;
                var reqUrl = url + reqParams;
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        $(evt).removeClass("curr");
                        if (data.code == 0 && !me.isStopReq) {
                            me.refreshbtnUp(evt);//关注成功之后，重新刷新页面
                        } else {
                            Trafficeye.httpTip.closed();
                            alert(data.desc);
                        }
                    }
                })
            }
        },
        /**
         * 请求用户信息成功后的处理函数
         * @param  {JSON Object} data
         */
        reqUserInfoSuccess : function(data, userData, offlineTimelineData) {

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
                //存储本人的信息
                
                data.uid = userData.uid;
                data.pid = userData.pid;
                //console.log(data);
                var dataStr = Trafficeye.json2Str(data);
                //console.log(dataStr);
                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);

                Trafficeye.imageLoaded(headImgElem, avatar);
                if (!offlineTimelineData) {
                    offlineStoreData.userUid = userData.uid;
                    offlineStoreData.userData = data;
                    me.loadmoreHander(userData.uid);
                } else {
                    me.reqUserTimelineSuccess(offlineTimelineData, true);
                }
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
                var userTimeline_url = BASE_URL + "public_timeline";
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
                                me.reqUserTimelineSuccess(data);
                                me.reqUserTimelineDefault("none");
                            } else if(state == -1){
                                me.reqUserTimelineDefault("");
                            } else if(state == -99){//没有加载更多
                                me.reqLoadNo();
                            } else{
                                me.reqUserTimelineFail();
                            }
                        } else {
                            me.reqUserTimelineFail();
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
        /**
         * 请求用户时间线成功后的处理函数
         * @param  {JSON Object} data
         * @param  {Boolean} isOffline 是否是离线数据
         */
        reqUserTimelineSuccess : function(dataSource, isOffline) {
            var me = this;
            data = dataSource.timeline;
            if ($.isArray(data) && me.userTimelineManager) {
                var pageNumMger = me.pageNumManager;
                //传入的数据是非离线存储数据时
                if (!isOffline) {
                    //判断是否是最新的10条数据
                    var flag = false;
                    if (pageNumMger.start == 0) {
                        flag = true;
                        offlineStoreData.timelineData = data;
                        offlineStoreData.timestamp = Trafficeye.getDateTime();
                    }
                    //console.log(offlineStoreData);
                    if (flag) {
                      //  console.log(offlineStoreData);
                        //存储个人主要公共时间线最新10条数据
                        var dataStr = Trafficeye.json2Str(offlineStoreData);
                        // console.log(offlineStoreData);
                        Trafficeye.offlineStore.set("traffic_myhomepage_data", dataStr);
                    }
                }
                //当前结果集请求的结束位置
                var currentEnd = pageNumMger.getEnd();
                //更新下次请求分页起始位置
                pageNumMger.start = currentEnd + 1;
                //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
                // if (data.length < pageNumMger.BASE_NUM) {
                    console.log(dataSource.nextPage);
                if(dataSource.nextPage == -1){ 
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
            var userInfo = this.userInfoManager;
            var uid = userInfo.uid;
            var friendid = friendId;
            var publishid = publishId;
            var pid = userInfo.pid;
            var reqType = "info";
            me.reqPraiseServer(uid, friendid, publishid, pid, reqType,evt);
        },

        reqPraiseServer : function (uid, friendid, publishid, pid, reqType,evt) {
            var me = this,elem,ememazn;
                elem = evt.firstChild;
                elemzan = evt.parentNode.nextSibling;
                
            var BASE_PRAISE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/praise";
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
                   // console.log(data);
                    if (data.state.code==0) { //如果赞返回结果是0，表示赞成功
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
            $(evt).addClass("curr");
            var dataStr = Trafficeye.json2Str(data);
            Trafficeye.offlineStore.set("traffic_evtdetail", dataStr);
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("personaldetails.html");
            }),Trafficeye.MaskTimeOut);
        },
        /**
         * 如果用户默认是没有公共线，默认可以关注路况交通眼并邀请用户
         */
        reqUserTimelineDefault : function(view) {
            var me = this,
             lookdefaultElem = me.elems["lookdefault"];
             lookdefaultElem.css("display",view);
        },
        /**
         * 请求用户时间线失败后的处理函数
         */
        reqUserTimelineFail : function() {

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
        /**
         * 刷新按钮处理函数
         */
        refreshHandler : function(uid,pid) {
            var me = this;
            //请求用户信息协议
            var userInfo_url = BASE_URL + "userinfo";
            //22390、10924
            var userInfo_data = {"uid" : uid,"pid" : pid};
            this.reqRreshUserInfo(userInfo_url, userInfo_data);
        }
    };

    //请求赞服务延时对象
    var praiseTimer = null;
    //离线存储个人主页最新数据
    var offlineStoreData = {
        userUid : "",
        userData : {},
        timelineData : [],
        timestamp : Trafficeye.getDateTime()
    };
    //判断加载页面的时候是否请求个人主页最新数据
    var TIME_REFRESH = 5 * 60 * 1000; //5分钟毫秒数
    //基础URL
    var BASE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/user/";
    //赞URL
    var BASE_PRAISE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/";
    //好友关系URL
    var BASE_FRIEND_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/friendships/";
    
    $(function(){
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
                 //pm.praisebtnUp(publishId, friendId,evt);
            }
        };
        
        window.loadmorebtnUp = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loadmorebtnUp(evt);
            }
        };

        window.headimgbtnUp = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.headimgbtnUp(evt);
            }
        };

        window.initPageManager = function(uid, pid,width,height,source) {
            //把来源信息存储到本地
             var fromSource = {"source" : source,"prepage" : "com_index.html"}
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
            //请求用户信息协议
            var userInfo_url = BASE_URL + "userinfo";
            //22390、10924、22376
            var userInfo_data = {
                "uid" : uid,
                "pid" : pid || 0
            };
            
            var pm = new PageManager();

            Trafficeye.pageManager = pm;
            //初始化用户界面
            pm.init();
            pm.userInfoManager.setUid(uid);
            pm.userInfoManager.setPid(pid);
            //请求用户数据，填充用户界面元素
            pm.reqUserInfo(userInfo_url, userInfo_data);
        };

        window.loadmorebtnUp = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loadmorebtnUp(evt);
            }
        };
        
        window.addLook = function(uid,evt) {
            $(evt).addClass("curr");
              var pm = Trafficeye.pageManager;
              if (pm.init) {
                    pm.addLook(uid,evt);
              }
        };
        
        window.invite = function() {
              Trafficeye.toPage("invite.html");
        };
        
    });
    
 }(window));