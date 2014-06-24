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

    function PageManager() {
        //ID元素对象集合
        this.elems = {
            "backpagebtn" : null,
            "mail" : null,
            "nickname" : null,
            "pwd" : null,
            "registerbtn" : null
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
                backpagebtnElem = me.elems["backpagebtn"];
            //返回按钮
            backpagebtnElem.onbind("touchstart",me.btnDown,backpagebtnElem);
            backpagebtnElem.onbind("touchend",me.backpagebtnUp,me);
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
            // console.log(fromSource);
            Trafficeye.toPage(fromSource.sourcepage);
        },
        /**
         * 注册请求函数
         */
        reqRegisterbtnUp : function(evt) {
            var me = this;
            
            var myInfo = Trafficeye.getMyInfo();
            if (!myInfo) {
                return;
            }
          
            var pid = myInfo.pid;
            var ua = myInfo.ua;

            var textMail = me.elems["mail"].attr("value");
            var textNickname = me.elems["nickname"].attr("value");
            var textPwd = me.elems["pwd"].attr("value");
            // var regMail ="/^[a-zA-Z0-9_-]+\@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/";
            var regMail=/^\w+([-\.]\w+)*@\w+([\.-]\w+)*\.\w{2,4}$/;
             //判断邮箱格式，昵称长度，密码长度是否符合《路况交通眼账号系统字段规则》
             if(!regMail.test(textMail)){
                Trafficeye.trafficeyeAlert("邮箱格式有误,请您重新输入");
                return;
             }
             if(textNickname.length>30 || textNickname.length < 2)
             {
                Trafficeye.trafficeyeAlert("昵称请您输入2-30个字符");
                return;
             }
             if(textPwd.length>16 || textPwd.length < 6)
             {
                Trafficeye.trafficeyeAlert("密码请您输入6-16个字符");
                return;
             }
         
            var registerBtnUp_url = Trafficeye.BASE_USER_URL + "register";
            var registerBtnUp_data = {
                "ua" : ua,
                "pid" : pid,
                "username" : textNickname,
                "passwd" : textPwd,
                "email" : textMail
            };
            me.reqRegisterbut(registerBtnUp_url, registerBtnUp_data);
            
        },
        /**
         * 注册用户请求函数
         */
        reqRegisterbut : function(url, data) {
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
                                
                                var myInfo = Trafficeye.getMyInfo();
                                //把用户信息写入到本地
                                //pid,ua,userinfo存入到浏览器本地缓存
                                var userinfodata = {
                                    "pid" : myInfo.pid,
                                    "ua" : myInfo.ua,
                                    "uid" : data.state.uid,
                                    "friend_uid" : data.userInfo.uid,
                                    "isEdit" : myInfo.isEdit,
                                    "userinfo" : data.userInfo
                                };
                                var dataStr = Trafficeye.json2Str(userinfodata);
                                Trafficeye.offlineStore.set("traffic_myinfo", dataStr);
                                //写入用户信息和徽章，里程信息到浏览器缓存
                                
                                var dataReward = Trafficeye.json2Str(data.reward);
                                var dataUserInfo = Trafficeye.json2Str(data.userInfo);
                                Trafficeye.offlineStore.set("traffic_reward",dataReward);
                                if (Trafficeye.mobilePlatform.android) {
                                    window.JSAndroidBridge.updateUserInfo(dataUserInfo,dataReward);
                                } else if (Trafficeye.mobilePlatform.iphone || Trafficeye.mobilePlatform.ipad) {
                                    var rewardContent = encodeURI(encodeURI(dataReward));
                                    var content = encodeURI(encodeURI(dataUserInfo));
                                    window.location.href = ("objc:??updateUserInfo::?"+content+":?"+rewardContent);
                                } else {
                                    alert("调用修改用户信息接口,PC不支持.");
                                }
                                Trafficeye.toPage("pre_info.html");
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
        //注册的onclick事件响应函数
        registerfun : function(evt) {
            var me = this;
            $(evt).addClass("curr");
            var elem = $(evt).addClass("curr");
            setTimeout((function(){
                $(elem).removeClass("curr");  
                me.reqRegisterbtnUp(evt);//注册请求处理函数
            }),Trafficeye.MaskTimeOut);     
        }
    };
    
    $(function(){
       
        //把来源信息存储到本地
         var presource = Trafficeye.fromSource();
         var fromSource = {"sourcepage" : presource.sourcepage,"currpage" : "pre_register.html","prepage" : presource.currpage}
         var fromSourceStr = Trafficeye.json2Str(fromSource);
         Trafficeye.offlineStore.set("traffic_fromsource", fromSourceStr);
         
         //获取我的用户信息, by dongyl
        var myInfo = Trafficeye.getMyInfo();
        
        var pm = new PageManager();

        Trafficeye.pageManager = pm;
        //初始化用户界面
        pm.init();
        pm.myInfo = myInfo;
        
        window.registerfun = function(evt) {
             var pm = Trafficeye.pageManager;
            if (pm.init) {
                pm.registerfun(evt);
            }
        };
    }); 
    
 }(window));