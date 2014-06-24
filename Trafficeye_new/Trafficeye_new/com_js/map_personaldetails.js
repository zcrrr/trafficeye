 (function(window) { //闭包
    function UserInfoManager() {
        this.info = null;
        this.uid = null;
        this.pid = null;
        this.publishType = null;
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
        },
        setPublishType : function(publishType) {
            this.publishType = publishType;
        }
    };

     function CommentsInfoManager() {
        this.userInfoManager = null;
    };
    CommentsInfoManager.prototype = {//方法挂载在原型链

        setUserInfoManager : function(manger) {
            this.userInfoManager = manger;
        },
        
        creatCommentsHtml : function(data) {
            var me = this;
            var avaterSrc = "";
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            //var htmls = ["<div class='l-r'><a class='g'>共享</a></div>"];
            //var htmls = ["<div class='l-r'></div>"];
           var htmls = [];
            htmls.push("<li><div class='l-img' onclick=\"gotoTimeline('" + data.comment_uid + "',this);\"><img src = '" + avaterSrc + "' alt='' width='40' height='40' /></div>");
            htmls.push("<div class='l-text'>");
            htmls.push("<h3>" + data.followers_name + "   <span>"+data.comment_time+"前</span></h3>");
            htmls.push("<span>" + data.comment_content + "</span>");
           // htmls.push("<h4>" + data.comment_time + "前</h4>");
            htmls.push("</div></li>");
            return htmls.join("");
        },

        getCommentsHtml : function(comments) {
            var data = comments;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                if(data[i].comment_content){
                 htmls.push(this.creatCommentsHtml(data[i]));
                }
            }
            return htmls.join("");
        }
    };

    function PraiseAvatorManager() { 
        this.userInfoManager = null;
    };
    PraiseAvatorManager.prototype = {//方法挂载在原型链

        setUserInfoManager : function(manger) {
            this.userInfoManager = manger;
        },
        
         creatPraiseAvatorHtml : function(data) {
            var me = this;
            var htmls = [];
            htmls.push("<span  onclick=\"gotoTimeline('" + data.uid + "',this);\">"+data.name+"</span>");
            return htmls.join("");
        },

        getPraiseAvatorHtml : function(praiseavator) {
            var data = praiseavator;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                if(data[i].name&&data[i].name != ""){//赞列表头像不为空
                    if(len-i == 1){
                        htmls.push(this.creatPraiseAvatorHtml(data[i]));
                    }else{
                        htmls.push(this.creatPraiseAvatorHtml(data[i])+"、");
                    }
                }
            }
            return htmls.join("");
        }
    };

    function PageManager() {
        //ID元素对象集合
        this.elems = {
            "media_id" : null,
            "praise_count_btn" : null,
            "sharebtn" : null,
            "user_avater_id" : null,
            "usernameid" : null,
            "timeid" : null,
            "contentid" : null,
            "praiseavatarlistid" : null,
            "inputtext" : null,
            "inputbtn" : null,            
            "backpagebtn" : null,
            "refreshbtn" : null,
            "praiseviewid" : null,
            "commentslistid" : null
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
            me.PraiseAvatorManager = new PraiseAvatorManager();
            me.CommentsInfoManager = new CommentsInfoManager();
            me.PraiseAvatorManager.setUserInfoManager(me.userInfoManager);
            me.CommentsInfoManager.setUserInfoManager(me.userInfoManager);
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
                praisecountbtnElem = me.elems["praise_count_btn"],
                sharebtnElem = me.elems["sharebtn"],
                backpagebtnElem = me.elems["backpagebtn"],
                refreshbtnElem = me.elems["refreshbtn"];
                //sumbitbtnElem = me.elems["inputbtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            //分享按钮
            sharebtnElem.onbind("touchend",me.sharebtnUp,me);
            //赞按钮
            praisecountbtnElem.onbind("touchstart",me.btnDown,praisecountbtnElem);
            praisecountbtnElem.onbind("touchend",me.praisebtnUp,me);
            //刷新按钮
            refreshbtnElem.onbind("touchstart",me.btnDown,refreshbtnElem);
            refreshbtnElem.onbind("touchend",me.refreshbtnUp,me);
            //回复评论提交按钮
           // sumbitbtnElem.onbind("touchstart",me.sumbitbtnUp,me);
        },
        /**
         * 按钮按下事件处理器
         * @param  {Event} evt
         */
        btnDown : function(evt) {
            this.addClass("curr");
        },
        sharebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
        },
        //返回到客户端
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
        /**
         * 点击回复评论处理函数
         */
        sumbitbtnUp : function(evt) {
            var me = this;
            var dataStr = Trafficeye.offlineStore.get("traffic_evtdetail");            
            var obj = Trafficeye.str2Json(dataStr);
            var uid = me.userInfoManager.uid;
            var publish_id = obj.publishid;
            var myInfo = Trafficeye.getMyInfo();
            if(myInfo.uid == 0){
                var content = encodeURI(encodeURI("请您登录后再操作"));
                Trafficeye.toPage("objc://showAlert::/"+content); 
            }else{                
                var textContent = me.elems["inputtext"].attr("value");
                var sumbitBtnUp_url = BASE_PRAISE_URL + "comments/create";
                var sumbitBtnUp_data = {"uid" : myInfo.uid,"publish_uid" : uid,"publish_id" : publish_id,"publish_type" : "event","comment_type" : 1,"pid" : myInfo.pid,"comment_content":$.trim(textContent)};
                    
                if(textContent){
                    me.reqSumbitbut(sumbitBtnUp_url, sumbitBtnUp_data);
                }else{
                    var content = encodeURI(encodeURI("内容不能为空"));
                    Trafficeye.toPage("objc://showAlert::/"+content); 

                }
            }      
        },
        /**
         * 回复评论请求函数
         */
        reqSumbitbut : function(url, data) {
            var me = this,
                commentslistidElem = me.elems["commentslistid"];
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
                                var commenthtml = me.CommentsInfoManager.getCommentsHtml(data.comments); 
                                    commentslistidElem.html(commenthtml);
                            } else {
                                me.reqPraiseFail();
                            }
                        } else {
                            me.reqPraiseFail();
                        }
                    }
                })
            } else {
                me.reqPraiseFail();
            }
        },
        /**
         * 点击攒按钮处理函数
         */
        praisebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            var praiseBtnUp_url = BASE_PRAISE_URL + "praise";
            var dataStr = Trafficeye.offlineStore.get("traffic_evtdetail");
            
            var obj = Trafficeye.str2Json(dataStr);
            var uid = me.userInfoManager.uid;
            var publish_id = obj.publishid;
            var myInfo = Trafficeye.getMyInfo();
            var praiseBtnUp_data = {"uid" : myInfo.uid,"friend_id" : uid,"publish_id" : publish_id,"type" : "event","pid" : myInfo.pid,"requestType" : "info"};
            if(myInfo.uid == 0){
                var content = encodeURI(encodeURI("请您登录后再操作"));
                Trafficeye.toPage("objc://showAlert::/"+content); 

            }else{
                me.reqPraise(praiseBtnUp_url, praiseBtnUp_data);
            }
        },
        /**
         * 点击攒按钮请求函数
         */
        reqPraise : function(url, data) {
            var me = this,
            praiseviewidElem = me.elems["praiseviewid"];
             praiseavatarlistidElem = me.elems["praiseavatarlistid"];
            var reqParams = Trafficeye.httpData2Str(data);
            if (url) {
                var reqUrl = url + reqParams;
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        Trafficeye.httpTip.closed();
                        if (data && !me.isStopReq) {
                            var state = data.state.code;
                            if (state == 0) {    //点击赞成功
                                me.setPraiseCount(data.state.extras);
                                praiseviewidElem.css("display","");
                                var praiseavatorhtml = me.PraiseAvatorManager.getPraiseAvatorHtml(data.praiseList);
                                    praiseavatarlistidElem.html(praiseavatorhtml);

                            } else {
                                me.reqPraiseFail();
                            }
                        } else {
                            me.reqPraiseFail();
                        }
                    }
                })
            } else {
                me.reqPraiseFail();
            }
        },
        refreshbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
                $(elem).removeClass("curr");
            var dataStr = Trafficeye.offlineStore.get("traffic_evtdetail");
            var obj = Trafficeye.str2Json(dataStr);
            //请求用户信息协议
            var userInfo_url = BASE_URL + "info";
            var userInfo_data = {"publishId" : obj.publishid,"publishType" : me.userInfoManager.publishType};
            
            var pm = Trafficeye.pageManager;

            //初始化用户界面
            pm.init();
            //请求用户数据，填充用户界面元素
            pm.reqUserInfo(userInfo_url, userInfo_data);
        },

        /**
         * 请求用户信息
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqUserInfo : function(url, data) {
            var me = this;
            var reqParams = Trafficeye.httpData2Str(data);
            if (url) {
                Trafficeye.httpTip.opened(function() {
                    me.isStopReq = true;
                }, me);
                me.isStopReq = false;
                var reqUrl = url + reqParams;
                console.log(reqUrl);
                $.ajaxJSONP({
                    url : reqUrl,
                    success: function(data){
                        if (data && !me.isStopReq) {
                            me.reqUserInfoSuccess(data);
                        } else {
                            me.reqUserInfoFail();
                        }
                    }
                })
            }
        },
        /**
         * 返回上一页面
         */
        backPage : function() {
            Trafficeye.toPage("com_index.html");
        },
        /**
         * 请求用户信息成功后的处理函数
         * @param  {JSON Object} data
         */
        reqUserInfoSuccess : function(data) {
            var me = this,     
                praiseavatarlistidElem = me.elems["praiseavatarlistid"],
                praisecountElem = me.elems["praise_count_btn"],
                praiseviewidElem = me.elems["praiseviewid"],
                commentslistidElem = me.elems["commentslistid"];

                Trafficeye.httpTip.closed();
                //获取我的用户信息, by dongyl
                var myInfo = Trafficeye.getMyInfo();
                if (!myInfo) {
                    return;
                }

            if (data) {


                me.userInfoManager.setInfo(data);   
                me.userInfoManager.setUid(data.uid);       
               // if(data.uid != myInfo.uid){
                praisecountElem.css("display", "");
                //}     
                me.setMedia(data.media);
                me.setPraiseCount(data.praise_count);
                me.setUserAvater(data.avatar,data.uid);
               // console.log(data.avatar);
                me.setUserName(data.username);
                me.setTimeFromNow(data.time+"前");
                me.setContent(data.content);

                var commenthtml = me.CommentsInfoManager.getCommentsHtml(data.comments); 
                commentslistidElem.html(commenthtml);
                if(data.praiseList.length>0){
                    praiseviewidElem.css("display","");
                    var praiseavatorhtml = me.PraiseAvatorManager.getPraiseAvatorHtml(data.praiseList); 
                    praiseavatarlistidElem.html(praiseavatorhtml);
                }else{
                    praiseviewidElem.css("display","none");
                }
                
            }
        },

        /**
         * 查看评论者时间线
         * @param  {Int} uid
         */
        lookOtherTimeline : function(uid,evt) {
            var myInfo = Trafficeye.getMyInfo();
            if(myInfo.uid == 0){
                var content = encodeURI(encodeURI("请您登录后再操作"));
                Trafficeye.toPage("objc://showAlert::/"+content); 
            }else{
                var data = Trafficeye.offlineStore.get("traffic_timeline");
                    data = data + "," + uid;
                    Trafficeye.offlineStore.set("traffic_timeline", data);
                var elem = $(evt).addClass("curr");
                setTimeout((function(){
                    $(elem).removeClass("curr");  
                    Trafficeye.toPage("timeline.html");
                }),Trafficeye.MaskTimeOut);
            }
        },

        setUserName : function(username){
            var me = this;
            var usernameElem = me.elems["usernameid"];
            usernameElem.html(username);
        },

        setMedia : function(media){
            var me = this;
            var htmls = [];
            //<img id="media_id" src="images/iimg.jpg" alt="" width="320" height="134" />
            htmls.push("<img src = '" + media + "' width='300' height/>");
            var medidElem = me.elems["media_id"];
            medidElem.html(htmls.join(""));
        },

        setPraiseCount : function(praise_count){
            var me = this;
            var praise_countElem = me.elems["praise_count_btn"];
            praise_countElem.html(" 赞 "+praise_count);
        },

        setUserAvater : function(user_avater,uid){

            var me = this;
            var htmls = [];
            var avaterSrc = "";
            if (!user_avater) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = user_avater;
            }
            htmls.push("<div id=\"user_avater_id\" class=\"l-img\" onclick=\"gotoTimeline('" + uid + "',this);\"><p><img src = '" + avaterSrc + "' width='40' height='40' /></p></div>");
            var user_avaterElem = me.elems["user_avater_id"];
            user_avaterElem.html(htmls.join(""));
        },

        setTimeFromNow : function(timeid){
            var me = this;
            var timeidElem = me.elems["timeid"];
            timeidElem.html(timeid);
        },

        setContent : function(content){
            var me = this;
            var contentidElem = me.elems["contentid"];
            contentidElem.html(content);
        },
        /**
         * 请求用户信息失败后的处理函数
         */
        reqUserInfoFail : function() {

        },
        /**
         * 请求赞按钮失败后的处理函数
         */
        reqPraiseFail : function() {

        }
    };

    //基础URL
    var BASE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/user/timeLine/";
    var BASE_PRAISE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/";
    $(function(){
        //客户端本地调用接口 
        window.initPageManagerClient = function(publishId,width,height,uid,pid,source,publishType){
            //把来源信息存储到本地
             var fromSource = {"source" : source,"prepage" : "map_personaldetails.html"}
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
            //请求用户信息协议
            var userInfo_url = BASE_URL + "info";
            var userInfo_data = {"publishId" : publishId,"publishType" : publishType};
            
            var myInfo = {
                "uid" : uid || 0,
                "pid" : pid || 0
            };

            var dataStr = Trafficeye.json2Str(myInfo);
            Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
            var dataEvtdetail ={
                "uid" : uid,
                "publishid" : publishId
            };
            
            var dataEvtdetailStr = Trafficeye.json2Str(dataEvtdetail);
            Trafficeye.offlineStore.set("traffic_evtdetail", dataEvtdetailStr);

            var pm = new PageManager();
            Trafficeye.pageManager = pm;
            //初始化用户界面
            pm.init();
            pm.userInfoManager.setUid(uid);
            pm.userInfoManager.setPid(pid);
            pm.userInfoManager.setPublishType(publishType);
            //请求用户数据，填充用户界面元素
            pm.reqUserInfo(userInfo_url, userInfo_data);

            var sumbitbtnElem = pm.elems["inputbtn"];

            sumbitbtnElem.html("<div id = \"inputbtn\" onclick=\"sumbitbtnUp(this);\">提交</div>");
        };

        window.sumbitbtnUp = function(evt) {
             var pm = Trafficeye.pageManager;
           if (pm.init) {
                pm.sumbitbtnUp(evt);
            }
        };
        
        window.gotoTimeline = function(uid,evt) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                if(uid == 0){
                    var content = encodeURI(encodeURI("信息由未登录用户发布,无法查看他的动态."));
                    Trafficeye.toPage("objc://showAlert::/"+content); 
                }else{
                    pm.lookOtherTimeline(uid,evt);
                }
            }
        };
       //window.initPageManagerClient('25589',480,800,'38660','864589009055960');
       //window.initPageManagerClient(4827,320,480,35598,"39AF490E-9E02-4E06-92F5-6EA56A563FB8","track","track");
    }); 
    
 }(window));