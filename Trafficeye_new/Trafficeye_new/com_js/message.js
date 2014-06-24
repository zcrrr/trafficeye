 (function(window) { //闭包
    function UserInfoManager() {
        this.uid = null;
        this.friend_id = null;
    };
    UserInfoManager.prototype = {
        setUid : function(uid) {
            this.uid = uid;
        },
        setFriendid : function(friend_id) {
            this.friend_id = friend_id;
        }
    };

    function UserMessages() {  
        //加载成功的用户的所有数据
        this.allUserMessagesData = [];
        //用户最近一次加载的数据
        this.newUserMessagesData = [];
        //关联用户信息管理器
        this.userInfoManager = null;
    };
    UserMessages.prototype = {//方法挂载在原型链
        setNewUserMessagesData : function(data) {
            this.newUserMessagesData = data;
        },
        mergeNewUserMessagesData : function() {
            this.allUserMessagesData.concat(this.newUserMessagesData);
        },
        setUserInfoManager : function(manger) {
            this.userInfoManager = manger;
        },
        
        creatMessagesListHtml : function(data) {
            
            var me = this;
            var htmls = [];
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            //判断点击进入的类型
            if(data.messageType == "event"){
                if(data.media_small){//显示事件缩略图
                    htmls.push("<li><div class='r-img' onclick=\"gotoEvent('"+data.uid+"','"+data.message_id+"');\"><img src='" + data.media_small + "' alt='' width='40' height='40' /></div>");
                }
                htmls.push("<li><div class='h-img' onclick=\"gotoEvent('"+data.uid+"','"+data.message_id+"');\"><img src='" + avaterSrc + "' alt='' width='40' height='40' /></div>");
                htmls.push("<div class='h-text xt' onclick=\"gotoEvent('"+data.uid+"','"+data.message_id+"');\"><h3>" + data.username + "</h3>"+data.message+"</div>");
            }else if(data.messageType == "message"){
                htmls.push("<li><div class='h-img' onclick=\"gotoChat("+data.uid+");\"><img src='" + avaterSrc + "' alt='' width='40' height='40' /></div>");
                htmls.push("<div class='h-text xt' onclick=\"gotoChat("+data.uid+");\"><h3>" + data.username + "</h3>"+data.message+"</div>");
            }else if(data.messageType == "fans"){
                htmls.push("<li><div class='h-img' onclick=\"gotoLookfans();\"><img src='" + avaterSrc + "' alt='' width='40' height='40' /></div>");
                htmls.push("<div class='h-text xt' onclick=\"gotoLookfans();\"><h3>" + data.username + "</h3>"+data.message+"</div>");
             }

            htmls.push("</li>");
            return htmls.join("");
        },

        getMessagesListHtml : function(messagesList) {
            var data = messagesList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatMessagesListHtml(data[i]));
            }
            return htmls.join("");
        }
    };

    function UserLetters() { 
        this.allUserLettersData = [];
        //用户最近一次加载的数据
        this.newUserLettersData = [];
        //关联用户信息管理器
        this.userInfoManager = null;
    };
    UserLetters.prototype = {//方法挂载在原型链

        setUserInfoManager : function(manger) {
            this.userInfoManager = manger;
        },
        setNewUserLettersData : function(data) {
            this.newUserLettersData = data;
        },
        mergeNewUserLettersData : function() {
            this.allUserLettersData.concat(this.newUserLettersData);
        },
        
         creatLettersHtml : function(data) {
            var me = this;
            //var htmls = ["<li><div class='r-img'><img src='" + data.avatar + "' alt='' width='40' height='40' /></div>"];
            var htmls = [];
            var avaterSrc = "";
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            htmls.push("<li><div class='h-img' onclick=\"gotoChat("+data.friend_id+");\"><img src='" + avaterSrc + "' alt='' width='40' height='40' /></div>");
            
            htmls.push("<div class='h-text xt' onclick=\"gotoChat("+data.friend_id+");\"><h3>" + data.username + "</h3>"+data.time+"前</div>");
            htmls.push("</li>");
            return htmls.join("");
        },

        getLettersHtml : function(praiseavator) {
            var data = praiseavator;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatLettersHtml(data[i]));
            }
            return htmls.join("");
        }
    };

    function PageManager() {
        //ID元素对象集合,关注列表、粉丝列表
        this.elems = {
            "message" : null,
            "letter" : null,
            "refreshbtn" : null,
            "backpagebtn" : null,
            "loadmorebtn" : null,
            "messagelist" : null
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
            me.UserMessages = new UserMessages();
            me.UserLetters = new UserLetters();          
            me.UserMessages.setUserInfoManager(me.userInfoManager);
            me.UserLetters.setUserInfoManager(me.userInfoManager);
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
                messagelistbtnElem = me.elems["message"],
                letterlistbtnElem = me.elems["letter"],
                backpagebtnElem = me.elems["backpagebtn"],
                refreshbtnElem = me.elems["refreshbtn"],
                messagelist = me.elems["messagelist"];

            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            //点击消息按钮
            messagelistbtnElem.onbind("touchend",me.messagebtnUp,me);
            //点击私信按钮
            letterlistbtnElem.onbind("touchend",me.letterbtnUp,me);
            //刷新按钮
            refreshbtnElem.onbind("touchstart",me.btnDown,refreshbtnElem);
            refreshbtnElem.onbind("touchend",me.refreshbtnUp,me);           
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
        gotoChat : function(friend_id,evt) {  
            $(evt).addClass("curr");
            var myInfo = Trafficeye.getMyInfo();
            // var pm = Trafficeye.pageManager ;    
            var chatData = {
                "uid" : myInfo.uid,
                "friend_id" : friend_id
            };            
            var chatDataStr = Trafficeye.json2Str(chatData);
            Trafficeye.offlineStore.set("traffic_chat", chatDataStr); 
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("chat_message.html");
            }),Trafficeye.MaskTimeOut);
        },
        /**
         * 选择消息列表处理器
         * @param  {Event} evt
         */
        messagebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            me.pageNumManager.reset();
            var messagesInfo_url = BASE_URL + "message/find";
            var messagesInfo_data = {"uid" : me.userInfoManager.uid,
            "page" : 0,
            "count" : 10
            }; 
            me.reqMessagesInfo(messagesInfo_url, messagesInfo_data);
        },
        
         refreshbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
            me.pageNumManager.reset();
            var messagesInfo_url = BASE_URL + "message/find";
            var messagesInfo_data = {"uid" : me.userInfoManager.uid,
            "page" : 0,
            "count" : 10
            }; 
            me.reqMessagesInfo(messagesInfo_url, messagesInfo_data);
        },
        /**
         * 选择私信列表处理器
         * @param {Event} evt
         */
        letterbtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget,
                elem1 = me.elems["message"];
            $(elem).addClass("curr");
            $(elem1).removeClass("curr");
            me.pageNumManager.reset();

            var letterInfo_url = BASE_URL + "letter/findList";
     
            var letterInfo_data = {"uid" : me.userInfoManager.uid}; 

            var letterInfo_data = 
                {"uid" : me.userInfoManager.uid,
                 "friend_id" : me.userInfoManager.friend_id,
                 "page" : 0,
                 "count" : 10
                }; 
            me.reqLettersInfo(letterInfo_url, letterInfo_data);
        },
        /**
         * 点击查看所有评论处理函数
         */
        lookAllCommentbtnUp : function(uid,publishId,evt) {
            $(evt).addClass("curr");
            var publishid = publishId;
            var data = {"uid" : uid,"publishid" : publishId};
            var dataStr = Trafficeye.json2Str(data);
            Trafficeye.offlineStore.set("traffic_evtdetail", dataStr);
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("personaldetails.html");
            }),Trafficeye.MaskTimeOut);
        },
        

        /**
         * 请求消息列表
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqMessagesInfo : function(url, data) {
            var me = this, 
                messageslistbtnElem = me.elems["message"],
                letterlistbtnElem = me.elems["letter"];
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
                           $(messageslistbtnElem).addClass("curr");
                           $(letterlistbtnElem).removeClass("curr");
                
                            me.reqMessagesInfoSuccess(data);
                        } else {
                            me.reqMessagesInfoFail();
                        }
                    }
                })
            }
        },
        /**
         * 请求消息信息成功后的处理函数
         * @param  {JSON Object} data
         */
        reqMessagesInfoSuccess : function(data) {
            var me = this,     
                pageNumMger = me.pageNumManager, //判断是否加载更多
                messagelistidElem = me.elems["messagelist"];
            
            Trafficeye.httpTip.closed();
            
            if (data) {              
                //当前结果集请求的结束位置
                var currentEnd = pageNumMger.getEnd();
                //更新下次请求分页起始位置
                pageNumMger.start = currentEnd + 1;
                //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
                // if (data.messages.length < pageNumMger.BASE_NUM) {
                    if(data.nextPage == -1){
                    pageNumMger.setIsShowBtn(false);
                } else {
                    pageNumMger.setIsShowBtn(true);
                }   
                me.UserMessages.setNewUserMessagesData(data.friends);
                var messageshtml = me.UserMessages.getMessagesListHtml(data.messages); 
                me.UserMessages.mergeNewUserMessagesData();
                if((pageNumMger.start/pageNumMger.BASE_NUM)==1){
                    messagelistidElem.html(messageshtml);
                }else{
                    messagelistidElem.append(messageshtml);
                }
                    //判断是否显示加载更多按钮
                if (pageNumMger.getIsShowBtn()) {
                    me.elems["loadmorebtn"].css("display", "");
                    me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp(this,true)\";>加载更多</div>");
                } else {
                    me.elems["loadmorebtn"].css("display", "none");
                }
            }
        },

        //选择粉丝处理方法
        gotoLookfans : function(evt) {
            Trafficeye.offlineStore.set("traffic_lookfans", "fans");
            $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                Trafficeye.toPage("lookfans.html");
            }),Trafficeye.MaskTimeOut);
        },
         /**
         * 请求私信列表
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqLettersInfo : function(url, data) {
            var me = this,
               messageslistbtnElem = me.elems["message"],
               letterlistbtnElem = me.elems["letter"];

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
                           $(messageslistbtnElem).removeClass("curr");
                           $(letterlistbtnElem).addClass("curr");
                            me.reqLettersInfoSuccess(data);
                        } else {
                            me.reqlettersInfoFail();
                        }
                    }
                })
            }
        },
        /**
         * 请求私信用户信息成功后的处理函数
         * @param  {JSON Object} data
         */
        reqLettersInfoSuccess : function(data) {
            var me = this,     
                pageNumMger = me.pageNumManager, //判断是否加载更多
                letterslistidElem = me.elems["messagelist"];
                Trafficeye.httpTip.closed();

            if (data) {              
                //当前结果集请求的结束位置
                var currentEnd = pageNumMger.getEnd();
                //更新下次请求分页起始位置
                pageNumMger.start = currentEnd + 1;
                //////////////////
                //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
                if (data.letters.length < pageNumMger.BASE_NUM) {
                    pageNumMger.setIsShowBtn(false);
                } else {
                    pageNumMger.setIsShowBtn(true);
                }   
                me.UserLetters.setNewUserLettersData(data.friends);
                var lettershtml = me.UserLetters.getLettersHtml(data.letters); 
                me.UserLetters.mergeNewUserLettersData();
                // if((pageNumMger.start/pageNumMger.BASE_NUM)==1){
                if(data.nextPage == -1){
                    letterslistidElem.html(lettershtml);
                }else{
                    letterslistidElem.append(lettershtml);
                }
                    //判断是否显示加载更多按钮
                if (pageNumMger.getIsShowBtn()) {
                    me.elems["loadmorebtn"].css("display", "");
                    me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp(this,false)\";>加载更多</div>");
                } else {
                    me.elems["loadmorebtn"].css("display", "none");
                }
            }
        },
        reqLoadNo : function() {
            var me = this;
            Trafficeye.httpTip.closed();
            me.elems["loadmorebtn"].css("display", "none");
        },
        loadmorebtnUp : function(evt,flag) {
            var me = this,
                elem = evt.currentTarget;
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }
            $(elem).removeClass("bblue");
            var uid = myInfo.uid;
            if (uid) {
                me.loadmoreHander(uid,flag);
            }
        },
        
        /**
         * 加载更多数据处理函数,当flag为true的时候是消息，如果是false，是私信界面
         */
        loadmoreHander : function(uid,flag) {
            var me = this;
            if (uid) {
                var userData = {};
                userData.uid = uid;
                userData.friend_id = me.userInfoManager.friend_id;
                userData.page = me.pageNumManager.getStart()/me.pageNumManager.BASE_NUM;
                userData.count = me.pageNumManager.BASE_NUM;
                
                if(flag){
                     //请求用户信息协议
                    var messageInfo_url = BASE_URL + "message/find";
                    //  var followersInfo_url = BASE_URL + "followers";
                    var messageInfo_data = userData;               
                    //请求用户数据，填充用户界面元素
                    me.reqMessagesInfo(messageInfo_url, messageInfo_data);
                }else{   
                    var letterInfo_url = BASE_URL + "letter/findList";         
                    var letterInfo_data = userData; 
                    me.reqLettersInfo(letterInfo_url, letterInfo_data);
                }
            }
        },
        /**
         * 请求消息信息失败后的处理函数
         */
        reqMessagesInfoFail : function() {

        },
        /**
         * 请求私信信息失败后的处理函数
         */
        reqlettersInfoFail : function() {

        }
    };

    //基础URL
    var BASE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/";
    $(function(){
        //flag 为true 的时候是消息, 为false的时候是私信
        window.initPageManager = function(uid,friend_id,start,count,flag,pid,source){
            //把来源信息存储到本地
             var fromSource = {"source" : source,"prepage" : "message.html"}
             var fromSourceStr = Trafficeye.json2Str(fromSource);
             Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
            
            var pm = new PageManager();

            Trafficeye.pageManager = pm;
            //初始化用户界面
            pm.init();

            pm.userInfoManager.setUid(uid);
            pm.userInfoManager.setFriendid(friend_id);

            //把个人信息增加到本地缓存
             var userData = {"uid" : uid,"pid" : pid}
             var dataStr = Trafficeye.json2Str(userData);
                //console.log(dataStr);
             Trafficeye.offlineStore.set("traffic_myinfo", dataStr);

            if(flag){
                 //请求用户信息协议
                var messageInfo_url = BASE_URL + "message/find";
                //  var followersInfo_url = BASE_URL + "followers";
                var messageInfo_data = {"uid" : uid,
                "page" : 0,
                "count" : 10
                };               
                //请求用户数据，填充用户界面元素
                pm.reqMessagesInfo(messageInfo_url, messageInfo_data);
            }else{   
                var letterInfo_url = BASE_URL + "letter/findList";         
                var letterInfo_data = 
                {"uid" : uid,
                 "friend_id" : friend_id,
                 "page" : start,
                 "count" : count
                }; 
                pm.reqLettersInfo(letterInfo_url, letterInfo_data);
            }
            var chatData = {
                "uid" : uid,
                "friend_id" : friend_id
            };
            
            var chatDataStr = Trafficeye.json2Str(chatData);

            Trafficeye.offlineStore.set("traffic_chat", chatDataStr);           
        }
            //存储跳转到消息关注页面需要的数据
        
        //flag 为true 的时候是消息, 为false的时候是私信
        //window.initPageManager(22439,22439,0,10,false);

        window.gotoChat = function(friend_id,evt){
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.gotoChat(friend_id,evt);
            }
        };

        window.gotoEvent = function(uid,publishId,evt) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.lookAllCommentbtnUp(uid,publishId,evt);
            }
        };

        window.gotoLookfans = function(evt) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.gotoLookfans(evt);
            }
        };
        
        window.loadmorebtnUp = function(evt,flag) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loadmorebtnUp(evt,flag);
            }
        };
        
       //window.initPageManager(30508,30508,0,10,true,'a1000033e99ec40');
       // window.initPageManager(3862,3862,0,10,true,'1CF4A942-04BC-4579-832A-CB27F6BBF206');
    //    window.initPageManager(39062,39062,0,10,true,'8E9BF58F-C799-467C-AD78-0C625AB0B9F7');

    }); 
    
 }(window));