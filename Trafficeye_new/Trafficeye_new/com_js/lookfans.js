 (function(window) { //闭包
    
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

    function UserFriends() {  
        //加载成功的用户的所有数据
        this.allUserFriendsData = [];
        //用户最近一次加载的数据
        this.newUserFriendsData = [];
        //关联用户信息管理器
        this.userInfoManager = null;
    };
    UserFriends.prototype = {//方法挂载在原型链       
        setUserInfoManager : function(manger) {
            this.userInfoManager = manger;
        }, 
        setNewUserFriendsData : function(data) {
            this.newUserFriendsData = data;
        },
        mergeNewUserFriendsData : function() {
            this.allUserFriendsData.concat(this.newUserFriendsData);
        },
        /**
         * @param  {Boolean} flag flag为true时，生成关注列表，false，生成粉丝列表
         */
        creatFriendsListHtml : function(data, flag) {
            var me = this;
            var htmls = [];
            if (flag) {
                if(data.friendShip ==  1){
                  htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.uid + "',this);\">已关注</span>");
                }else if (data.friendShip == 3){
                  htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.uid + "',this);\">互相关注</span>");
                }else if(data.friendShip == 4){
                    htmls.push("<li>");
                }
            } else {
                if(data.friendShip ==  2){
                  htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.uid + "',this);\">加关注</span>");
                }else if (data.friendShip == 3){
                  htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.uid + "',this);\">互相关注</span>");
                }else if(data.friendShip == 4){
                    htmls.push("<li>");
                }
            }
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            htmls.push("<div class='h-img' onclick=\"gotoTimeline('" + data.uid + "',this);\"><img src = '" + avaterSrc + "' alt='' width='40' height='40' /></div>");
            htmls.push("<div class='h-text' onclick=\"gotoTimeline('" + data.uid + "',this);\">" + data.name );
            htmls.push("</div></li>");
            return htmls.join("");
        },
        //关注、粉丝页面的html输出
        getFriendsListHtml : function(friendsList, flag) {
            var data = friendsList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatFriendsListHtml(data[i], flag));
            }
            return htmls.join("");
        }
    };

    function SearchUser() {  
        //加载成功的用户的所有数据
        this.allSearchUserData = [];
        //用户最近一次加载的数据
        this.newSearchUserData = [];
        //关联用户信息管理器
        this.userInfoManager = null;
    };
    SearchUser.prototype = {//方法挂载在原型链
        setUserInfoManager : function(manger) {
            this.userInfoManager = manger;
        }, 
        setNewSearchUserData : function(data) {
            this.newSearchUserData = data;
        },
        mergeNewSearchUserData : function() {
            this.allSearchUserData.concat(this.newSearchUserData);
        },
        /**
         * @param  {Boolean} flag flag为true时，生成关注列表，false，生成粉丝列表
         */
        creatUsersListHtml : function(data) {
            var me = this;
            var htmls = [];
            if (data.friendShip == 0) {
                htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.uid + "',this);\">加关注</span>");
            } else if(data.friendShip == 1) {
                htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.uid + "',this);\">取消关注</span>");
            }else if(data.friendShip == 2) {
                htmls.push("<li><span class='g-cancel' onclick=\"addLook('" + data.uid + "',this);\">加关注</span>");
            }else if(data.friendShip == 3) {
                htmls.push("<li><span class='g-cancel' onclick=\"cancelLook('" + data.uid + "',this);\">互相关注</span>");
            }else if(data.friendShip == 4){
                htmls.push("<li>");
            }
            if (!data.avatar) {
                avaterSrc = "com_images/default.png";
            } else {
                avaterSrc = data.avatar;
            }
            htmls.push("<div class='h-img' onclick=\"gotoTimeline('" + data.uid + "',this);\"><img src = '" + avaterSrc + "' alt='' width='40' height='40' /></div>");
            htmls.push("<div class='h-text' onclick=\"gotoTimeline('" + data.uid + "',this);\">" + data.name );
            htmls.push("</div></li>");
            return htmls.join("");
        },

        getUsersListHtml : function(friendsList) {
            var data = friendsList;
            var htmls = [];
            for (var i = 0, len = data.length; i < len; i++) {
                htmls.push(this.creatUsersListHtml(data[i]));
            }
            return htmls.join("");
        }
    };

    function PageManager() {
        //ID元素对象集合,关注列表、粉丝列表
        this.elems = {
            "lookbtn" : null,
            "fansbtn" : null,
            "listtotal" : null,
            "userlist" : null,
            "detailbtn" : null,
            "headerimg" : null,
            "headername" : null,
            "invitebtn" : null,
            "inputsearch" : null,
            "inputbtn" : null,
            "lookfanstab" : null,
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
            me.pageNumManager = new Trafficeye.PageNumManager();
            me.userInfoManager = new UserInfoManager();
            me.UserFriends = new UserFriends();
            me.UserFriends.setUserInfoManager(me.userInfoManager);
            me.SearchUser = new SearchUser();
            me.SearchUser.setUserInfoManager(me.userInfoManager);
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
                looklistbtnElem = me.elems["lookbtn"],
                fanslistbtnElem = me.elems["fansbtn"],
                detailbtnElem = me.elems["detailbtn"],
                sumbitbtnElem = me.elems["inputbtn"],
                loadmorebtnElem = me.elems["loadmorebtn"],
                invitebtnElem = me.elems["invitebtn"];

            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me); 
            //点击关注按钮
            looklistbtnElem.onbind("touchend",me.lookbtnUp,me);
            //点击粉丝按钮
            fanslistbtnElem.onbind("touchend",me.fansbtnUp,me);
            //点击详情按钮
            detailbtnElem.onbind("touchstart",me.btnDown,detailbtnElem);
            detailbtnElem.onbind("touchend",me.detailbtnUp,me);
            //邀请好友按钮
            invitebtnElem.onbind("touchend",me.invitebtnUp,me);
            //隐藏加载更多按钮
            loadmorebtnElem.css("display" , "none");
            //搜索好友按钮
            sumbitbtnElem.onbind("touchstart",me.btnDown,sumbitbtnElem);
            sumbitbtnElem.onbind("touchend",me.sumbitbtnUp,me);
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
            // Trafficeye.toPage("com_index.html");
            var fromSource = Trafficeye.offlineStore.get("traffic_fromsource");
            // alert(fromSource);÷
            // console.log(fromSource);
            if(fromSource == "trafficeye_personal"){
            // 
                // alert("b");
                if (Trafficeye.mobilePlatform.android) {
                    window.init.finish();
                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                    Trafficeye.toPage("objc://closeSelf");
                } else {
                    alert("调用本地goPersonal方法,PC不支持.");
                }
            }else{
                Trafficeye.toPage("com_index.html");
            }
        },
         /**
         * 邀请好友界面
         * @param  {Event} evt
         */
        invitebtnUp : function(evt) {
            Trafficeye.toPage("invite.html");      
        },
        /**
         * 选择关注列表处理器
         * @param  {Event} evt
         */
        lookbtnUp : function(evt) {
            var me = this,
                elem = me.elems["lookbtn"],
                elem1 = me.elems["fansbtn"];
            elem.addClass("curr");
            elem1.removeClass("curr");
            me.pageNumManager.reset();
           //如果没有拿到uid，就不做请求处理，by dongyl
            var uid = me.myInfo.uid;
            if (uid) {
                // me.pageNumManager.reset();
                var friendsInfo_url = BASE_URL + "friends";
                var friendsInfo_data = {"uid" : uid,"friend_id" : uid}; 
                me.reqFriendsInfo(friendsInfo_url, friendsInfo_data);
            }
        },
        /**
         * 选择粉丝列表处理器
         * @param {Event} evt
         */
        fansbtnUp : function(evt) {
            var me = this,
                elem = me.elems["lookbtn"],
                elem1 = me.elems["fansbtn"];
            elem1.addClass("curr");
            elem.removeClass("curr");
            me.pageNumManager.reset();
            //如果没有拿到uid，就不做请求处理，by dongyl
            var uid = me.myInfo.uid;
            if (uid) {
                // me.pageNumManager.reset();
                var followersInfo_url = BASE_URL + "followers";
                var followerssInfo_data = {"uid" : uid,"friend_id" : uid}; 
                me.reqfollowersInfo(followersInfo_url, followerssInfo_data);
            }
        },
        /**
         * 搜索用户按钮函数
         */
        sumbitbtnUp : function(evt) {
            var me = this,
            elem = evt.currentTarget;
            $(elem).removeClass("curr");
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }
          
            var uid = myInfo.uid;

            var textContent = me.elems["inputsearch"].attr("value");
            if(textContent){
                me.pageNumManager.reset();
                var sumbitBtnUp_url = BASE_SEARCH_URL + "searchUser";
                var sumbitBtnUp_data = {"uid" : uid,"nickName" : textContent};
                me.reqSumbitbut(sumbitBtnUp_url, sumbitBtnUp_data);
            }else{
                var content = encodeURI(encodeURI("内容不能为空"));
                Trafficeye.toPage("objc://showAlert::/"+content); 
            }
        },
        /**
         * 搜索用户请求函数
         */
        reqSumbitbut : function(url, data) {
            var me = this,
                lookfanstabbtnElem = me.elems["lookfanstab"], 
                pageNumMger = me.pageNumManager, //判断是否加载更多
                userlistidElem = me.elems["userlist"];
            var reqParams = Trafficeye.httpData2Str(data);
            //当前结果集请求的结束位置
            var currentEnd = pageNumMger.getEnd();
            //更新下次请求分页起始位置
            pageNumMger.start = currentEnd + 1;
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
                                me.userInfoManager.setInfo(data);
                                //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
                                if (data.friends_counts < pageNumMger.BASE_NUM) {
                                    pageNumMger.setIsShowBtn(false);
                                } else {
                                    pageNumMger.setIsShowBtn(true);
                                }   
                                me.SearchUser.setNewSearchUserData(data.friends);
                                lookfanstabbtnElem.hide();
                                me.setFriendscounts(data.total_counts);
                                var searchhtml = me.SearchUser.getUsersListHtml(data.friends); 
                                me.SearchUser.mergeNewSearchUserData();
                                if((pageNumMger.start/10)==1){
                                    userlistidElem.html(searchhtml);
                                }else{
                                    userlistidElem.append(searchhtml);
                                }
                                    //判断是否显示加载更多按钮
                                if (pageNumMger.getIsShowBtn()) {
                                    me.elems["loadmorebtn"].css("display", "");
                                    me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp(this,false)\";>加载更多</div>");
                                } else {
                                    me.elems["loadmorebtn"].css("display", "none");
                                }
                            } else if(state == -1){
                               var content = encodeURI(encodeURI("未搜索到相关用户"));
                               Trafficeye.toPage("objc://showAlert::/"+content); 
                            } else if(state == -99){
                                me.elems["loadmorebtn"].css("display", "none");
                            }else{

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
            var me = this, 
                looklistbtnElem = me.elems["lookbtn"],
                pageNumMger = me.pageNumManager,
                fanslistbtnElem = me.elems["fansbtn"];
            
            looklistbtnElem.addClass("curr");
            fanslistbtnElem.removeClass("curr");
            var reqParams = Trafficeye.httpData2Str(data);
            
            //当前结果集请求的结束位置
            var currentEnd = pageNumMger.getEnd();
            //更新下次请求分页起始位置
            pageNumMger.start = currentEnd + 1;
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
         * 请求关注信息成功后的处理函数
         * @param  {JSON Object} data
         */
        reqFriendsInfoSuccess : function(data) {
            var me = this,     
                pageNumMger = me.pageNumManager, //判断是否加载更多
                userlistidElem = me.elems["userlist"];
                Trafficeye.httpTip.closed();
            
            if (data) {              
                me.userInfoManager.setInfo(data);
                me.setFriendscounts(data.total_counts);
                //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
               // console.log(data);
                
                me.UserFriends.setNewUserFriendsData(data.friends);
                var friendshtml = me.UserFriends.getFriendsListHtml(data.friends, true);  
                me.UserFriends.mergeNewUserFriendsData();
                
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
                    me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp(this,true)\";>加载更多</div>");
                } else {
                    me.elems["loadmorebtn"].css("display", "none");
                }
            }
        },

         /**
         * 请求粉丝信息
         * @param  {String} url 服务URL
         * @param  {JSON Object} data 请求协议参数对象
         */
        reqfollowersInfo : function(url, data) {
            var me = this,
                looklistbtnElem = me.elems["lookbtn"],
                pageNumMger = me.pageNumManager, //判断是否加载更多
                fanslistbtnElem = me.elems["fansbtn"];

            looklistbtnElem.removeClass("curr");
            fanslistbtnElem.addClass("curr");
            //当前结果集请求的结束位置
            var currentEnd = pageNumMger.getEnd();
            //更新下次请求分页起始位置
            pageNumMger.start = currentEnd + 1;
            
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
                                me.reqfollowersInfoSuccess(data);
                            }else if(data.state.code == -99){//没有加载更多
                                me.reqLoadNo();
                            }else{
                                me.reqfollowersInfoFail(data);
                            }
                        } else {
                            me.reqfollowersInfoFail(data);
                        }
                    }
                })
            }
        },
        /**
         * 请求粉丝用户信息成功后的处理函数
         * @param  {JSON Object} data
         */
        reqfollowersInfoSuccess : function(data) {
            var me = this,     
                pageNumMger = me.pageNumManager, //判断是否加载更多
                userlistidElem = me.elems["userlist"];
                Trafficeye.httpTip.closed();
                
                if (data) {              
                me.userInfoManager.setInfo(data);
                me.setFriendscounts(data.total_counts);
                //判断结果集条目是否与分页基数相等，如果相等，显示加载更多按钮，如果小于，不显示加载更多按钮
                // console.log(data);
                
                me.UserFriends.setNewUserFriendsData(data.friends);
                var friendshtml = me.UserFriends.getFriendsListHtml(data.friends, false);  
                me.UserFriends.mergeNewUserFriendsData();
                if (data.friends_counts < pageNumMger.BASE_NUM ) {
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
                    me.elems["loadmorebtn"].html("<div id=\"loadmorebtn\" onclick=\"loadmorebtnUp(this,true)\";>加载更多</div>");
                } else {
                    me.elems["loadmorebtn"].css("display", "none");
                }
            }
        },

        setFriendscounts : function(friends_counts){
            var me = this;
            var listtotalElem = me.elems["listtotal"];
            listtotalElem.html("共有"+friends_counts+"个人");
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
        loadmorebtnDown : function(evt) {
            this.addClass("bblue");
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
        reqLoadNo : function() {
            Trafficeye.httpTip.closed();
            var me = this;
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
         * 加载更多数据处理函数,当flag为true的时候是请求的关注与粉丝，如果是false，是搜索用户界面
         */
        loadmoreHander : function(uid,flag) {
            var me = this;
            if (uid) {
                var userData = {};
                userData.uid = uid;
                userData.page = me.pageNumManager.getStart()/me.pageNumManager.BASE_NUM;
                userData.count = me.pageNumManager.BASE_NUM;
                //userData.start = me.pageNumManager.getStart();
                //userData.end = me.pageNumManager.getEnd();
                
                if(flag){
                    var lookfansPageFlag = Trafficeye.offlineStore.get("traffic_lookfans");
                    //请求关注与粉丝用户信息协议
                    var reqUrl = BASE_URL + "friends";
                    userData.friend_id = uid;
                    var reqData = userData;
                    if (lookfansPageFlag == "fans") {
                        reqUrl = BASE_URL + "followers";
                        me.reqfollowersInfo(reqUrl, reqData);
                    } else {
                        //请求关注数据
                        me.reqFriendsInfo(reqUrl, reqData);
                    }
                }else{//请求搜索用户结果界面
                    var textContent = me.elems["inputsearch"].attr("value");
                    if(textContent){
                        userData.nickName = textContent;
                        var sumbitBtnUp_url = BASE_SEARCH_URL + "searchUser";
                        var sumbitBtnUp_data = userData;
                        me.reqSumbitbut(sumbitBtnUp_url, sumbitBtnUp_data);
                    }else{
                        var content = encodeURI(encodeURI("内容不能为空"));
                        Trafficeye.toPage("objc://showAlert::/"+content); 
                    }
                }
            }
        },
        /**
         * 请求关注信息失败后的处理函数
         */
        reqFriendsInfoFail : function(data) {
            var me = this;
            Trafficeye.httpTip.closed();
            var html = [];
            html.push("<div class='qplnone'>"+data.state.desc+"</div>");
            me.elems["userlist"].append(html.join(""));
        },
        /**
         * 请求粉丝信息失败后的处理函数
         */
        reqfollowersInfoFail : function(data) {
            var me = this;
            Trafficeye.httpTip.closed();
            var html = [];
            html.push("<div class='qplnone'>"+data.state.desc+"</div>");
            me.elems["userlist"].append(html.join(""));
        },

        setHeaderName : function() {
            var me = this;
            var headerNameElem = me.elems["headername"];
            headerNameElem.html(me.myInfo.username);
        },

        setHeaderImg : function() {
            var me = this;
            var headerImgElem = me.elems["headerimg"];
            headerImgElem.attr("src", me.myInfo.avatar);
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
                            //me.reqUserInfoFail();
                        }
                    }
                })
            }
        },
        
        /**
         * 请求用户信息成功后的处理函数
         * @param  {JSON Object} data
         */
        reqUserInfoSuccess : function(data, userData) {
            var me = this;
            if (data) {
                me.userInfoManager.setInfo(data);
                var userName = data.username;
                var avatar = data.avatar;
                var gender = data.gender;
                var userType = data.usertype;
                var lookNum = data.friends_count;
                var fansNum = data.followers_count;
                                //存储本人的信息                
                data.uid = userData.uid;
                data.pid = userData.pid;
                var dataStr = Trafficeye.json2Str(data);
                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
                
                if(avatar){
                    var headerImgElem = me.elems["headerimg"];
                    headerImgElem.attr("src", avatar);
                }
                if(userName){
                    var headerNameElem = me.elems["headername"];
                    headerNameElem.html(userName);
                }
            }
        }
    };

    //基础URL
    var BASE_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/friendships/";
    var BASE_SEARCH_URL = "http://mobile.trafficeye.com.cn:"+Trafficeye.UrlPort+"/TrafficeyeCommunityService/sns/v1/user/";
    $(function(){        
        
        // 获取从个人项目跳转过来的数据，回调函数
        window.personalGotoCommunityPage  = function(dataClient){

            Trafficeye.httpTip.closed();
            var dataStr = Trafficeye.str2Json(dataClient);
            var data ={
                "uid" : dataStr.uid,
                "pid" : dataStr.pid
            }
            var dataSource = Trafficeye.json2Str(data);
            Trafficeye.offlineStore.set("traffic_myinfo", dataSource);
            Trafficeye.offlineStore.set("traffic_lookfans",dataStr.traffic_lookfans);
            Trafficeye.offlineStore.set("traffic_fromsource",dataStr.prepage);
            window.initPageManager();
        };
            
        window.initPageManager = function(){
            //获取我的用户信息, by dongyl
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }

            //look表示点击关注按钮跳转过来的，fans表示点击粉丝按钮跳转过来的
            var lookfansPageFlag = Trafficeye.offlineStore.get("traffic_lookfans");

            var pm = new PageManager();
            
            
            //初始化用户界面
            pm.init();
            
            Trafficeye.pageManager=pm;
            
            pm.myInfo = myInfo;
            
            var userInfo_url = BASE_SEARCH_URL + "userinfo";
            var userInfo_data = {
                "uid" : myInfo.uid,
                "pid" : myInfo.pid || 0
            };
            
            if(myInfo.avatar == null || myInfo.username == null){
                pm.reqUserInfo(userInfo_url, userInfo_data);
            }
            
            if(myInfo.avatar){
                pm.setHeaderImg();
            }
            if(myInfo.username){
                pm.setHeaderName();
            }
            
            //请求用户信息协议
            var reqUrl = BASE_URL + "friends";
            var reqData = {"uid" : myInfo.uid ,"friend_id" : myInfo.uid};
            if (lookfansPageFlag == "fans") {
                reqUrl = BASE_URL + "followers";
                pm.reqfollowersInfo(reqUrl, reqData);
            } else {
                //请求关注数据
                pm.reqFriendsInfo(reqUrl, reqData);
            }
        };
            
        window.gotoTimeline = function(uid,evt) {
           var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.lookOtherTimeline(uid,evt);
            }
        };

        window.removeFans = function(uid) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.removeFans(uid);
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
        
        window.loadmorebtnUp = function(evt,flag) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.loadmorebtnUp(evt,flag);
            }
        };
        
        window.headimgbtnUp = function(evt) {
            var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.headimgbtnUp(evt);
            }
        };
        
        window.initPageManager();
        //window.personalGotoCommunityPage("{\"prepage\":\"trafficeye_personal\",\"pid\":\"7A0743A7-DD4A-426C-901D-4C9B143465A5\",\"uid\":\"3862\",\"uidFriend\":\"3862\",\"traffic_lookfans\":\"look\"}");
    //window.personalGotoCommunityPage('{\"prepage\":\"trafficeye_personal\",\"pid\":\"7A0743A7-DD4A-426C-901D-4C9B143465A5\",\"uid\":\"3862\",\"uidFriend\":\"3862\",\"traffic_lookfans\":\"look\"}');
   // window.callbackInitPage(1,'{\"avatarUrl\":\"http://mobile.trafficeye.com.cn/media/test/avatars/40307/2014/04/1398862648379imageL.jpg\",\"wxNum\":\"\",\"level\":0,\"eventNum\":0,\"mobile\":\"\",\"frineds\":2,\"idNum\":\"\",\"totalMilage\":-0,\"nextLevel\":1,\"city\":\"\",\"realName\":\"\",\"ownedBadges\":[{\"name\":\"新人徽章\",\"id\":1,\"obtainTime\":\"2014-04-30 20:58:06\",\"smallImgName\":\"badge_register.png\",\"imgName\":\"badge_big_register.png\",\"desc\":\"注册账号\"}],\"email\":\"\",\"totalBadges\":30,\"totalTrackMilage\":-0,\"fans\":0,\"carNum\":\"\",\"totalCoins\":0,\"username\":\"太初\",\"userType\":\"qzone\",\"levelPoint\":0,\"levelPercent\":36,\"uid\":\"40307\",\"birthdate\":\"2014-04-30\",\"gender\":\"M\",\"totalPoints\":11,\"nextLevelPoint\":30,\"mobileValidate\":0,\"qq\":\"\",\"description\":\"\",\"badgeNum\":1}',2,'I_7.1,i_2.2.4','BF110ED4-CCD7-40DF-8733-334A99B2F21E','{\"uid\":\"3862\",\"friend_uid\":\"469\"}');
    }); 
    
 }(window));