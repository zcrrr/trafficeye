 (function(window) { //闭包
    

    function FriendsSina() {  
        //加载成功的用户的所有数据
        this.allFriendsSinaData = [];
        //用户最近一次加载的数据
        this.newFriendsSinaData = [];
    };

    FriendsSina.prototype = {//方法挂载在原型链
        setNewFriendsSinaData : function(data) {
            this.newFriendsSinaData = data;
        },
        mergeNewFriendsSinaData : function() {
            this.allFriendsSinaData.concat(this.newFriendsSinaData);
        },
        //已经是路况交通眼好友
        creatTrafficeyeListHtml : function(data) {
            var me = this;
            var htmls = [];
            
                if(data.relationship ==  1){
                  htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.trafficId + "',this);\">已关注</span>");
                }else if (data.relationship == 3){
                  htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.trafficId + "',this);\">互相关注</span>");
                }else if(data.relationship ==  2){
                  htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.trafficId + "',this);\">加关注</span>");
                }else if(data.relationship ==  0){
                  htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.trafficId + "',this);\">加关注</span>");
                }else if(data.relationship == 4){
                    htmls.push("<li>");
                }
            var avaterSrc = "";
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            htmls.push("<div class='h-img'><img src = '" + avaterSrc + "' alt='' width='40' height='40' /></div>");            
            htmls.push("<div class='h-text'>" + data.nick );
            htmls.push("</div></li>");
            return htmls.join("");
        },

        getTrafficeyeListHtml : function(friendsList) {
            var data = friendsList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatTrafficeyeListHtml(data[i]));
            }
            return htmls.join("");
        },
        //微博好友
        creatFriendsSinaListHtml : function(data) {
            var me = this;
            var htmls = ["<li id = 'inviteId' onclick=\"updateinvite('" + data.name + "','sinaweibo',this);\"><span class='add curr-'><s></s></span>"];
            var avaterSrc = "";
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }          
            htmls.push("<div class='h-img'><img src = '" + avaterSrc + "' alt='' width='40' height='40' /></div>");            
            htmls.push("<div class='h-text'>" + data.nick );
            htmls.push("</div></li>");
            return htmls.join("");
        },

        getFriendsListHtml : function(friendsList) {
            var data = friendsList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatFriendsSinaListHtml(data[i]));
            }
            return htmls.join("");
        }
    };

    function FriendsQQ() {  
        //加载成功的用户的所有数据
        this.allFriendsQQData = [];
        //用户最近一次加载的数据
        this.newFriendsQQData = [];
    };
    
    FriendsQQ.prototype = {//方法挂载在原型链
        setNewFriendsQQData : function(data) {
            this.newFriendsQQData = data;
        },
        mergeNewFriendsQQData : function() {
            this.allFriendsQQData.concat(this.newFriendsQQData);
        },
        //已经是路况交通眼好友
        creatTrafficeyeListHtml : function(data) {
            var me = this;
            var htmls = [];
            
                if(data.relationship ==  1){
                  htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.trafficId + "',this);\">已关注</span>");
                }else if (data.relationship == 3){
                  htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.trafficId + "',this);\">互相关注</span>");
                }else if(data.relationship ==  2){
                  htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.trafficId + "',this);\">加关注</span>");
                }else if(data.relationship ==  0){
                  htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.trafficId + "',this);\">加关注</span>");
                }else if(data.relationship == 4){
                    htmls.push("<li>");
                }
            var avaterSrc = "";
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            
            htmls.push("<div class='h-img'><img src = '" + avaterSrc + "' alt='' width='40' height='40' /></div>");
            
            htmls.push("<div class='h-text'>" + data.nick );
            htmls.push("</div></li>");
            return htmls.join("");
        },

        getTrafficeyeListHtml : function(friendsList) {
            var data = friendsList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatTrafficeyeListHtml(data[i]));
            }
            return htmls.join("");
        },
//微博好友
        
        creatFriendsQQListHtml : function(data) {
            var me = this;
            var htmls = ["<li id = 'inviteId' onclick=\"updateinvite('" + data.name + "','qqweibo',this);\"><span class='add curr-'><s></s></span>"];
            var avaterSrc = "";
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            htmls.push("<div class='h-img'><img src = '" + avaterSrc + "' alt='' width='40' height='40' /></div>");
            
            htmls.push("<div class='h-text'>" + data.nick );
            htmls.push("</div></li>");
            return htmls.join("");
        },

        getFriendsListHtml : function(friendsList) {
            var data = friendsList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatFriendsQQListHtml(data[i]));
            }
            return htmls.join("");
        }
    };
    function InviteUser() { 
    };
    InviteUser.prototype = {//方法挂载在原型链
        
         creatPraiseAvatorHtml : function(data) {
            var me = this;
            var htmls = [];
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            htmls.push("<img src = '" + avaterSrc + "' width='20' height='20' />");
            
            
            return htmls.join("");
        },

        getPraiseAvatorHtml : function(praiseavator) {
            var data = praiseavator;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatPraiseAvatorHtml(data[i]));
            }
            return htmls.join("");
        }
    };

    function PageManager() {
        //ID元素对象集合,关注列表、粉丝列表
        this.elems = {
            "sinabtn" : null,
            "qqbtn" : null,
            "trafficeyebtn" : null,
            "friendlist" : null,
            "backpagebtn" : null,
            "tf_listid" : null,
            "wf_listid" : null,
            "trafficeyefriendlist" : null,
            "billing" : null,
            "sendtext" : null,
            "billingtext" : null,
            "loadmorebtn" : null,
            "sendinvite" : null
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
            me.FriendsSina = new FriendsSina();
            me.FriendsQQ = new FriendsQQ();
            //me.FriendsTrafficeye = new FriendsTrafficeye();
            me.InviteUser = new InviteUser();
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
                sinabtnElem = me.elems["sinabtn"],
                qqbtnElem = me.elems["qqbtn"],
                trafficeyebtnElem = me.elems["trafficeyebtn"],
                backpagebtnElem = me.elems["backpagebtn"],
                billingbtnElem = me.elems["billing"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
            //点击新浪微博按钮
            sinabtnElem.onbind("touchend",me.sinabtnUp,me);
            //点击腾讯微博按钮
            qqbtnElem.onbind("touchend",me.qqbtnUp,me);
            //点击微信按钮
            trafficeyebtnElem.onbind("touchend",me.trafficeyebtnUp,me);
            //点击立即绑定按钮
            billingbtnElem.onbind("touchend",me.billingbtnUp,me);
           
        },
        /**
         * 按钮按下事件处理器
         * @param  {Event} evt
         */
        btnDown : function(evt) {
            this.addClass("curr");
        },
        /**
         * 选择新浪微博列表处理器
         * @param  {Event} evt
         */
        sinabtnUp : function(evt) {
            billingUserType = "sinaweibo"; 
            var me = this,
            sinabtnElem = me.elems["sinabtn"],
            tf_listidElem = me.elems["tf_listid"],
            wf_listidElem = me.elems["wf_listid"],
            qqbtnElem = me.elems["qqbtn"];
            $(sinabtnElem).addClass("curr");
            $(qqbtnElem).removeClass("curr");
            me.pageNumManager.reset();
            // me.elems["trafficeyefriendlist"].htmls.push("");
            // me.elems["friendlist"].htmls.push("");
            me.elems["trafficeyefriendlist"].html("");
            me.elems["friendlist"].html("");
            tf_listidElem.css("display","none");
           wf_listidElem.css("display","none");
            Trafficeye.httpTip.opened();
            if (Trafficeye.mobilePlatform.android) {
                window.invitation.getList('sinaweibo',0,50);
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc://lookupfriends::/0:/50:/sinaweibo");
            } else {
                alert("调用本地goPersonal方法,PC不支持.");
            }
        },
         backpagebtnUp : function(evt) {
            var me = this,
                elem = evt.currentTarget;
            $(elem).removeClass("curr");
           me.backPage();
        },

        updateinvite : function(name,userType,evt){
            var arr = evt.childNodes;
            var liElem = $(arr[0]);
            //alert(liElem.attr("f"));
            if (liElem.attr("f")==1) {
                //取消
                liElem.attr("f", 0);
                liElem.removeClass("curr");
                delete addInviteArr[name];
            } else{
                //添加
                liElem.attr("f", 1);
                liElem.addClass("curr");
                addInviteArr[name] = name;
                inviteUserType = userType;    
            }            
            //console.log(addInviteArr);
        },


        /**
         * 发送邀请
         * @param  {Number} uid     
         * @param  {Number} friendId
         */
        invitebtnUp : function(evt) {
            Trafficeye.httpTip.opened();
            var userData = "";
            var invitenum = 0,
                  me = this;
                for (var el in addInviteArr) {
                    userData = userData+"@";
                    userData = userData+addInviteArr[el];
                    invitenum++;
                }
               // console.log(addInviteArr);
                addInviteArr = {};
                me.pageNumManager.reset();
               // console.log(invitenum);
                if(invitenum>0){
                    if (Trafficeye.mobilePlatform.android) {
                        window.invitation.invation(inviteUserType,userData);
                    } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                        var content = encodeURI(encodeURI(userData));
                        Trafficeye.toPage("objc://invitation::/"+content+":/"+inviteUserType);
                    } else {
                        alert("调用本地invation方法,PC不支持.");
                    }
                }else{
                    Trafficeye.httpTip.closed();
                    var content = encodeURI(encodeURI("请先选择一个想要邀请的用户"));
                    Trafficeye.toPage("objc://showAlert::/"+content); 
                }
        },
        
        /**
         * 发送邀请
         * @param  {Number} uid     
         * @param  {Number} friendId
         */
        billingbtnUp : function(evt) {
            //alert(billingUserType);
            Trafficeye.httpTip.opened();
                   if (Trafficeye.mobilePlatform.android) {
                     window.invitation.binding(billingUserType);
                 } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                     Trafficeye.toPage("objc://bingdingStep1::/"+billingUserType);
                 } else {
                     alert("调用本地goPersonal方法,PC不支持.");
                 }
                 window.initPageManager(false);
        },
        /**
         * 选择腾讯微博列表处理器
         * @param  {Event} evt
         */
        qqbtnUp : function(evt) {
            var me = this,
            sinabtnElem = me.elems["sinabtn"],
            tf_listidElem = me.elems["tf_listid"],
            wf_listidElem = me.elems["wf_listid"],
            qqbtnElem = me.elems["qqbtn"];
            $(sinabtnElem).removeClass("curr");
            $(qqbtnElem).addClass("curr");
            billingUserType = "qqweibo"; 
            Trafficeye.httpTip.opened();
            me.pageNumManager.reset();
           // me.elems["trafficeyefriendlist"].htmls.push("");
           // me.elems["friendlist"].htmls.push("");
           me.elems["trafficeyefriendlist"].html("");
            me.elems["friendlist"].html("");
            tf_listidElem.css("display","none");
           wf_listidElem.css("display","none");
            if (Trafficeye.mobilePlatform.android) {
                window.invitation.getList('qqweibo',0,50);
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc://lookupfriends::/0:/50:/qqweibo");
            } else {
                alert("调用本地goPersonal方法,PC不支持.");
            }
        },
        /**
         * 选择交通眼好友列表处理器
         * @param  {Event} evt
         */
        trafficeyebtnUp : function(evt) {
 
            var pm = new PageManager();
             //初始化用户界面
            pm.init();
            Trafficeye.httpTip.opened();
            if (Trafficeye.mobilePlatform.android) {
                window.invitation.getList('trafficeye',0,10);
            } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                Trafficeye.toPage("objc://invitation");
            } else {
                alert("调用本地goPersonal方法,PC不支持.");
            }
        },    
        /**
         * 请求用户信息
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqUserInfo : function( data) {    
            var data = Trafficeye.str2Json(data);
            var me = this, 
                pageNumMger = me.pageNumManager, //判断是否加载更多
                sinabtnElem = me.elems["sinabtn"],
                qqbtnElem = me.elems["qqbtn"],
                trafficeyebtnElem = me.elems["trafficeyebtn"],
                trafficeyeuserlistidElem = me.elems["trafficeyefriendlist"],
                tf_listidElem = me.elems["tf_listid"],
                wf_listidElem = me.elems["wf_listid"],
                userlistidElem = me.elems["friendlist"];

            if(data.userType == "sinaweibo"){
                $(sinabtnElem).addClass("curr");
                $(qqbtnElem).removeClass("curr");
                $(trafficeyebtnElem).removeClass("curr");

                if (data) {
                    //当前结果集请求的结束位置
                    var currentEnd = pageNumMger.getWeiboEnd();
                    //更新下次请求分页起始位置
                    pageNumMger.start = currentEnd + 1;
                    //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
                    //if ((data.invationList1.length+data.invationList2.length) < pageNumMger.BASE_WEIBO_NUM) {
                    if(data.nextPage == -1){
                        pageNumMger.setIsShowBtn(false);
                    } else {
                        pageNumMger.setIsShowBtn(true);
                    }   
                    
                    if(data.invationList1.length>0){
                       // console.log(data.invationList1);
                        tf_listidElem.css("display", "");
                        trafficeyeuserlistidElem.show();
                        var trafficeyefriendhtml = me.FriendsSina.getTrafficeyeListHtml(data.invationList1);
                        if((pageNumMger.start/pageNumMger.BASE_WEIBO_NUM)==1){
                            trafficeyeuserlistidElem.html(trafficeyefriendhtml);
                        }else{
                            trafficeyeuserlistidElem.append(trafficeyefriendhtml);
                        }
                    }else if(trafficeyeuserlistidElem == null){
                        tf_listidElem.css("display", "none");
                        trafficeyeuserlistidElem.hide();
                    }
                    if(data.invationList2.length>0){
                        wf_listidElem.css("display", "");
                        userlistidElem.show();
                        var friendshtml = me.FriendsSina.getFriendsListHtml(data.invationList2); 
                        if((pageNumMger.start/pageNumMger.BASE_WEIBO_NUM)==1){
                            userlistidElem.html(friendshtml);
                        }else{
                            userlistidElem.append(friendshtml);
                        }
                    }else if(userlistidElem == null){
                        wf_listidElem.css("display", "none");
                        userlistidElem.hide();
                    }
                    if (pageNumMger.getIsShowBtn()) {
                        me.elems["loadmorebtn"].css("display", "");
                        me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp('sinaweibo')\";>加载更多</div>");
                    } else {
                        me.elems["loadmorebtn"].css("display", "none");
                    }
                } else {
                    me.reqFriendsInfoFail();
                }
            }else if(data.userType == "qqweibo"){
                $(sinabtnElem).removeClass("curr");
                $(qqbtnElem).addClass("curr");
                $(trafficeyebtnElem).removeClass("curr");

                if (data) {
                    //当前结果集请求的结束位置
                    var currentEnd = pageNumMger.getWeiboEnd();
                    //更新下次请求分页起始位置
                    pageNumMger.start = currentEnd + 1;
                    //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
                   // if ((data.invationList1.length+data.invationList2.length) < pageNumMger.BASE_WEIBO_NUM) {
                    if(data.nextPage == -1){
                        pageNumMger.setIsShowBtn(false);
                    } else {
                        pageNumMger.setIsShowBtn(true);
                    }   
                    if(data.invationList1.length>0){
                        tf_listidElem.css("display", "");
                        trafficeyeuserlistidElem.show();
                        var trafficeyefriendhtml = me.FriendsQQ.getTrafficeyeListHtml(data.invationList1);
                        if((pageNumMger.start/pageNumMger.BASE_WEIBO_NUM)==1){
                            trafficeyeuserlistidElem.html(trafficeyefriendhtml);
                        }else{
                            trafficeyeuserlistidElem.append(trafficeyefriendhtml);
                        }
                    }else if(trafficeyeuserlistidElem == null){
                        tf_listidElem.css("display", "none");
                        trafficeyeuserlistidElem.hide();
                    }
                    if(data.invationList2.length>0){
                        wf_listidElem.css("display", "");
                        userlistidElem.show();
                        var friendshtml = me.FriendsQQ.getFriendsListHtml(data.invationList2); 
                        if((pageNumMger.start/pageNumMger.BASE_WEIBO_NUM)==1){
                            userlistidElem.html(friendshtml);
                        }else{
                            userlistidElem.append(friendshtml);
                        }
                    }else if(userlistidElem == null){
                        wf_listidElem.css("display", "none");
                        userlistidElem.hide();
                    }
                    if (pageNumMger.getIsShowBtn()) {
                        me.elems["loadmorebtn"].css("display", "");
                        me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp('qqweibo')\";>加载更多</div>");
                    } else {
                        me.elems["loadmorebtn"].css("display", "none");
                    }
                } else {
                    me.reqFriendsInfoFail();
                }
            }else if(data.userType == "trafficeye"){
                $(sinabtnElem).removeClass("curr");
                $(qqbtnElem).removeClass("curr");
                $(trafficeyebtnElem).addClass("curr");

                if (data) {
                   var friendshtml = me.FriendsTrafficeye.getFriendsListHtml(data.invationList1); 
                        userlistidElem.html(friendshtml);
                } else {
                    me.reqFriendsInfoFail();
                }
            }
        },  
        /**
         * 返回上一页面
         */
        backPage : function() {
            Trafficeye.toPage("lookfans.html");
        },      
        /**
         * 请求关注信息失败后的处理函数
         */
        reqFriendsInfoFail : function() {

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
                            me.reqCancelLookSuccess(data,friendId,evt);
                        } else {
                            me.reqCancelLookFail();
                        }
                    }
                })
            }
        },
        reqCancelLookSuccess : function(data,friendid,evt) {    
        Trafficeye.httpTip.closed();        
                if (data && data.code == 0) {    
                   evt.textContent = "加关注";    
                   evt.setAttribute("onclick","addLook('"+friendid+"',this)");
                }else{
                    var content = encodeURI(encodeURI(data.desc));
                    Trafficeye.toPage("objc://showAlert::/"+content); 
                }            
        },
        reqCancelLookFail : function() {

        },

        /**
         * 加关注按钮处理函数
         */
        addLook : function(uid,evt) {
            var me = this;   
            var myInfo = Trafficeye.getMyInfo();
            me.reqAddLook(myInfo.uid, uid, myInfo.pid,evt);
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
                            me.reqAddLookSuccess(data,friendId,evt);                             
                        } else {
                             me.reqAddLookFail();
                        }
                    }
                })
            }
        },
        reqAddLookSuccess : function(data,friendid,evt) {
            Trafficeye.httpTip.closed();
            if (data && data.code == 0) { 
               if(data.friendShip == 1){
                    evt.textContent = "已关注";
                    evt.setAttribute("onclick","cancelLook('"+friendid+"',this)");
                }else if(data.friendShip == 3){
                    evt.textContent = "相互关注";
                    evt.setAttribute("onclick","cancelLook('"+friendid+"',this)");
                }
            }else{
                var content = encodeURI(encodeURI(data.desc));
                    Trafficeye.toPage("objc://showAlert::/"+content); 
            }
        },
        
        loadmorebtnUp : function(flag) {
            var me = this;
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }
            var uid = myInfo.uid;
            if (uid) {
                me.loadmoreHander(flag);
            }
        },
        
        /**
         * 加载更多数据处理函数,当flag为sina的时候是新浪微博，qq是腾讯微博
         */
        loadmoreHander : function(flag) {
            var me = this;
            var start = me.pageNumManager.getStart();
            var count = me.pageNumManager.BASE_WEIBO_NUM;
            var page = start/count;
            if(flag == "sinaweibo"){
                if (Trafficeye.mobilePlatform.android) {
                    window.invitation.getList('sinaweibo',page,count);
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc://lookupfriends::/"+page+":/"+count+":/sinaweibo");
                } else {
                    alert("调用本地goPersonal方法,PC不支持.");
                }
            }else if(flag == "qqweibo"){   
                if (Trafficeye.mobilePlatform.android) {
                    window.invitation.getList('qqweibo',page,count);
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc://lookupfriends::/"+page+":/"+count+":/qqweibo");
                } else {
                    alert("调用本地goPersonal方法,PC不支持.");
                }
            }
        },
        reqAddLookFail : function() {

        }
    };
    var BASE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/friendships/";
    var addInviteArr = {}; //邀请好友时候，邀请人员的数组
    var inviteUserType = "sinaweibo"; //邀请好友的时候判断类型,qqweibo,all
    var billingUserType = "sinaweibo"; 
    var flag = true;
    $(function(){
        // flag 为 true的时候是获取列表，如果为false，那么就是在绑定微博的过程中
        window.initPageManager = function(flag) {

            Trafficeye.httpTip.opened();

            var myInfo = Trafficeye.getMyInfo();
            // if (!myInfo) {
            //     return;
            // }
            
            var pm = new PageManager();
            //初始化用户界面
            pm.init();
            //onsole.log(pm);
            Trafficeye.pageManager = pm;
            pm.myInfo = myInfo;
            if(flag){
                if (Trafficeye.mobilePlatform.android) {
                    window.invitation.getList('all',0,50);
                    //  Trafficeye.toPage("invite.html");
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc://lookupfriends::/0:/50:/all");
                    //   Trafficeye.toPage("invite.html");
                } else {            
                    alert("调用邀请.");
                }  
            }else{

            }
        };
/**
         * 请求用户列表信息
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
         window.initparm = function(data) {
             //console.log(data);
            Trafficeye.httpTip.closed();
            var dataStr = Trafficeye.str2Json(data);
            
            //pm = Trafficeye.pageManager;
            var pm = Trafficeye.pageManager;
            
            var sinabtnElem = pm.elems["sinabtn"],
            qqbtnElem = pm.elems["qqbtn"],
            tflistidElem = pm.elems["tf_listid"],
            wflistidElem = pm.elems["wf_listid"],
            trafficeyefriendlistElem = pm.elems["trafficeyefriendlist"],
            friendlistElem = pm.elems["friendlist"],
            bindingillingbtnElem = pm.elems["billing"],
            sendtextElem = pm.elems["sendtext"],
            billingtextElem = pm.elems["billingtext"],
            loadmorebtnElem = pm.elems["loadmorebtn"];
            sendinvitebtnElem = pm.elems["sendinvite"];
            $(sinabtnElem).addClass("curr");
            $(qqbtnElem).removeClass("curr");
           loadmorebtnElem.css("display","none");
            //console.log(dataStr);
            if(dataStr.state.code == 0){
               // sendinvitebtnElem.show();
                sendinvitebtnElem.css("display", "");
                sendinvitebtnElem.html("<li id = \"sendinvite\" onclick=\"invitebtnUp(this);\"><a>邀请好友</a></li>");
                bindingillingbtnElem.css("display", "none");
                sendtextElem.css("display", "");
                billingtextElem.css("display", "none");
                pm.reqUserInfo(data);
            }else if(dataStr.state.code == -1){
                
                //pm.init();
                bindingillingbtnElem.css("display", "");
                sendtextElem.css("display", "none");
                billingtextElem.css("display", "");
                sendinvitebtnElem.css("display", "none");
                tflistidElem.css("display", "none");
                wflistidElem.css("display", "none");
                trafficeyefriendlistElem.hide();
                friendlistElem.hide();
                if(dataStr.userType == 'sinaweibo'){
                    $(sinabtnElem).addClass("curr");
                    $(qqbtnElem).removeClass("curr");
                    billingtextElem.html("绑定新浪微博帐号，邀请更多好友。");
                }else if(dataStr.userType == 'qqweibo'){
                    $(sinabtnElem).removeClass("curr");
                    $(qqbtnElem).addClass("curr");
                    billingtextElem.html("绑定腾讯微博帐号，邀请更多好友。");
                }
            }else{
                    var content = encodeURI(encodeURI("缓存过期,获取列表失败"));
                    Trafficeye.toPage("objc://showAlert::/"+content); 
                    bindingillingbtnElem.css("display", "");
                    sendtextElem.css("display", "none");
                    billingtextElem.css("display", "");
                    sendinvitebtnElem.css("display", "none");
                    tflistidElem.css("display", "none");
                    wflistidElem.css("display", "none");
                    trafficeyefriendlistElem.hide();
                    friendlistElem.hide();
                    if(dataStr.userType == 'sinaweibo'){
                        $(sinabtnElem).addClass("curr");
                        $(qqbtnElem).removeClass("curr");
                        billingtextElem.html("绑定新浪微博帐号，邀请更多好友。");
                    }else if(dataStr.userType == 'qqweibo'){
                        $(sinabtnElem).removeClass("curr");
                        $(qqbtnElem).addClass("curr");
                        billingtextElem.html("绑定腾讯微博帐号，邀请更多好友。");
                }
            }
        };

        window.inviteResult = function(data){            
            var dataStr = Trafficeye.str2Json(data);
            if(dataStr.code == 0){
                
                var content = encodeURI(encodeURI("邀请成功"));
                window.location.href="objc://showAlert::/"+content;

                 if (Trafficeye.mobilePlatform.android) {
                    window.invitation.getList(inviteUserType,0,50);
                    //  Trafficeye.toPage("invite.html");
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc://lookupfriends::/0:/50:/"+inviteUserType);
                    //   Trafficeye.toPage("invite.html");
                } else {            
                    alert("调用邀请.");
                } 
            }else{     
            Trafficeye.httpTip.closed();           
                var content = encodeURI(encodeURI("邀请失败"));
                    Trafficeye.toPage("objc://showAlert::/"+content); 
            }
        };

        window.updateinvite = function(uid,userType,evt) {
             var pm = Trafficeye.pageManager;
           if (pm.init) {
                pm.updateinvite(uid,userType,evt);
            }
        };

        window.invitebtnUp = function(evt) {
             var pm = Trafficeye.pageManager;
           if (pm.init) {
                pm.invitebtnUp(evt);
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

        window.cancelLook = function(uid,evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.cancelLook(uid,evt);
            }
        };
        //falg 为 sina,qq或其他
        window.loadmorebtnUp = function(flag) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loadmorebtnUp(flag);
            }
        };
        
        window.initPageManager(flag);
    });
    
 }(window));